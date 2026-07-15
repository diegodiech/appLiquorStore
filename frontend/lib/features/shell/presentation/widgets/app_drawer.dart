import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/initials.dart';
import '../../../auth/application/auth_provider.dart';
import 'app_drawer_item.dart';

/// Menú lateral de navegación: header con degradado, iniciales del usuario,
/// nombre y correo, seguido de las opciones de navegación y el cierre de
/// sesión. Se reutiliza tanto en el módulo de Administrador como en el de
/// Cajero para mantener una experiencia consistente.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.items});

  final List<AppDrawerItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(authControllerProvider).currentUser;

    return Drawer(
      child: Column(
        children: [
          _DrawerHeader(
            nombre: usuario?.nombre ?? '',
            email: usuario?.email ?? '',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                for (final item in items)
                  ListTile(
                    leading: Icon(item.selected ? item.selectedIcon : item.icon),
                    title: Text(item.label),
                    selected: item.selected,
                    selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
                    onTap: () {
                      Navigator.of(context).pop();
                      item.onTap();
                    },
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.danger)),
            onTap: () {
              Navigator.of(context).pop();
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.nombre, required this.email});

  final String nombre;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.85),
            child: Text(
              initialsOf(nombre),
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nombre,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            email,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
