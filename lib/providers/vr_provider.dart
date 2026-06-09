import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_math/vector_math_64.dart' as v3;
import '../models/room.dart';
import '../models/enums.dart';

/// Provider for managing state, active room selection, and sensor rotation in VR panorama.
class VRProvider with ChangeNotifier {
  Room? _currentRoom;
  bool _gyroscopeAvailable = false;
  bool _accelerometerAvailable = false;
  ControlMode _controlMode = ControlMode.DRAG;
  v3.Vector3 _panoramaRotation = v3.Vector3(0, 0, 0); // x: pitch, y: yaw, z: roll

  // Stream Subscriptions
  StreamSubscription<GyroscopeEvent>? _gyroSubscription;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;

  // Sizing anchors for screen drag normalizations
  double _screenWidth = 360.0;
  double _screenHeight = 640.0;

  // Timestamp for calculating dt (delta time)
  DateTime? _lastGyroTime;

  // Getters
  Room? get currentRoom => _currentRoom;
  bool get gyroscopeAvailable => _gyroscopeAvailable;
  bool get accelerometerAvailable => _accelerometerAvailable;
  ControlMode get controlMode => _controlMode;
  v3.Vector3 get panoramaRotation => _panoramaRotation;

  // Setters/Mutations
  set screenWidth(double val) => _screenWidth = val;
  set screenHeight(double val) => _screenHeight = val;

  VRProvider() {
    // Select the first room from availableRooms by default
    if (Room.availableRooms.isNotEmpty) {
      _currentRoom = Room.availableRooms.first;
    }
  }

  /// Initializes the motion sensors and decides the best ControlMode automatically.
  void initializeSensors() {
    // Cancel existing streams to prevent memory leaks
    _gyroSubscription?.cancel();
    _accelSubscription?.cancel();
    _lastGyroTime = null;

    // Test Gyroscope
    try {
      _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        if (!_gyroscopeAvailable) {
          _gyroscopeAvailable = true;
          _controlMode = ControlMode.GYROSCOPE;
          notifyListeners();
        }
        if (_controlMode == ControlMode.GYROSCOPE) {
          updateRotationFromGyroscope(event);
        }
      }, onError: (_) {
        _gyroscopeAvailable = false;
      });
    } catch (_) {
      _gyroscopeAvailable = false;
    }

    // Test Accelerometer (fallback)
    try {
      _accelSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
        if (!_gyroscopeAvailable) {
          if (!_accelerometerAvailable) {
            _accelerometerAvailable = true;
            _controlMode = ControlMode.ACCELEROMETER;
            notifyListeners();
          }
          if (_controlMode == ControlMode.ACCELEROMETER) {
            updateRotationFromAccelerometer(event);
          }
        }
      }, onError: (_) {
        _accelerometerAvailable = false;
      });
    } catch (_) {
      _accelerometerAvailable = false;
    }

    // Default to DRAG if no hardware sensors responded
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_gyroscopeAvailable && !_accelerometerAvailable && _controlMode != ControlMode.DRAG) {
        _controlMode = ControlMode.DRAG;
        notifyListeners();
      }
    });
  }

  /// Sets the currently active room to visit.
  void selectRoom(Room room) {
    _currentRoom = room;
    notifyListeners();
  }

  /// Formulates rotation from Gyroscope angular velocity values.
  void updateRotationFromGyroscope(GyroscopeEvent event) {
    final DateTime now = DateTime.now();
    if (_lastGyroTime != null) {
      final double dt = now.difference(_lastGyroTime!).inMicroseconds / 1000000.0;
      
      // Convert rad/s angular speed to degrees and accumulate
      // event.y: yaw, event.x: pitch
      double deltaYaw = event.y * (180.0 / math.pi) * dt;
      double deltaPitch = event.x * (180.0 / math.pi) * dt;

      double newYaw = _panoramaRotation.y - deltaYaw; // Invert to follow movement direction
      double newPitch = _panoramaRotation.x + deltaPitch;

      // Clamp pitch between -90 and 90 degrees
      newPitch = newPitch.clamp(-85.0, 85.0);
      
      // Wrap yaw between -180 and 180 degrees
      if (newYaw > 180.0) newYaw -= 360.0;
      if (newYaw < -180.0) newYaw += 360.0;

      _panoramaRotation = v3.Vector3(newPitch, newYaw, 0.0);
      notifyListeners();
    }
    _lastGyroTime = now;
  }

  /// Formulates rotation from Accelerometer linear acceleration values.
  void updateRotationFromAccelerometer(AccelerometerEvent event) {
    // Calculate pitch and roll angles from gravity components
    double accelX = event.x;
    double accelY = event.y;
    double accelZ = event.z;

    double divisor = math.sqrt(accelX * accelX + accelZ * accelZ);
    if (divisor == 0.0) divisor = 0.001; // Avoid division by zero

    // Pitch (rotation around X-axis)
    double pitch = math.atan2(accelY, divisor) * (180.0 / math.pi);
    // Roll (rotation around Z-axis)
    double roll = math.atan2(accelX, accelZ) * (180.0 / math.pi);

    // Filter values slightly to avoid micro-jitters
    pitch = pitch.clamp(-85.0, 85.0);

    // Accelerometer only yields pitch and roll (no true compass yaw direction)
    // We update pitch and roll, leaving yaw to drag control or drift values
    _panoramaRotation = v3.Vector3(pitch, _panoramaRotation.y, roll);
    notifyListeners();
  }

  /// Formulates rotation from screen Drag events.
  void updateRotationFromDrag(Offset delta) {
    // Map screen pixel drag to panorama longitude (yaw) and latitude (pitch) degrees
    double deltaYaw = (delta.dx / _screenWidth) * 180.0; // multiplier to adjust sensitivity
    double deltaPitch = (delta.dy / _screenHeight) * 90.0;

    double newYaw = _panoramaRotation.y - deltaYaw;
    double newPitch = _panoramaRotation.x + deltaPitch;

    newPitch = newPitch.clamp(-85.0, 85.0);

    if (newYaw > 180.0) newYaw -= 360.0;
    if (newYaw < -180.0) newYaw += 360.0;

    _panoramaRotation = v3.Vector3(newPitch, newYaw, 0.0);
    notifyListeners();
  }

  /// Sets the control mode explicitly.
  void setControlMode(ControlMode mode) {
    _controlMode = mode;
    notifyListeners();
  }

  /// Returns descriptive label for the current control mode.
  String getControlModeLabel() {
    switch (_controlMode) {
      case ControlMode.GYROSCOPE:
        return "📡 Gyroscope";
      case ControlMode.ACCELEROMETER:
        return "⚖️ Accelerometer";
      case ControlMode.DRAG:
        return "👆 Drag";
    }
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    _accelSubscription?.cancel();
    super.dispose();
  }
}
