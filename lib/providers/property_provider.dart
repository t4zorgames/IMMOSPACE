import 'package:flutter/material.dart';
import '../models/property.dart';
import '../utils/constants.dart';

/// Provider for managing state of properties, active selections, and property list.
class PropertyProvider with ChangeNotifier {
  Property? _currentProperty;

  // Mock data of properties using local assets
  final List<Property> _propertyList = List.from(AppConstants.mockProperties);

  Property? get currentProperty => _currentProperty;
  List<Property> get propertyList => _propertyList;

  /// Sets the currently active property to visit.
  void selectProperty(Property property) {
    _currentProperty = property;
    notifyListeners();
  }

  /// Loads a property by its ID from the propertyList.
  void loadProperty(String id) {
    try {
      _currentProperty = _propertyList.firstWhere((p) => p.id == id);
      notifyListeners();
    } catch (_) {
      _currentProperty = null;
    }
  }

  // ==========================================
  // Backward compatibility layers
  // ==========================================

  Property? get activeProperty => _currentProperty;
  List<Property> get properties => _propertyList;

  void clearActiveProperty() {
    _currentProperty = null;
    notifyListeners();
  }
}
