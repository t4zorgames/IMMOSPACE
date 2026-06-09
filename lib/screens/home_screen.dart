import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../providers/room_provider.dart';
import '../models/furniture.dart';
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
    final filteredFurniture = furnitureProvider.getFurnitureByCategory(_activeCategoryString);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ImmoSpace',
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Navigation & Banner Header
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.secondaryDark.withOpacity(0.9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Visites Immobilières 3D',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Visitez nos pièces en 360° VR et projetez des meubles dans votre espace réel avec la RA.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 16),
                
                // Navigation Buttons "Visite VR" and "Essayer en AR"
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Select the first room as default if none selected
                          if (roomProvider.currentRoom == null && roomProvider.roomList.isNotEmpty) {
                            roomProvider.selectRoom(roomProvider.roomList.first);
                          }
                          Navigator.pushNamed(context, '/vr');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryBrand,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.vrpano_outlined),
                        label: const Text('Visite VR'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Select the first furniture as default if none selected
                          if (furnitureProvider.selectedFurniture == null && furnitureProvider.furnitureList.isNotEmpty) {
                            furnitureProvider.selectFurniture(furnitureProvider.furnitureList.first);
                          }
                          Navigator.pushNamed(context, '/ar');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.accentBrand, width: 2),
                          foregroundColor: AppTheme.accentBrand,
                        ),
                        icon: const Icon(Icons.view_in_ar),
                        label: const Text('Essayer en AR'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 2. Category Selector Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['Tous', 'Chair', 'Table', 'Lamp'].map((catName) {
                final isSelected = _activeCategoryString.toLowerCase() == catName.toLowerCase();
                String displayLabel = catName;
                if (catName == 'Chair') displayLabel = 'Sièges';
                if (catName == 'Table') displayLabel = 'Tables';
                if (catName == 'Lamp') displayLabel = 'Luminaires';

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
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
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 3. Furniture Grid View with FurnitureCard
          Expanded(
            child: filteredFurniture.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun meuble dans cette catégorie.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredFurniture.length,
                    itemBuilder: (context, index) {
                      final item = filteredFurniture[index];
                      return FurnitureCard(
                        furniture: item,
                        onTap: () {
                          furnitureProvider.selectFurniture(item);
                          Navigator.pushNamed(context, '/ar', arguments: item);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // 4. FloatingActionButton to add a mock furniture item dynamically
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBrand),
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
