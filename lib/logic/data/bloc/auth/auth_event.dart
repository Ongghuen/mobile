part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserAuthLogin extends AuthEvent {
  var data;

  UserAuthLogin(this.data);
}

class UserAuthRegister extends AuthEvent {
  var data;

  UserAuthRegister(this.data);
}

class UserAuthUpdate extends AuthEvent {
  var data;
  var token;

  UserAuthUpdate(this.data, this.token);
}

class UserAuthLogout extends AuthEvent {
  var token;

  UserAuthLogout(this.token);
}

class UserAuthCheckToken extends AuthEvent {
  var token;

  UserAuthCheckToken(this.token);
}

class UserAuthRestart extends AuthEvent {
  var token;

  UserAuthRestart(this.token);
}
