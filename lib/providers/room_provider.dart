import 'package:flutter/material.dart';
import '../models/room.dart';
import '../utils/constants.dart';

/// Provider for managing state of rooms, active selections, and room lists.
class RoomProvider with ChangeNotifier {
  Room? _currentRoom;

  // Mock data of rooms using local assets
  final List<Room> _roomList = List.from(AppConstants.mockRooms);

  Room? get currentRoom => _currentRoom;
  List<Room> get roomList => _roomList;

  /// Sets the currently active room to visit.
  void selectRoom(Room room) {
    _currentRoom = room;
    notifyListeners();
  }

  /// Loads a room by its ID from the roomList.
  void loadRoom(String id) {
    try {
      _currentRoom = _roomList.firstWhere((r) => r.id == id);
      notifyListeners();
    } catch (_) {
      _currentRoom = null;
    }
  }

  // ==========================================
  // Backward compatibility layers
  // ==========================================

  Room? get activeRoom => _currentRoom;
  List<Room> get rooms => _roomList;

  void clearActiveRoom() {
    _currentRoom = null;
    notifyListeners();
  }
}
