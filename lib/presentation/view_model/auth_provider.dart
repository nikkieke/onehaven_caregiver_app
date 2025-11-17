import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onehaven_caregiver_app/data/services/auth_service.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(authService: ref.watch(authServiceProvider)),
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  AuthStateNotifier({required this.authService}) : super(AuthState());

  Future<bool> login({required String email, required String pass}) async {
    state = state.copyWith(loadingStates: LoadingStates.signingIn);
    final response = await authService.login(email: email, pass: pass);
    state = state.copyWith(loadingStates: LoadingStates.idle);
    if (response) {
      return true;
    } else {
      return false;
    }
  }
}

class AuthState {
  final LoadingStates? loadingStates;

  AuthState({this.loadingStates = LoadingStates.idle});

  AuthState copyWith({LoadingStates? loadingStates}) {
    return AuthState(loadingStates: loadingStates ?? this.loadingStates);
  }
}

enum LoadingStates { signingIn, idle }
