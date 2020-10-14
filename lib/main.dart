import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:sm_ms/app/shared_module/service/images.service.dart';
import 'package:sm_ms/app/shared_module/service/userinfo.service.dart';
import 'app/auth_module/auth.service.dart';
import 'app/auth_module/pages/login/login.dart';
import 'app/pages/dash/dash.dart';
import 'theme/theme.dart';

GetIt getIt = GetIt.instance;
void main() {
  getIt
    ..registerSingleton<AuthService>(AuthService())
    ..registerSingleton<UserinfoService>(UserinfoService())
    ..registerSingleton<ImagesService>(ImagesService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authService = getIt<AuthService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: authService.getToken(),
      builder: (context, AsyncSnapshot<String> snap) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SM.MS',
          theme: myTheme,
          home: snap.connectionState == ConnectionState.done
              ? snap.data.isEmpty
                  ? Login()
                  : Dash()
              : Center(child: Text('Loading...')),
        );
      },
    );
  }
}
