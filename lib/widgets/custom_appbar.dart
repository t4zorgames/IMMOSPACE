import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// A premium, customizable AppBar used throughout the ImmoSpace app.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.explore_outlined,
            color: AppTheme.accentGold,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ],
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppTheme.primaryDark.withOpacity(0.9),
      scrolledUnderElevation: 0,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: AppTheme.secondaryDark,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: AppTheme.textPrimary,
                    ),
                    onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            )
          : null,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppTheme.accentGold.withOpacity(0.2),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
