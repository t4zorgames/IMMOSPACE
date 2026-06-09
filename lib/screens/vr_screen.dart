import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:panorama/panorama.dart';

import '../models/room.dart';
import '../providers/vr_provider.dart';
import '../utils/theme.dart';

/// Screen showcasing a Virtual Reality 360 panorama visit.
/// Uses the panorama package to render an equirectangular image on a 3D sphere.
class VRScreen extends StatefulWidget {
  const VRScreen({super.key});

  @override
  State<VRScreen> createState() => _VRScreenState();
}

class _VRScreenState extends State<VRScreen> {
  // Use SensorControl from panorama package
  SensorControl _sensorControl = SensorControl.Orientation;

  @override
  Widget build(BuildContext context) {
    final vrProvider = Provider.of<VRProvider>(context);
    final room = vrProvider.currentRoom;

    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Visite VR 360°')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Aucune pièce sélectionnée.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    final String modeLabel = _sensorControl == SensorControl.Orientation
        ? '📡 Gyroscope'
        : '👆 Drag';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          room.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _sensorControl = _sensorControl == SensorControl.Orientation
                      ? SensorControl.None
                      : SensorControl.Orientation;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBrand.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      modeLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.sync, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // The Panorama widget renders the equirectangular image spherically
          Panorama(
            sensorControl: _sensorControl,
            interactive: true,
            child: Image.asset(room.panoramaAsset),
          ),

          // Instructions overlay
          Positioned(
            top: kToolbarHeight + 50,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _sensorControl == SensorControl.Orientation
                      ? '📱 Bougez votre téléphone • Glissez pour contrôler'
                      : '👆 Glissez votre doigt pour regarder autour',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom navigation bar for room switching
      bottomNavigationBar: Container(
        color: AppTheme.primaryDark.withValues(alpha: 0.95),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton(
                label: 'Room 1',
                active: room.id == 'room_white',
                onPressed: () {
                  if (Room.availableRooms.isNotEmpty) {
                    vrProvider.selectRoom(Room.availableRooms[0]);
                  }
                },
              ),
              _buildNavButton(
                label: 'Room 2',
                active: room.id == 'room_modern',
                onPressed: () {
                  if (Room.availableRooms.length > 1) {
                    vrProvider.selectRoom(Room.availableRooms[1]);
                  }
                },
              ),
              _buildNavButton(
                label: 'Room 3',
                active: room.id == 'room_vacation',
                onPressed: () {
                  if (Room.availableRooms.length > 2) {
                    vrProvider.selectRoom(Room.availableRooms[2]);
                  }
                },
              ),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home, color: Colors.white, size: 16),
                label: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required String label,
    required bool active,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            active ? AppTheme.accentBrand : AppTheme.secondaryDark,
        foregroundColor: Colors.white,
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
