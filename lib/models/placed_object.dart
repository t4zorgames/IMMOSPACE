import 'vector3.dart';

/// Represents a placed 3D model node in AR space.
class PlacedObject {
  final String furnitureId;
  final Vector3 position;
  final double rotation;

  const PlacedObject({
    required this.furnitureId,
    required this.position,
    required this.rotation,
  });
}
