import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';

import '../../main.dart';
import '../app.router.dart';
import './auth.service.dart';

final _authService = getIt<AuthService>();
final CanActivate authGuard = (r) {
  if (_authService.logged) {
    return true;
  }

  _authService.redirectUrl = r.url;

  // 删除所有历史路由，在push login
  Future.delayed(Duration.zero).then((_) {
    router.navigator.pushNamedAndRemoveUntil('/login', (_) => false);
  });
  return false;
};
