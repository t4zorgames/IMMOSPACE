import 'dart:ui' as ui;
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
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.3),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
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
                        const SizedBox(width: 6),
                        const Icon(Icons.sync_rounded, color: Colors.white70, size: 14),
                      ],
                    ),
                  ),
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

          // Instructions overlay with BackdropFilter blur
          Positioned(
            top: kToolbarHeight + 60,
            left: 28,
            right: 28,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _sensorControl == SensorControl.Orientation
                              ? Icons.screen_rotation_rounded
                              : Icons.touch_app_rounded,
                          color: AppTheme.accentGold,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _sensorControl == SensorControl.Orientation
                                ? 'Bougez votre téléphone ou glissez pour naviguer'
                                : 'Glissez votre doigt pour regarder autour',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                icon: const Icon(Icons.home_rounded, color: Colors.white70, size: 16),
                label: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
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
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: active ? 4 : 0,
      ),
      child: Text(
        label,
        style:
            const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
