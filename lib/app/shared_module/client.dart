import 'package:ajanuw_http/ajanuw_http.dart';
import 'package:dart_printf/dart_printf.dart';
import 'package:http/http.dart';

import '../../main.dart';
import '../auth_module/auth.service.dart';

class HeaderInterceptor extends AjanuwHttpInterceptors {
  final authService = getIt<AuthService>();

  @override
  Future<AjanuwHttpConfig> request(AjanuwHttpConfig config) async {
    config.headers ??= {};

    var _token = await authService.getToken();
    printf("Token: %s", _token);
    if (_token?.isNotEmpty ?? false) config.headers['Authorization'] = _token;
    return config;
  }

  @override
  Future<Response> response(BaseResponse response, _) async {
    return response;
  }
}

var client = AjanuwHttp()
  ..config.baseURL = 'https://sm.ms/api/v2'
  ..interceptors.add(HeaderInterceptor());
