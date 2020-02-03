import 'package:flutter_ajanuw_router/ajanuw_route.dart';
import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';
import 'package:sm_ms/app/pages/full_screen_image/full_screen_image.dart';

import 'auth_module/auth.guard.dart';
import 'pages/dash/dash.dart';
import 'pages/not-found/not-found.dart';

AjanuwRouter router = AjanuwRouter(printHistory: true);

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
    path: 'full-screen-image',
    builder: (c, r) {
      Map arg = r.arguments;
      return FullScreenImage(
        images: arg['images'],
        index: arg['index'],
      );
    },
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
