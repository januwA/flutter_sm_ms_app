import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:sm_ms/app/app.router.dart';
import 'package:sm_ms/app/auth_module/dto/login/login_dto.dart';
import 'package:sm_ms/app/shared_module/client/client.dart';
import 'package:sm_ms/store/main/main.store.dart';

import '../app.router.dart';

part 'auth.service.g.dart';

class AuthService = _AuthService with _$AuthService;

abstract class _AuthService with Store {
  _AuthService(MainStore root) {
    _root = root;
    _init();
  }
  @observable
  MainStore _root;

  @action
  _init() async {
    logged = (await _root.tokenService.getToken()).isNotEmpty;
  }

  @observable
  bool logged = false;

  @observable
  String redirectUrl = '/';

  /// 登陆成功，储存token，重定向到 /
  @action
  Future<void> login(String username, String password) async {
    try {
      var r = await client.post(
        'token',
        body: {
          "username": username,
          "password": password,
        },
      );
      if (r.statusCode == 200) {
        final bodyMap = jsonDecode(r.body);
        if (bodyMap["success"]) {
          LoginDto body = LoginDto.fromJson(r.body);
          String _token = body.data.token;
          await mainStore.tokenService.setToken(_token);
          logged = true;
        } else {
          throw "Login Error: statusCode: ${r.statusCode} ${r.body}";
        }
      } else {
        throw "Login Error: statusCode: ${r.statusCode} ${r.body}";
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// 退出登陆，清理token, 重定向到/login
  @action
  Future<void> logout() async {
    logged = false;
    await mainStore.tokenService.clearToken();
    router.pushNamedAndRemoveUntil('/login', (_) => false);
  }
}
