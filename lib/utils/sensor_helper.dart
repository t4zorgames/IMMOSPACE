import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/enums.dart';

/// Helper class for managing sensor checks and permissions.
class SensorHelper {
  /// Checks availability of physical gyroscope and accelerometer sensors.
  static Future<Map<String, bool>> checkSensors() async {
    bool gyro = false;
    bool accel = false;

    try {
      final subscription = gyroscopeEvents.listen((event) {});
      gyro = true;
      await subscription.cancel();
    } catch (_) {
      gyro = false;
    }

    try {
      final subscription = accelerometerEvents.listen((event) {});
      accel = true;
      await subscription.cancel();
    } catch (_) {
      accel = false;
    }

    return {
      'gyroscope': gyro,
      'accelerometer': accel,
    };
  }

  /// Requests permission to access motion sensors.
  static Future<bool> requestPermissions() async {
    final status = await Permission.sensors.request();
    return status.isGranted;
  }

  /// Translates ControlMode enum to readable French description.
  static String getControlModeDescription(ControlMode mode) {
    switch (mode) {
      case ControlMode.GYROSCOPE:
        return "Détection par mouvement (Gyroscope)";
      case ControlMode.ACCELEROMETER:
        return "Détection par inclinaison (Accéléromètre)";
      case ControlMode.DRAG:
        return "Navigation par glissement tactile (Drag)";
    }
  }
}
