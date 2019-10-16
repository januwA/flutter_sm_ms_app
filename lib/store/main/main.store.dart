import 'package:mobx/mobx.dart';
import 'package:sm_ms/app/auth_module/auth.service.dart';
import 'package:sm_ms/app/shared_module/service/token.service.dart';

part 'main.store.g.dart';

class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  _MainStore() {
    tokenService = TokenService(this);
    authService = AuthService(this);
  }

  TokenService tokenService;
  AuthService authService;
}

MainStore mainStore = MainStore();
