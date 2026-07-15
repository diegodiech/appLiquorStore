import '../../../models/usuario.dart';

class AuthState {
  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  final Usuario? currentUser;
  final bool isLoading;
  final String? errorMessage;

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    Usuario? currentUser,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
