import 'dart:async';
import 'package:drink/models/user.dart';
import 'package:drink/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:drink/utility/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required AuthenticationRepository authenticationRepository,
  })  : assert(authenticationRepository != null),
        _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    _userSubscription = _authenticationRepository.currentUser.listen(
      (user) {
        _currentuser = user;
        return add(AuthenticationUserChanged(user));
      },
    );
  }

  UserModel get currentUser => _currentuser;
  UserModel _currentuser;

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserModel> _userSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      try {
        await _authenticationRepository.logOut();
      } on AuthException {
        _authenticationRepository.signOut();
      }
    } else if (event is AuthenticationDeleteRequested) {
      try {
        await _authenticationRepository.deleteAccount();
      } on AuthException {
        _authenticationRepository.signOut();
      }
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    // _authenticationRepository.dispose();
    return super.close();
  }

  AuthenticationState _mapAuthenticationUserChangedToState(
    AuthenticationUserChanged event,
  ) {
    if (event.user == null) {
      return const AuthenticationState.unauthenticated();
    } else if (!event.user.verified) {
      return AuthenticationState.unverified(event.user);
    } else if (event.user.isProfileComplete == 0) {
      return AuthenticationState.incompleteProfile(event.user);
    } else if (event.user != null) {
      return AuthenticationState.authenticated(event.user);
    } else {
      return AuthenticationState.unknown();
    }
  }
}
