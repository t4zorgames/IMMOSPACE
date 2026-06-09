import 'vector3.dart';

/// Represents a detected plane in AR tracking.
class Plane {
  final Vector3 position;
  final Vector3 normal;

  const Plane({
    required this.position,
    required this.normal,
  });
}
