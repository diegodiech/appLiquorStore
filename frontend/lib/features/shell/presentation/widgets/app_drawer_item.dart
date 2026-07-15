import 'package:flutter/widgets.dart';

/// Una entrada de navegación del [AppDrawer].
class AppDrawerItem {
  const AppDrawerItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
}
