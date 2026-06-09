import 'package:flutter/material.dart';
import '../models/property.dart';

/// Provider for managing state of active property and room panorama during VR visit.
class VRProvider with ChangeNotifier {
  Property? _currentProperty;
  RoomPano? _currentRoomPano;

  Property? get currentProperty => _currentProperty;
  RoomPano? get currentRoomPano => _currentRoomPano;

  /// Selects the property to visit in VR.
  /// Selects the first room panorama (e.g. Salon) of the property by default if none specified.
  void selectProperty(Property property, {RoomPano? initialRoom}) {
    _currentProperty = property;
    _currentRoomPano = initialRoom ?? (property.rooms.isNotEmpty ? property.rooms.first : null);
    notifyListeners();
  }

  /// Sets the currently active room panorama.
  void selectRoomPano(RoomPano roomPano) {
    _currentRoomPano = roomPano;
    notifyListeners();
  }

  /// Backward compatibility helper
  Property? get currentRoom => _currentProperty;

  void selectRoom(Property property) {
    selectProperty(property);
  }
}
