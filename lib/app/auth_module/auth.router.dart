import 'package:flutter_ajanuw_router/ajanuw_route.dart';
import 'package:sm_ms/app/auth_module/pages/login/login.dart';

List<AjanuwRoute> authRoutes = [
  AjanuwRoute(
    path: 'login',
    builder: (c, r) => Login(),
  ),
];