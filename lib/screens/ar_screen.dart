import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/furniture.dart';
import '../providers/furniture_provider.dart';
import '../widgets/custom_appbar.dart';
import '../utils/theme.dart';

/// Screen managing Augmented Reality (AR) viewing and details.
/// Since ARCore is not supported on this device, it serves as a premium 3D spec sheet and fallback.
class ARScreen extends StatelessWidget {
  final Furniture? furniture;

  const ARScreen({
    super.key,
    this.furniture,
  });

  IconData _getCategoryIcon(FurnitureCategory category) {
    switch (category) {
      case FurnitureCategory.chair:
        return Icons.chair;
      case FurnitureCategory.table:
        return Icons.table_restaurant;
      case FurnitureCategory.lamp:
        return Icons.light;
    }
  }

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

    final width = activeFurniture.dimensions['width'] ?? 0.0;
    final height = activeFurniture.dimensions['height'] ?? 0.0;
    final depth = activeFurniture.dimensions['depth'] ?? 0.0;

    return Scaffold(
      appBar: CustomAppBar(title: activeFurniture.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Mock 3D Grid Canvas Frame
            Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.secondaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Stylized 3D Grid Lines Overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(),
                    ),
                  ),
                  // Mock 3D Perspective Furniture Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBrand.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryBrand.withValues(alpha: 0.25),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        _getCategoryIcon(activeFurniture.category),
                        size: 80,
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ),
                  // Rotation controls indicators overlay
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.threed_rotation, color: Colors.white70, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Perspective 3D',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Category Tag
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBrand.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activeFurniture.category.displayName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Pricing & Main Specs Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: AppTheme.secondaryDark,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            activeFurniture.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${activeFurniture.price.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            color: AppTheme.accentCyan,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      activeFurniture.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Dimensions Section
            Text(
              'Dimensions de l\'Objet',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildDimensionBox(
                    label: 'Largeur',
                    value: '${width.toStringAsFixed(2)} m',
                    icon: Icons.swap_horiz_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDimensionBox(
                    label: 'Hauteur',
                    value: '${height.toStringAsFixed(2)} m',
                    icon: Icons.height_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDimensionBox(
                    label: 'Profondeur',
                    value: '${depth.toStringAsFixed(2)} m',
                    icon: Icons.unfold_more_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. AR Incompatibility Warning Frame
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentGold.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.accentGold.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppTheme.accentGold, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Réalité Augmentée non disponible',
                          style: TextStyle(
                            color: AppTheme.accentGold,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Google ARCore n\'est pas pris en charge sur ce téléphone. Vous pouvez néanmoins consulter la fiche technique et les dimensions 3D ci-dessus.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Back Button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBrand,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Retour au catalogue',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionBox({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.accentCyan, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper custom painter to render a mock 3D grid layout on the canvas
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1.0;

    // Draw horizontal lines
    final int rows = 10;
    final double rowHeight = size.height / rows;
    for (int i = 0; i <= rows; i++) {
      canvas.drawLine(Offset(0, i * rowHeight), Offset(size.width, i * rowHeight), paint);
    }

    // Draw vertical lines
    final int cols = 15;
    final double colWidth = size.width / cols;
    for (int i = 0; i <= cols; i++) {
      canvas.drawLine(Offset(i * colWidth, 0), Offset(i * colWidth, size.height), paint);
    }

    // Draw mock perspective lines
    final pPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(0, 0), Offset(size.width * 0.3, size.height * 0.4), pPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width * 0.7, size.height * 0.4), pPaint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width * 0.3, size.height * 0.6), pPaint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width * 0.7, size.height * 0.6), pPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
