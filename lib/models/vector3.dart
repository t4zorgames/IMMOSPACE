import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vmath;

/// Custom Vector3 class representing coordinates in a 3D space.
class Vector3 {
  final double x;
  final double y;
  final double z;

  const Vector3(this.x, this.y, this.z);

  /// Operator overloading for vector addition.
  Vector3 operator +(Vector3 other) {
    return Vector3(x + other.x, y + other.y, z + other.z);
  }

  /// Operator overloading for vector subtraction.
  Vector3 operator -(Vector3 other) {
    return Vector3(x - other.x, y - other.y, z - other.z);
  }

  /// Operator overloading for scalar multiplication.
  Vector3 operator *(double scalar) {
    return Vector3(x * scalar, y * scalar, z * scalar);
  }

  /// Calculates the magnitude (length) of the vector.
  double magnitude() {
    return math.sqrt(x * x + y * y + z * z);
  }

  /// Returns a normalized (unit length) vector.
  Vector3 normalized() {
    final double mag = magnitude();
    if (mag == 0.0) {
      return const Vector3(0.0, 0.0, 0.0);
    }
    return Vector3(x / mag, y / mag, z / mag);
  }

  /// Converts this custom Vector3 to a vector_math Vector3.
  vmath.Vector3 toVectorMath() {
    return vmath.Vector3(x, y, z);
  }

  /// Creates a custom Vector3 from a vector_math Vector3.
  static Vector3 fromVectorMath(vmath.Vector3 v) {
    return Vector3(v.x, v.y, v.z);
  }

  @override
  String toString() => 'Vector3($x, $y, $z)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vector3 &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          z == other.z;

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}
