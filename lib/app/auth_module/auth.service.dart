import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:sm_ms/app/app.router.dart';
import 'package:sm_ms/app/auth_module/dto/login/login_dto.dart';
import 'package:sm_ms/app/shared_module/client/client.dart';
import 'package:sm_ms/store/main/main.store.dart';

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
    isLoggedIn = (await _root.tokenService.getToken()).isNotEmpty;
  }

  @observable
  bool isLoggedIn = false;

  @observable
  String redirectUrl = '/';

  /// 登陆成功，储存token，重定向到 /
  @action
  Future<void> login(String username, String password) async {
    var r = await client.post(
      'token',
      body: {
        "username": username,
        "password": password,
      },
    );

    if (r.statusCode == HttpStatus.ok) {
      LoginDto body = LoginDto.fromJson(r.body);
      if (body.success) {
        String _token = body.data.token;
        await mainStore.tokenService.setToken(_token);
        isLoggedIn = true;
        router.navigator.pushNamedAndRemoveUntil(redirectUrl, (_) => false);
      } else {
        print('登陆失败:');
        print(r.body);
      }
    } else {
      print('登陆失败:');
      print(r.body);
    }
  }

  /// 退出登陆，清理token, 重定向到/login
  @action
  Future<void> logout() async {
    isLoggedIn = false;
    await mainStore.tokenService.clearToken();
    router.navigator.pushNamedAndRemoveUntil('/login', (_) => false);
  }

  /// 获取用户的信息
  getUserInfo() async {
    // return this.http
    //   .post<UserProfile>(profileUrl, null, {
    //     observe: 'response',
    //   })
    //   .toPromise();
  }
}
