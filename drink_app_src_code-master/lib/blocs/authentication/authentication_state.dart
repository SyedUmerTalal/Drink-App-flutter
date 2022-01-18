part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  unknown,
  unverfiedemail,
  incompleteprofile,
}

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(UserModel user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.unverified(UserModel user)
      : this._(
          status: AuthenticationStatus.unverfiedemail,
          user: user,
        );
  const AuthenticationState.incompleteProfile(UserModel user)
      : this._(status: AuthenticationStatus.incompleteprofile, user: user);
  final AuthenticationStatus status;
  final UserModel user;

  @override
  List<Object> get props => [status, user];
}
