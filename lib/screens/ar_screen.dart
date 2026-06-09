import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/furniture.dart';
import '../providers/furniture_provider.dart';
import '../widgets/custom_appbar.dart';
import '../utils/theme.dart';

/// Screen managing Augmented Reality (AR) viewing.
/// ARCore is not supported on this device, so a friendly fallback is shown.
class ARScreen extends StatelessWidget {
  final Furniture? furniture;

  const ARScreen({
    super.key,
    this.furniture,
  });

  @override
  Widget build(BuildContext context) {
    final furnitureProvider = Provider.of<FurnitureProvider>(context);

    // Resolve active furniture (from constructor, route arguments, or provider)
    final Furniture? activeFurniture = furniture ??
        (ModalRoute.of(context)?.settings.arguments as Furniture?) ??
        furnitureProvider.selectedFurniture;

    if (activeFurniture == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Réalité Augmentée'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Aucun meuble sélectionné pour la RA.',
                style: TextStyle(color: Colors.white),
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

    return Scaffold(
      appBar: CustomAppBar(title: activeFurniture.name),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.primaryBrand.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.view_in_ar_rounded,
                      size: 72,
                      color: AppTheme.primaryBrand.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Réalité Augmentée non disponible',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Google ARCore n\'est pas compatible avec cet appareil. '
                      'La fonctionnalité AR nécessite un appareil certifié ARCore.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),
                    Text(
                      activeFurniture.name,
                      style: const TextStyle(
                        color: AppTheme.accentGold,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activeFurniture.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${activeFurniture.price} €',
                      style: const TextStyle(
                        color: AppTheme.accentGold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Retour au catalogue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBrand,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
