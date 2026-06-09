import 'package:flutter/material.dart';
import '../models/furniture.dart';
import '../models/plane.dart';
import '../models/placed_object.dart';
import '../models/vector3.dart';

/// State status for the AR Environment session
enum ARSessionStatus {
  idle,
  initializing,
  ready,
  failed,
}

/// Provider for managing state, plane detection, and placing objects in AR.
class ARProvider with ChangeNotifier {
  final List<Plane> _detectedPlanes = [];
  final List<PlacedObject> _placedObjects = [];
  bool _isDetecting = true;

  List<Plane> get detectedPlanes => _detectedPlanes;
  List<PlacedObject> get placedObjects => _placedObjects;
  bool get isDetecting => _isDetecting;

  /// Places a furniture item at a specific 3D coordinate vector.
  void placeObject(Vector3 position, Furniture furniture) {
    _placedObjects.add(
      PlacedObject(
        furnitureId: furniture.id,
        position: position,
        rotation: 0.0,
      ),
    );
    notifyListeners();
  }

  /// Moves the placed object at [index] to a new 3D position vector.
  void moveObject(int index, Vector3 newPosition) {
    if (index >= 0 && index < _placedObjects.length) {
      final oldObj = _placedObjects[index];
      _placedObjects[index] = PlacedObject(
        furnitureId: oldObj.furnitureId,
        position: newPosition,
        rotation: oldObj.rotation,
      );
      notifyListeners();
    }
  }

  /// Rotates the placed object at [index] by a specified [angle] in radians.
  void rotateObject(int index, double angle) {
    if (index >= 0 && index < _placedObjects.length) {
      final oldObj = _placedObjects[index];
      _placedObjects[index] = PlacedObject(
        furnitureId: oldObj.furnitureId,
        position: oldObj.position,
        rotation: angle,
      );
      notifyListeners();
    }
  }

  /// Sets whether the plane detection mode is active.
  void setDetecting(bool detecting) {
    _isDetecting = detecting;
    notifyListeners();
  }

  /// Adds a detected plane for testing/UI.
  void addDetectedPlane(Plane plane) {
    _detectedPlanes.add(plane);
    notifyListeners();
  }

  /// Resets all placed items and plane tracking.
  void clearARState() {
    _detectedPlanes.clear();
    _placedObjects.clear();
    _isDetecting = true;
    notifyListeners();
  }

  // ==========================================
  // Backward compatibility layers for ar_screen
  // ==========================================

  ARSessionStatus _status = ARSessionStatus.idle;
  bool _isPlacingNode = false;
  bool _planeDetected = false;
  String _statusMessage = 'Initialisation de la RA...';
  final List<String> _placedFurnitureIds = [];

  ARSessionStatus get status => _status;
  bool get isPlacingNode => _isPlacingNode;
  bool get planeDetected => _planeDetected;
  String get statusMessage => _statusMessage;
  List<String> get placedFurnitureIds => _placedFurnitureIds;

  void setStatus(ARSessionStatus newStatus, {String? customMessage}) {
    _status = newStatus;
    if (customMessage != null) {
      _statusMessage = customMessage;
    } else {
      switch (newStatus) {
        case ARSessionStatus.idle:
          _statusMessage = 'Prêt à démarrer';
          break;
        case ARSessionStatus.initializing:
          _statusMessage = 'Recherche du sol en cours... Balayez la pièce lentement.';
          break;
        case ARSessionStatus.ready:
          _statusMessage = 'Sol détecté ! Touchez l\'écran pour placer le meuble.';
          break;
        case ARSessionStatus.failed:
          _statusMessage = 'Échec de l\'initialisation de la RA. Veuillez réessayer.';
          break;
      }
    }
    notifyListeners();
  }

  void setPlaneDetected(bool detected) {
    _planeDetected = detected;
    if (detected && _status == ARSessionStatus.initializing) {
      setStatus(ARSessionStatus.ready);
    } else if (!detected && _status == ARSessionStatus.ready) {
      setStatus(ARSessionStatus.initializing);
    } else {
      notifyListeners();
    }
  }

  void setPlacingNode(bool placing) {
    _isPlacingNode = placing;
    notifyListeners();
  }

  void addPlacedFurniture(String furnitureId) {
    _placedFurnitureIds.add(furnitureId);
    notifyListeners();
  }

  void resetARSession() {
    _status = ARSessionStatus.idle;
    _isPlacingNode = false;
    _planeDetected = false;
    _statusMessage = 'Prêt à démarrer';
    _placedFurnitureIds.clear();
    clearARState();
  }
}
