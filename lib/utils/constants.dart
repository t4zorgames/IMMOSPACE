import '../models/furniture.dart';
import '../models/room.dart';

/// Class containing app-wide constants, styling constraints, and mock data.
class AppConstants {
  // App Name
  static const String appName = 'ImmoSpace';

  // Layout spacings
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;

  // Mock Furniture Data using local GLB models
  static final List<Furniture> mockFurniture = [
    const Furniture(
      id: 'f1',
      name: 'Black Leather Armchair',
      category: FurnitureCategory.chair,
      description: 'Un fauteuil en cuir noir luxueux avec un design moderne et des lignes épurées.',
      dimensions: {'width': 0.85, 'height': 0.95, 'depth': 0.75},
      price: 599.99,
      thumbnailUrl: '',
      model3dAsset: 'assets/models/black_leather_chair.glb',
    ),
    const Furniture(
      id: 'f2',
      name: 'LED Floor Lamp',
      category: FurnitureCategory.lamp,
      description: 'Un lampadaire LED moderne à hauteur ajustable avec finition en métal brossé.',
      dimensions: {'width': 0.40, 'height': 1.50, 'depth': 0.40},
      price: 149.99,
      thumbnailUrl: '',
      model3dAsset: 'assets/models/mordern_lamp___jpgstlglb_formats_available.glb',
    ),
    const Furniture(
      id: 'f3',
      name: 'Modern Coffee Table',
      category: FurnitureCategory.table,
      description: 'Une table basse contemporaine associant structure métallique et plateau en verre.',
      dimensions: {'width': 0.89, 'height': 0.54, 'depth': 1.98},
      price: 299.99,
      thumbnailUrl: '',
      model3dAsset: 'assets/models/metal_and_glass_coffee_table.glb',
    ),
    const Furniture(
      id: 'f4',
      name: '3-Seater Sofa',
      category: FurnitureCategory.chair,
      description: 'Un canapé contemporain à trois places offrant un confort optimal et un design soigné.',
      dimensions: {'width': 2.10, 'height': 0.85, 'depth': 0.95},
      price: 899.99,
      thumbnailUrl: '',
      model3dAsset: 'assets/models/kungshult_3-seater_sofa.glb',
    ),
    const Furniture(
      id: 'f5',
      name: 'Retro Desk',
      category: FurnitureCategory.table,
      description: 'Un bureau de travail rétro en bois et métal, idéal pour le travail ou l\'écriture.',
      dimensions: {'width': 1.40, 'height': 0.75, 'depth': 0.70},
      price: 399.99,
      thumbnailUrl: '',
      model3dAsset: 'assets/models/desk.glb',
    ),
  ];

  // Mock Rooms Data using local equirectangular apartment images
  static final List<Room> mockRooms = [
    Room(
      id: 'r1',
      name: 'Salon Principal',
      panoramaAsset: 'assets/images/AppartementWhite.jpg',
      furniture: [
        mockFurniture[0],
        mockFurniture[2],
        mockFurniture[3],
      ],
    ),
    Room(
      id: 'r2',
      name: 'Chambre d\'Amis',
      panoramaAsset: 'assets/images/AppartementModerne.jpg',
      furniture: [
        mockFurniture[1],
        mockFurniture[2],
      ],
    ),
    Room(
      id: 'r3',
      name: 'Chambre Nature',
      panoramaAsset: 'assets/images/AppartementVacance.jpg',
      furniture: [
        mockFurniture[1],
        mockFurniture[4],
      ],
    ),
  ];
}
