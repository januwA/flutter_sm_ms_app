import 'package:flutter/material.dart';
// import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';

import 'router.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // for (var item in AjanuwRouter.routers.entries) {
    //   print(item.key);
    // }
    return MaterialApp(
      initialRoute: '',
      navigatorObservers: [router.navigatorObserver],
      navigatorKey: router.navigatorKey,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
