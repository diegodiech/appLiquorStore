import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/app_drawer.dart';
import 'widgets/app_drawer_item.dart';

/// Navegación principal del Administrador: alterna entre Dashboard,
/// Inventario, Proveedores e Historial de ventas conservando el historial
/// de cada pestaña.
class AdminShellScreen extends StatelessWidget {
  const AdminShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _titles = ['Dashboard', 'Inventario', 'Proveedores', 'Ventas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Licorería · ${_titles[navigationShell.currentIndex]}')),
      drawer: AppDrawer(
        items: [
          AppDrawerItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: 'Dashboard',
            selected: navigationShell.currentIndex == 0,
            onTap: () => navigationShell.goBranch(0, initialLocation: navigationShell.currentIndex == 0),
          ),
          AppDrawerItem(
            icon: Icons.inventory_2_outlined,
            selectedIcon: Icons.inventory_2,
            label: 'Inventario',
            selected: navigationShell.currentIndex == 1,
            onTap: () => navigationShell.goBranch(1, initialLocation: navigationShell.currentIndex == 1),
          ),
          AppDrawerItem(
            icon: Icons.local_shipping_outlined,
            selectedIcon: Icons.local_shipping,
            label: 'Proveedores',
            selected: navigationShell.currentIndex == 2,
            onTap: () => navigationShell.goBranch(2, initialLocation: navigationShell.currentIndex == 2),
          ),
          AppDrawerItem(
            icon: Icons.receipt_long_outlined,
            selectedIcon: Icons.receipt_long,
            label: 'Ventas',
            selected: navigationShell.currentIndex == 3,
            onTap: () => navigationShell.goBranch(3, initialLocation: navigationShell.currentIndex == 3),
          ),
        ],
      ),
      body: navigationShell,
    );
  }
}
