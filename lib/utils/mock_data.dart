import 'dart:convert';

/// Utility class holding raw mock data in JSON format for easy serialization.
class MockData {
  /// Raw JSON string representing 5 furniture items with local asset links.
  static const String furnitureRawJson = r'''
  [
    {
      "id": "furniture_001",
      "name": "Black Leather Armchair",
      "description": "Luxury black leather armchair with modern design",
      "price": 599.99,
      "category": "Chair",
      "categoryFr": "Sièges",
      "model3dAsset": "assets/models/black_leather_chair.glb",
      "thumbnailUrl": "",
      "dimensions": {
        "width": 0.85,
        "height": 0.95,
        "depth": 0.75
      }
    },
    {
      "id": "furniture_002",
      "name": "Modern Coffee Table",
      "description": "Contemporary glass and metal coffee table",
      "price": 299.99,
      "category": "Table",
      "categoryFr": "Tables",
      "model3dAsset": "assets/models/metal_and_glass_coffee_table.glb",
      "thumbnailUrl": "",
      "dimensions": {
        "width": 0.894,
        "height": 0.547,
        "depth": 1.981
      }
    },
    {
      "id": "furniture_003",
      "name": "LED Floor Lamp",
      "description": "Modern adjustable LED floor lamp with brushed metal finish",
      "price": 149.99,
      "category": "Lamp",
      "categoryFr": "Luminaires",
      "model3dAsset": "assets/models/mordern_lamp___jpgstlglb_formats_available.glb",
      "thumbnailUrl": "",
      "dimensions": {
        "width": 0.4,
        "height": 1.5,
        "depth": 0.4
      }
    },
    {
      "id": "furniture_004",
      "name": "3-Seater Sofa",
      "description": "Contemporary 3-seater sofa with elegant design",
      "price": 899.99,
      "category": "Chair",
      "categoryFr": "Sièges",
      "model3dAsset": "assets/models/kungshult_3-seater_sofa.glb",
      "thumbnailUrl": "",
      "dimensions": {
        "width": 2.1,
        "height": 0.85,
        "depth": 0.95
      }
    },
    {
      "id": "furniture_005",
      "name": "Work Desk",
      "description": "Modern office work desk with wood and metal construction",
      "price": 399.99,
      "category": "Table",
      "categoryFr": "Tables",
      "model3dAsset": "assets/models/desk.glb",
      "thumbnailUrl": "",
      "dimensions": {
        "width": 1.4,
        "height": 0.75,
        "depth": 0.7
      }
    }
  ]
  ''';

  /// Raw JSON string representing 2 properties containing their rooms and furniture list directly.
  static const String propertiesRawJson = r'''
  [
    {
      "id": "p1",
      "name": "Modern White Apartment",
      "coverAsset": "assets/images/Cover/AppartementWhite_Cover.jpeg",
      "priceString": "$4k",
      "bedrooms": 3,
      "location": "Paris, France",
      "rooms": [
        {"name": "Salon", "panoramaAsset": "assets/images/AppartementWhite/AppartementWhite_Salon.jpeg"},
        {"name": "Chambre", "panoramaAsset": "assets/images/AppartementWhite/AppartementWhite_Chambre.jpeg"},
        {"name": "Cuisine", "panoramaAsset": "assets/images/AppartementWhite/AppartementWhite_Cuisine.jpeg"},
        {"name": "Douche", "panoramaAsset": "assets/images/AppartementWhite/AppartementWhite_Douche.jpeg"}
      ],
      "furniture": [
        {
          "id": "furniture_001",
          "name": "Black Leather Armchair",
          "description": "Luxury black leather armchair with modern design",
          "price": 599.99,
          "category": "Chair",
          "categoryFr": "Sièges",
          "model3dAsset": "assets/models/black_leather_chair.glb",
          "thumbnailUrl": "",
          "dimensions": {
            "width": 0.85,
            "height": 0.95,
            "depth": 0.75
          }
        },
        {
          "id": "furniture_002",
          "name": "Modern Coffee Table",
          "description": "Contemporary glass and metal coffee table",
          "price": 299.99,
          "category": "Table",
          "categoryFr": "Tables",
          "model3dAsset": "assets/models/metal_and_glass_coffee_table.glb",
          "thumbnailUrl": "",
          "dimensions": {
            "width": 0.894,
            "height": 0.547,
            "depth": 1.981
          }
        }
      ]
    },
    {
      "id": "p2",
      "name": "Modern Living Room",
      "coverAsset": "assets/images/Cover/AppartementModerne_Cover.jpeg",
      "priceString": "$320k",
      "bedrooms": 2,
      "location": "New York, USA",
      "rooms": [
        {"name": "Salon", "panoramaAsset": "assets/images/AppartementModerne/AppartementModerne_Salon.jpg"},
        {"name": "Chambre", "panoramaAsset": "assets/images/AppartementModerne/AppartementModerne_Chambre.jpeg"},
        {"name": "Cuisine", "panoramaAsset": "assets/images/AppartementModerne/AppartementModerne_Cuisine.jpeg"},
        {"name": "Douche", "panoramaAsset": "assets/images/AppartementModerne/AppartementModerne_Douche.jpeg"}
      ],
      "furniture": [
        {
          "id": "furniture_003",
          "name": "LED Floor Lamp",
          "description": "Modern adjustable LED floor lamp with brushed metal finish",
          "price": 149.99,
          "category": "Lamp",
          "categoryFr": "Luminaires",
          "model3dAsset": "assets/models/mordern_lamp___jpgstlglb_formats_available.glb",
          "thumbnailUrl": "",
          "dimensions": {
            "width": 0.4,
            "height": 1.5,
            "depth": 0.4
          }
        }
      ]
    }
  ]
  ''';

  /// Helper to get parsed raw Maps list of furniture.
  static List<Map<String, dynamic>> getFurnitureMaps() {
    final List<dynamic> parsed = json.decode(furnitureRawJson) as List<dynamic>;
    return parsed.cast<Map<String, dynamic>>();
  }

  /// Helper to get parsed raw Maps list of properties.
  static List<Map<String, dynamic>> getPropertyMaps() {
    final List<dynamic> parsed = json.decode(propertiesRawJson) as List<dynamic>;
    return parsed.cast<Map<String, dynamic>>();
  }
}
