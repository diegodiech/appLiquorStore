import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/usuario.dart';
import '../data/auth_repository.dart';
import '../data/auth_repository_mock.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryMock();
});

/// Usuarios registrados, usados por el Historial de ventas para mostrar
/// quién atendió cada transacción.
final usuariosProvider = FutureProvider<List<Usuario>>((ref) {
  return ref.watch(authRepositoryProvider).getUsuarios();
});

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final usuario = await ref
        .read(authRepositoryProvider)
        .login(email: email, password: password);

    if (usuario == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Correo o contraseña incorrectos',
      );
      return;
    }

    state = AuthState(currentUser: usuario);
  }

  void logout() {
    state = const AuthState();
  }
}
