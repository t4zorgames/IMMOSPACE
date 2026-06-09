import 'package:flutter/material.dart';
import '../models/furniture.dart';
import '../utils/constants.dart';

/// Provider for managing furniture list, categories, and selections.
class FurnitureProvider with ChangeNotifier {
  Furniture? _selectedFurniture;
  String _selectedCategory = 'Tous';

  // Mock data of exactly 5 furniture items as specified
  final List<Furniture> _furnitureList = List.from(AppConstants.mockFurniture);

  Furniture? get selectedFurniture => _selectedFurniture;
  List<Furniture> get furnitureList => _furnitureList;
  String get selectedCategory => _selectedCategory;

  /// Selects a specific furniture item and notifies observers.
  void selectFurniture(Furniture furniture) {
    _selectedFurniture = furniture;
    notifyListeners();
  }

  /// Filters and returns a sublist of furniture matching the category name string.
  List<Furniture> getFurnitureByCategory(String category) {
    if (category.toLowerCase() == 'tous') {
      return _furnitureList;
    }
    return _furnitureList.where((item) {
      return item.category.name.toLowerCase() == category.toLowerCase();
    }).toList();
  }

  // ==========================================
  // Backward compatibility layers
  // ==========================================
  
  List<Furniture> get allFurniture => _furnitureList;
  
  List<Furniture> get filteredFurniture {
    return getFurnitureByCategory(_selectedCategory);
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<String> get categories {
    final Set<String> uniqueCategories = {'Tous'};
    for (var f in _furnitureList) {
      final name = f.category.name;
      final capitalized = name[0].toUpperCase() + name.substring(1);
      uniqueCategories.add(capitalized);
    }
    return uniqueCategories.toList();
  }

  /// Adds a new furniture item to the list and notifies observers.
  void addFurniture(Furniture furniture) {
    _furnitureList.add(furniture);
    notifyListeners();
  }

  void clearSelection() {
    _selectedFurniture = null;
    notifyListeners();
  }

  Furniture? getFurnitureById(String id) {
    try {
      return _furnitureList.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
