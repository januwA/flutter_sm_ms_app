import 'package:http_interceptor/http_interceptor.dart';

import '../../../main.dart';
import '../../auth_module/auth.service.dart';

class AuthorizationInterceptor implements InterceptorContract {
  final authService = getIt<AuthService>();
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      if (authService.hasToken) {
        data.headers['Authorization'] = authService.getAuthorizationToken();
      }
    } catch (e) {
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
