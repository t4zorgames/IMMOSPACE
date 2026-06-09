import 'furniture.dart';

/// Model class representing a room in a virtual property visit.
class Room {
  final String id;
  final String name;
  final String panoramaAsset; // Path to the local 360 panorama image
  final List<Furniture> furniture;

  const Room({
    this.id = '',
    this.name = '',
    this.panoramaAsset = '',
    this.furniture = const [],
  });

  /// Factory constructor to parse a Room instance from a JSON map.
  factory Room.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? furnListJson = json['furniture'] as List<dynamic>?;
    final List<Furniture> parsedFurniture = furnListJson != null
        ? furnListJson
            .map((item) => Furniture.fromJson(item as Map<String, dynamic>))
            .toList()
        : const [];

    return Room(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      panoramaAsset: json['panoramaAsset'] as String? ?? json['panoramaUrl'] as String? ?? '',
      furniture: parsedFurniture,
    );
  }

  /// Converts this Room instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'panoramaAsset': panoramaAsset,
      'furniture': furniture.map((item) => item.toJson()).toList(),
    };
  }

  /// Statically available default rooms for sensor integration testing
  static final List<Room> availableRooms = [
    const Room(
      id: 'room_white',
      name: 'Modern White Apartment',
      panoramaAsset: 'assets/images/AppartementWhite.jpg',
      furniture: [],
    ),
    const Room(
      id: 'room_modern',
      name: 'Modern Living Room',
      panoramaAsset: 'assets/images/AppartementModerne.jpg',
      furniture: [],
    ),
    const Room(
      id: 'room_vacation',
      name: 'Vacation Bedroom',
      panoramaAsset: 'assets/images/AppartementVacance.jpg',
      furniture: [],
    ),
  ];
}
