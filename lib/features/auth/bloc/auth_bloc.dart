import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';

enum AuthStatus { loading, authenticated, unauthenticated, demo }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.loading,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class AuthDemoRequested extends AuthEvent {
  const AuthDemoRequested();
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthDemoRequested>((event, emit) {
      emit(const AuthState(status: AuthStatus.demo));
    });
    on<AuthLogoutRequested>(_onLogout);
    on<_AuthStreamChanged>(_onAuthStreamChanged);
  }

  final AuthRepository _repository;
  StreamSubscription<User?>? _authSubscription;

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));

    if (_repository.currentUser != null) {
      emit(const AuthState(status: AuthStatus.authenticated));
      return;
    }

    _authSubscription?.cancel();
    _authSubscription = _repository.authStateChanges.listen((user) {
      add(_AuthStreamChanged(user));
    });
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      await _repository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(const AuthState(status: AuthStatus.authenticated));
    } on FirebaseAuthException catch (e) {
      emit(AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: e.message ?? 'Unable to sign in.',
      ));
    } catch (_) {
      emit(const AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }


  void _onAuthStreamChanged(
    _AuthStreamChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user == null) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } else {
      emit(const AuthState(status: AuthStatus.authenticated));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}

// Internal event used to react to Firebase auth state changes.
class _AuthStreamChanged extends AuthEvent {
  const _AuthStreamChanged(this.user);

  final User? user;

  @override
  List<Object?> get props => [user?.uid];
}


extension AuthBlocUserId on AuthBloc {
  String get repositoryUserId => _repository.currentUser?.uid ?? 'demo';
}
