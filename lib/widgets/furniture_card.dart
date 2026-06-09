import 'package:flutter/material.dart';
import '../models/furniture.dart';
import '../utils/theme.dart';

/// A premium card display for a Furniture item.
/// Shows metadata and action buttons for 3D/AR inspection.
class FurnitureCard extends StatelessWidget {
  final Furniture furniture;
  final VoidCallback? onTap;

  const FurnitureCard({
    super.key,
    required this.furniture,
    this.onTap,
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
    // Format dimensions safely from Map
    final width = furniture.dimensions['width'] ?? 0.0;
    final height = furniture.dimensions['height'] ?? 0.0;
    final depth = furniture.dimensions['depth'] ?? 0.0;
    final String formattedDimensions = '${width.toStringAsFixed(2)} x ${height.toStringAsFixed(2)} x ${depth.toStringAsFixed(2)} m';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Local Styled Thumbnail Placeholder (NO Image.network)
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.secondaryDark,
                        AppTheme.primaryDark.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBrand.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCategoryIcon(furniture.category),
                        size: 48,
                        color: AppTheme.accentGold,
                      ),
                    ),
                  ),
                ),
                // Category Tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentGold.withOpacity(0.4), width: 1),
                    ),
                    child: Text(
                      furniture.category.displayName.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.accentGold,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Metadata and Actions Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    furniture.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDimensions,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      // Price
                      Text(
                        '${furniture.price.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color: AppTheme.accentCyan,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FilledButton.tonal(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/ar',
                            arguments: furniture,
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.accentGold.withOpacity(0.15),
                          foregroundColor: AppTheme.accentGold,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.view_in_ar, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'RA',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
