import 'furniture.dart';

class RoomPano {
  final String name; // e.g. "Salon", "Chambre", "Cuisine", "Douche"
  final String panoramaAsset;

  const RoomPano({
    required this.name,
    required this.panoramaAsset,
  });

  factory RoomPano.fromJson(Map<String, dynamic> json) {
    return RoomPano(
      name: json['name'] as String? ?? '',
      panoramaAsset: json['panoramaAsset'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'panoramaAsset': panoramaAsset,
    };
  }
}

class Property {
  final String id;
  final String name;
  final String coverAsset;
  final String priceString; // e.g. "$4k", "$320k", "$180k"
  final int bedrooms;
  final String location; // e.g. "Paris, France"
  final List<RoomPano> rooms;
  final List<Furniture> furniture;

  const Property({
    required this.id,
    required this.name,
    required this.coverAsset,
    required this.priceString,
    required this.bedrooms,
    required this.location,
    required this.rooms,
    required this.furniture,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? roomsJson = json['rooms'] as List<dynamic>?;
    final List<RoomPano> parsedRooms = roomsJson != null
        ? roomsJson.map((item) => RoomPano.fromJson(item as Map<String, dynamic>)).toList()
        : const [];

    final List<dynamic>? furnListJson = json['furniture'] as List<dynamic>?;
    final List<Furniture> parsedFurniture = furnListJson != null
        ? furnListJson
            .map((item) => Furniture.fromJson(item as Map<String, dynamic>))
            .toList()
        : const [];

    return Property(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      coverAsset: json['coverAsset'] as String? ?? '',
      priceString: json['priceString'] as String? ?? '',
      bedrooms: json['bedrooms'] as int? ?? 0,
      location: json['location'] as String? ?? '',
      rooms: parsedRooms,
      furniture: parsedFurniture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coverAsset': coverAsset,
      'priceString': priceString,
      'bedrooms': bedrooms,
      'location': location,
      'rooms': rooms.map((item) => item.toJson()).toList(),
      'furniture': furniture.map((item) => item.toJson()).toList(),
    };
  }
}
