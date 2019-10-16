import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobx/mobx.dart';
import 'package:sm_ms/store/main/main.store.dart';

part 'token.service.g.dart';

class TokenService = _TokenService with _$TokenService;

abstract class _TokenService with Store {
  final String _tokenKey = 'token';
  _TokenService(MainStore root) {
    _init();
  }

  @action
  Future<void> _init() async {
    prefs ??= await SharedPreferences.getInstance();
    _token = await getToken();
  }

  @observable
  SharedPreferences prefs;

  @observable
  String _token = '';

  @computed
  bool get hasToken => _token.isNotEmpty;

  @action
  Future<void> setToken(String tk) async {
    _token = tk;
    await prefs.setString(_tokenKey, _token);
  }

  @action
  Future<String> getToken() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @action
  Future<void> clearToken() async {
    _token = '';
    await prefs.setString(_tokenKey, '');
  }

  String getAuthorizationToken() {
    return _token;
  }
}
