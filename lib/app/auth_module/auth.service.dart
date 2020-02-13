import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sm_ms/app/app.router.dart';
import 'package:sm_ms/app/auth_module/dto/login/login_dto.dart';
import 'package:sm_ms/app/shared_module/client/client.dart';

import '../app.router.dart';

part 'auth.service.g.dart';

const String TOKEN_KEY = 'token';

class AuthService = _AuthService with _$AuthService;

abstract class _AuthService with Store {
  SharedPreferences prefs;

  @observable
  String _token = '';

  _AuthService() {
    _init();
  }

  @action
  _init() async {
    Future.delayed(Duration.zero).then((_) async {
      prefs ??= await SharedPreferences.getInstance();
      _token = await getToken();
      logged = hasToken;
    });
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
          await setToken(body.data.token);
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
    await clearToken();
    router.pushNamedAndRemoveUntil('/login', (_) => false);
  }

  @computed
  bool get hasToken => _token.isNotEmpty;

  @action
  Future<bool> setToken(String tk) async {
    _token = tk;
    return prefs.setString(TOKEN_KEY, _token);
  }

  @action
  Future<String> getToken() async {
    prefs ??= await SharedPreferences.getInstance();
    _token = prefs.getString(TOKEN_KEY) ?? '';
    return _token;
  }

  @action
  Future<void> clearToken() async {
    _token = '';
    await prefs.setString(TOKEN_KEY, _token);
  }

  String getAuthorizationToken() {
    return _token;
  }
}
