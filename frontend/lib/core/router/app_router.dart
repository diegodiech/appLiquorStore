import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/inventory/presentation/screens/product_detail_screen.dart';
import '../../features/inventory/presentation/screens/product_form_screen.dart';
import '../../features/pos/presentation/screens/payment_screen.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/pos/presentation/screens/ticket_screen.dart';
import '../../features/sales_history/presentation/screens/sale_detail_screen.dart';
import '../../features/sales_history/presentation/screens/sales_history_screen.dart';
import '../../features/shell/presentation/admin_shell_screen.dart';
import '../../features/suppliers/presentation/screens/suppliers_screen.dart';
import '../../models/producto.dart';
import '../../models/venta.dart';
import '../enums/user_role.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _AuthRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isLoggingIn = location == '/login';

      if (!authState.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      final rol = authState.currentUser!.rol;
      final isAdminRoute = location.startsWith('/admin');
      final isCashierRoute = location.startsWith('/cashier');

      if (isLoggingIn) {
        return rol == UserRole.administrador ? '/admin/dashboard' : '/cashier';
      }
      if (rol == UserRole.administrador && isCashierRoute) {
        return '/admin/dashboard';
      }
      if (rol == UserRole.cajero && isAdminRoute) {
        return '/cashier';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/inventory',
                builder: (context, state) => const InventoryScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const ProductFormScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:id',
                    builder: (context, state) => ProductFormScreen(
                      producto: state.extra as Producto?,
                    ),
                  ),
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) => ProductDetailScreen(
                      producto: state.extra as Producto,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/suppliers',
                builder: (context, state) => const SuppliersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin/sales',
                builder: (context, state) => const SalesHistoryScreen(),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    builder: (context, state) => SaleDetailScreen(
                      venta: state.extra as Venta,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/cashier',
        builder: (context, state) => const PosScreen(),
        routes: [
          GoRoute(
            path: 'payment',
            builder: (context, state) => const PaymentScreen(),
          ),
          GoRoute(
            path: 'ticket',
            builder: (context, state) => const TicketScreen(),
          ),
        ],
      ),
    ],
  );
});

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}
