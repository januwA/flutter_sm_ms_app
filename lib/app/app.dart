import 'package:flutter/material.dart';
import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sm_ms/app/auth_module/pages/login/login.dart';
import 'package:sm_ms/app/pages/dash/dash.dart';
import 'package:sm_ms/store/main/main.store.dart';

import 'app.router.dart';
import 'auth_module/auth.router.dart';

class MyApp extends StatelessWidget {
  final AjanuwRouteFactory _onGenerateRoute = router.forRoot([
    ...appRoutes,
    ...authRoutes,
  ]);
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return MaterialApp(
          // initialRoute: mainStore.tokenService.hasToken ? "/dash" : '/login',
          navigatorObservers: [router.navigatorObserver],
          navigatorKey: router.navigatorKey,
          onGenerateRoute: _onGenerateRoute,
          home: mainStore.tokenService.hasToken ? Dash() : Login(),
        );
      },
    );
  }
}
