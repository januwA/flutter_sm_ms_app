import 'package:flutter_ajanuw_router/ajanuw_route.dart';
import 'package:flutter_ajanuw_router/flutter_ajanuw_router.dart';

import 'pages/dash/dash.dart';
import 'pages/not-found/not-found.dart';

AjanuwRouter router = AjanuwRouter();

final List<AjanuwRoute> routes = [
  AjanuwRoute(
    path: '',
    children: [
      AjanuwRoute(
        path: "",
        redirectTo: "dash",
      ),
      AjanuwRoute(
        path: "dash",
        builder: (context, r) => Dash(),
      ),
    ],
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

var onGenerateRoute = router.forRoot(routes);
