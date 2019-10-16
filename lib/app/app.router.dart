import 'package:flutter_ajanuw_router/ajanuw_route.dart';
import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';

import 'auth_module/auth.guard.dart';
import 'pages/dash/dash.dart';
import 'pages/not-found/not-found.dart';

AjanuwRouter router = AjanuwRouter();

List<AjanuwRoute> appRoutes = [
  AjanuwRoute(
    path: "",
    redirectTo: "dash",
  ),
  AjanuwRoute(
    path: "dash",
    canActivate: [
      authGuard,
    ],
    builder: (context, r) => Dash(),
  ),
  AjanuwRoute(
    path: "not-found",
    builder: (context, r) => NotFound(),
  ),
  AjanuwRoute(
    path: AjanuwRoute.notFoundRouteName,
    redirectTo: '/not-found',
  ),
];
