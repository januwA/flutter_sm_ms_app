import 'dart:convert';

import 'package:ajanuw_http/ajanuw_http.dart';
import 'package:dart_printf/dart_printf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sm_ms/app/auth_module/dto/login/login_dto.dart';
import 'package:sm_ms/app/shared_module/client.dart';

import 'pages/login/login.dart';

const String TOKEN_KEY = 'token';

class AuthService  {
  SharedPreferences prefs;

  AuthService() {
    _init();
  }

  _init() async {
    Future.delayed(Duration.zero).then((_) async {
      prefs ??= await SharedPreferences.getInstance();
    });
  }

  /// 登陆成功，储存token，重定向到 /
  Future<void> login(String username, String password) async {
    try {
      var r = await client.post(
        'token',
        AjanuwHttpConfig(
          body: {
            "username": username,
            "password": password,
          },
        ),
      );
      if (r.statusCode == 200) {
        final bodyMap = jsonDecode(r.body);
        if (bodyMap["success"]) {
          LoginDto body = LoginDto.fromJson(r.body);
          await setToken(body.data.token);
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
  Future<void> logout(BuildContext context) async {
    await clearToken();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Login()));
  }

  Future<bool> setToken(String tk) async {
    printf('Set Token: %s', tk);
    return prefs.setString(TOKEN_KEY, tk);
  }

  Future<String> getToken() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY) ?? '';
  }

  Future<void> clearToken() async {
    await prefs.setString(TOKEN_KEY, '');
  }
}
