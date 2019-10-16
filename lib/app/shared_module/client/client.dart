  import 'package:http_interceptor/http_interceptor.dart';

import 'authorization.interceptor.dart';
import 'base_url.interceptor.dart';

HttpClientWithInterceptor client = HttpClientWithInterceptor.build(
    interceptors: [
      BaseUrlInterceptor(),
      AuthorizationInterceptor(),
    ],
  );