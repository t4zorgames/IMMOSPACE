/// Enum representing categories of furniture available.
enum FurnitureCategory {
  chair,
  table,
  lamp;

  /// Helper to convert a string representation to the enum value.
  static FurnitureCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'chair':
      case 'assises':
      case 'sièges':
        return FurnitureCategory.chair;
      case 'table':
      case 'tables':
        return FurnitureCategory.table;
      case 'lamp':
      case 'luminaires':
        return FurnitureCategory.lamp;
      default:
        return FurnitureCategory.chair;
    }
  }

  /// Converts the enum to its standard display or JSON string.
  String toJson() => name;
  
  /// Gets a localized display name in French.
  String get displayName {
    switch (this) {
      case FurnitureCategory.chair:
        return 'Sièges';
      case FurnitureCategory.table:
        return 'Tables';
      case FurnitureCategory.lamp:
        return 'Luminaires';
    }
  }
}

/// Model class representing a piece of furniture in ImmoSpace.
class Furniture {
  final String id;
  final String name;
  final String description;
  final double price;
  final FurnitureCategory category;
  final String model3dAsset; // GLB model format (local path)
  final String thumbnailUrl;
  final Map<String, double> dimensions; // width, height, depth

  const Furniture({
    this.id = '',
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.category = FurnitureCategory.chair,
    this.model3dAsset = '',
    this.thumbnailUrl = '',
    this.dimensions = const {'width': 0.0, 'height': 0.0, 'depth': 0.0},
  });

  /// Creates a copy of this Furniture with modified properties.
  Furniture copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    FurnitureCategory? category,
    String? model3dAsset,
    String? thumbnailUrl,
    Map<String, double>? dimensions,
  }) {
    return Furniture(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      model3dAsset: model3dAsset ?? this.model3dAsset,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      dimensions: dimensions ?? this.dimensions,
    );
  }

  /// Factory constructor to construct a Furniture instance from a JSON map.
  factory Furniture.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> dimMap = json['dimensions'] as Map<String, dynamic>? ?? {};
    final Map<String, double> parsedDimensions = {
      'width': (dimMap['width'] as num?)?.toDouble() ?? 0.0,
      'height': (dimMap['height'] as num?)?.toDouble() ?? 0.0,
      'depth': (dimMap['depth'] as num?)?.toDouble() ?? 0.0,
    };

    return Furniture(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: FurnitureCategory.fromString(json['category'] as String? ?? 'chair'),
      model3dAsset: json['model3dAsset'] as String? ?? json['model3dUrl'] as String? ?? json['modelUrl'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      dimensions: parsedDimensions,
    );
  }

  /// Converts this Furniture instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category.toJson(),
      'model3dAsset': model3dAsset,
      'thumbnailUrl': thumbnailUrl,
      'dimensions': dimensions,
    };
  }
}
