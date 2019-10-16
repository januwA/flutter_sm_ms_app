import 'package:http_interceptor/http_interceptor.dart';
import 'package:sm_ms/store/main/main.store.dart';

class AuthorizationInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    try {
      if (mainStore.tokenService.hasToken) {
        data.headers['Authorization'] = mainStore.tokenService.getAuthorizationToken();
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
