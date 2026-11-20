import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final result = await authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => user != null ? emit(AuthAuthenticated(user)) : emit(AuthUnauthenticated()),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepository.signIn(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    emit(AuthLoading());
    final result = await authRepository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      role: role,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}
