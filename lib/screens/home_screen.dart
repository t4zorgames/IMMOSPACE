import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../providers/property_provider.dart';
import '../providers/vr_provider.dart';
import '../models/furniture.dart';
import '../models/property.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/furniture_card.dart';
import '../utils/theme.dart';

/// The Home Screen of ImmoSpace containing the main property visits and furniture catalog.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _activeCategoryString = 'Tous';

  @override
  Widget build(BuildContext context) {
    final furnitureProvider = Provider.of<FurnitureProvider>(context);
    final propertyProvider = Provider.of<PropertyProvider>(context);
    final vrProvider = Provider.of<VRProvider>(context, listen: false);
    final filteredFurniture = furnitureProvider.getFurnitureByCategory(_activeCategoryString);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ImmoSpace',
        showBackButton: false,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildPropertiesTab(propertyProvider, vrProvider),
          _buildFurnitureTab(furnitureProvider, filteredFurniture),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white10, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppTheme.primaryDark,
          selectedItemColor: AppTheme.accentGold,
          unselectedItemColor: Colors.white60,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work_rounded),
              label: 'Propriétés',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chair_rounded),
              label: 'Mobilier AR',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => _showAddFurnitureDialog(context, furnitureProvider),
              backgroundColor: AppTheme.accentBrand,
              foregroundColor: Colors.white,
              tooltip: 'Ajouter un meuble',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Properties Tab Layout stacked vertically
  Widget _buildPropertiesTab(PropertyProvider propertyProvider, VRProvider vrProvider) {
    return CustomScrollView(
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

        // 2. Select Property Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppTheme.primaryBrand, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Select Property',
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

        // 3. Vertical Stack of Property Cards
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final property = propertyProvider.propertyList[index];
                return PropertyCard(
                  property: property,
                  onTap: () {
                    propertyProvider.selectProperty(property);
                    vrProvider.selectProperty(property);
                    Navigator.pushNamed(context, '/vr');
                  },
                );
              },
              childCount: propertyProvider.propertyList.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  /// AR Furniture Catalog Tab Layout
  Widget _buildFurnitureTab(FurnitureProvider furnitureProvider, List<Furniture> filteredFurniture) {
    return CustomScrollView(
      slivers: [
        // 1. Premium Header Banner
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
                        color: AppTheme.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.view_in_ar_rounded, color: AppTheme.accentCyan, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Catalogue de Mobilier AR',
                            style: TextStyle(
                              color: AppTheme.accentCyan,
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
                  'Catalogue de Mobilier 3D',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Visualisez et placez des modèles 3D réalistes chez vous ou dans nos appartements virtuels.',
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

        // 2. Category Chips Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

        // 3. Furniture Grid View
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

/// A premium Property card displaying wide layout and spec overlays.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              // Cover Image (Left Side)
              SizedBox(
                width: 130,
                height: 140,
                child: Image.asset(
                  property.coverAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white12,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white24, size: 36),
                      ),
                    );
                  },
                ),
              ),
              
              // Property Specifications & Details (Right Side)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title / Name
                          Text(
                            property.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          
                          // Location (GPS Icon)
                          Row(
                            children: [
                              const Icon(Icons.location_pin, color: AppTheme.accentGold, size: 13),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  property.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          
                          // Bed/Price details (like "3 bedrooms • $4k")
                          Row(
                            children: [
                              const Icon(Icons.king_bed_outlined, color: AppTheme.accentCyan, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${property.bedrooms} ${property.bedrooms > 1 ? "chambres" : "chambre"}',
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '•',
                                style: TextStyle(color: Colors.white24),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.attach_money_rounded, color: Colors.greenAccent, size: 14),
                              Text(
                                property.priceString,
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Visit VR Button
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBrand,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBrand.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.vrpano_rounded, color: Colors.white, size: 13),
                              SizedBox(width: 4),
                              Text(
                                'VISIT VR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
