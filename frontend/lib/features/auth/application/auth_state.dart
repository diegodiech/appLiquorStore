import '../../../models/usuario.dart';

class AuthState {
  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
    this.token,
  });

  final Usuario? currentUser;
  final bool isLoading;
  final String? errorMessage;

  /// JWT de la sesión actual. Nulo mientras no haya login o si el
  /// [AuthRepository] en uso no maneja tokens (p. ej. el mock).
  final String? token;

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    Usuario? currentUser,
    bool? isLoading,
    String? errorMessage,
    String? token,
    bool clearError = false,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      token: token ?? this.token,
    );
  }
}
