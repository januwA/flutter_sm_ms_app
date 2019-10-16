import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';
import 'package:sm_ms/store/main/main.store.dart';

import '../app.router.dart';

final CanActivate authGuard = (r) {
  if (mainStore.authService.isLoggedIn) {
    return true;
  }

  mainStore.authService.redirectUrl = r.url;

  // 删除所有历史路由，在push login
  Future.delayed(Duration.zero).then((_) {
    router.navigator.pushNamedAndRemoveUntil('/login', (_) => false);
  });
  return false;
};
