import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../providers/room_provider.dart';
import '../providers/vr_provider.dart';
import '../models/furniture.dart';
import '../models/room.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/furniture_card.dart';
import '../utils/theme.dart';

/// The Home Screen of ImmoSpace containing the main furniture catalog and navigation hub.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _activeCategoryString = 'Tous';

  @override
  Widget build(BuildContext context) {
    final furnitureProvider = Provider.of<FurnitureProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context);
    final vrProvider = Provider.of<VRProvider>(context, listen: false);
    final filteredFurniture = furnitureProvider.getFurnitureByCategory(_activeCategoryString);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ImmoSpace',
        showBackButton: false,
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Navigation & Banner Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.secondaryDark.withValues(alpha: 0.9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: AppTheme.accentGold, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Premium Property Visiter',
                              style: TextStyle(
                                color: AppTheme.accentGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Découvrez votre futur intérieur',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Explorez des appartements en VR 360° et intégrez des meubles en réalité augmentée.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. VR Rooms Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  const Icon(Icons.vrpano_rounded, color: AppTheme.primaryBrand, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Visites Virtuelles 360°',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: roomProvider.roomList.length,
                itemBuilder: (context, index) {
                  final room = roomProvider.roomList[index];
                  return RoomCard(
                    room: room,
                    onTap: () {
                      roomProvider.selectRoom(room);
                      vrProvider.selectRoom(room);
                      Navigator.pushNamed(context, '/vr');
                    },
                  );
                },
              ),
            ),
          ),

          // 3. Category Selector Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_bag_rounded, color: AppTheme.accentCyan, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Catalogue de Mobilier 3D',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['Tous', 'Chair', 'Table', 'Lamp'].map((catName) {
                        final isSelected = _activeCategoryString.toLowerCase() == catName.toLowerCase();
                        String displayLabel = catName;
                        if (catName == 'Chair') displayLabel = 'Sièges';
                        if (catName == 'Table') displayLabel = 'Tables';
                        if (catName == 'Lamp') displayLabel = 'Luminaires';

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
                          child: ChoiceChip(
                            label: Text(displayLabel),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _activeCategoryString = catName;
                                });
                              }
                            },
                            selectedColor: AppTheme.primaryBrand,
                            backgroundColor: AppTheme.secondaryDark,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? AppTheme.primaryBrand : Colors.white12,
                                width: 1,
                              ),
                            ),
                            elevation: isSelected ? 4 : 0,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Furniture Grid View
          filteredFurniture.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(
                      child: Text(
                        'Aucun meuble dans cette catégorie.',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.64,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = filteredFurniture[index];
                        return FurnitureCard(
                          furniture: item,
                          onTap: () {
                            furnitureProvider.selectFurniture(item);
                            Navigator.pushNamed(context, '/ar', arguments: item);
                          },
                        );
                      },
                      childCount: filteredFurniture.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFurnitureDialog(context, furnitureProvider),
        backgroundColor: AppTheme.accentBrand,
        foregroundColor: Colors.white,
        tooltip: 'Ajouter un meuble',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Displays dialog for adding a new furniture item.
  void _showAddFurnitureDialog(BuildContext context, FurnitureProvider provider) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    FurnitureCategory selectedCategory = FurnitureCategory.chair;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: AppTheme.secondaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Ajouter un meuble',
                style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nom du meuble',
                        labelStyle: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Prix (€)',
                        labelStyle: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Catégorie : ',
                          style: TextStyle(color: AppTheme.textPrimary),
                        ),
                        DropdownButton<FurnitureCategory>(
                          value: selectedCategory,
                          dropdownColor: AppTheme.secondaryDark,
                          onChanged: (cat) {
                            if (cat != null) {
                              setModalState(() {
                                selectedCategory = cat;
                              });
                            }
                          },
                          items: FurnitureCategory.values.map((cat) {
                            return DropdownMenuItem<FurnitureCategory>(
                              value: cat,
                              child: Text(
                                cat.displayName,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler', style: TextStyle(color: AppTheme.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text.trim();
                    final double price = double.tryParse(priceController.text) ?? 0.0;
                    if (name.isNotEmpty) {
                      final newId = 'f${provider.furnitureList.length + 1}';
                      final newItem = Furniture(
                        id: newId,
                        name: name,
                        price: price,
                        category: selectedCategory,
                        description: 'Un nouveau meuble ajouté dynamiquement via le catalogue.',
                        thumbnailUrl: '',
                        model3dAsset: 'assets/models/desk.glb',
                        dimensions: const {'width': 0.8, 'height': 0.8, 'depth': 0.8},
                      );
                      provider.addFurniture(newItem);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name ajouté avec succès au catalogue.'),
                          backgroundColor: AppTheme.primaryBrand,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBrand,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// A premium Room card displaying equirectangular panorama preview
class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 16, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // Panorama image background
              Positioned.fill(
                child: Image.asset(
                  room.panoramaAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.secondaryDark,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white24, size: 48),
                      ),
                    );
                  },
                ),
              ),
              // Dark subtle gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Content overlay
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      room.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBrand.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.explore_outlined, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Visiter en VR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
