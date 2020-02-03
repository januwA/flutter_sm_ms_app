import 'package:flutter/material.dart';
import 'package:sm_ms/store/main/main.store.dart';
import 'package:sm_ms/theme/theme.dart';

import 'app.router.dart';
import 'auth_module/auth.router.dart';

class MyApp extends StatelessWidget {
  final onGenerateRoute = router.forRoot([...appRoutes, ...authRoutes]);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: mainStore.tokenService.getToken(),
      builder: (context, AsyncSnapshot<String> snap) {
        if (snap.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: snap.data.isEmpty ? "/login" : "/dash",
            title: 'SM.MS',
            theme: myTheme,
            navigatorObservers: [router.navigatorObserver],
            navigatorKey: router.navigatorKey,
            onGenerateRoute: onGenerateRoute,
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
