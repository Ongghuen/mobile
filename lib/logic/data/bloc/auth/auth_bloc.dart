import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/logic/data/api/call.dart';
import 'package:mobile/logic/models/user.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<UserAuthLogin>((event, emit) async {
      // TODO: implement event handler
      try {
        emit(AuthLoading());

        String apiUrl = "/api/login";
        var res = await CallApi().postData(apiUrl, data: event.data);
        var body = json.decode(res.body);
        if (res.statusCode == 201) {
          final auth = AuthModel.fromJson(body);
          emit(AuthLoaded(auth));
        } else {
          emit(AuthError(body['message']));
        }
      } catch (ex, trace) {
        print("$ex $trace");
        emit(AuthError("Something's wrong"));
      }
    });

    on<UserAuthRegister>((event, emit) async {
      emit(AuthLoading());

      try {
        emit(AuthLoading());

        String apiUrl = "/api/register";
        var res = await CallApi().postData(apiUrl, data: event.data);
        var body = json.decode(res.body);

        if (res.statusCode == 201) {
          final auth = AuthModel.fromJson(body);
          emit(AuthLoaded(auth));
        } else {
          emit(AuthError(body['message']));
        }
      } catch (ex, trace) {
        print("$ex $trace");
      }
    });

    on<UserAuthUpdate>((event, emit) async {
      try {
        String apiUrl = "/api/user";
        var res = await CallApi()
            .putData(apiUrl, data: event.data, token: event.token);
        var body = json.decode(res.body);
        final auth = AuthModel.fromJson(body);

        if (res.statusCode != 200) {
          emit(AuthUpdateError(body['message']));
        }
        emit(AuthUpdateSuccess());
        add(UserAuthRestart(event.token));
      } catch (ex, trace) {
        print("$ex $trace");
      }
    });

    on<UserAuthRestart>((event, emit) async {
      try {
        String apiUrl = "/api/user";
        var res = await CallApi()
            .putData(apiUrl, data: {}, token: event.token);
        var body = json.decode(res.body);
        final auth = AuthModel.fromJson(body);

        if (res.statusCode == 200) {
          emit(AuthLoaded(auth));
        } else {
          print(body['message']);
        }
      } catch (ex, trace) {
        print("$ex $trace");
      }
    });

    on<UserAuthLogout>((event, emit) async {
      String apiUrl = "/api/logout";

      var res = await CallApi().postData(apiUrl, token: event.token);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        emit(AuthLogout());
        HydratedBloc.storage.clear();
        print("yuhyuh byebye hydratedbloc");
      } else {
        emit(AuthLogout());
        HydratedBloc.storage.clear();
        emit(AuthError("Logout Failed but your data is destroyed ;)"));
      }
    });
    on<UserAuthCheckToken>((event, emit) async {
      var apiUrl = '/api/checktoken';
      var res = await CallApi().getData(apiUrl, token: event.token);
      if (res.statusCode == 401) {
        emit(AuthLogout());
        HydratedBloc.storage.clear();
      }
    });
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    print("ok masuk from json!");
    try {
      print("ok imported from json!");
      final user = AuthModel.fromJson(json);
      return AuthLoaded(user);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthLoaded) {
      print("ok sip loaded to json!");
      return state.userModel.toJson();
    }
  }
}
