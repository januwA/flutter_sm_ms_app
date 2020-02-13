import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:sm_ms/app/shared_module/service/images.service.dart';
import 'package:sm_ms/app/shared_module/service/userinfo.service.dart';
import 'app/app.dart';
import 'app/auth_module/auth.service.dart';

GetIt getIt = GetIt.instance;
void main() {
  getIt
    ..registerSingleton<AuthService>(AuthService())
    ..registerSingleton<UserinfoService>(UserinfoService())
    ..registerSingleton<ImagesService>(ImagesService());
  runApp(MyApp());
}
