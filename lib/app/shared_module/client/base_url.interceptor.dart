import 'package:http_interceptor/http_interceptor.dart';
import 'package:path/path.dart' as path;

class BaseUrlInterceptor implements InterceptorContract {
  final p = path.Context(style: path.Style.url);
  final String baseUrl = "https://sm.ms/api/v2";

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    String url = data.url.toString();
    if (p.isRelative(url)) {
      url = p.normalize(p.join(baseUrl, url));
    }
    data.url = Uri.parse(url);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    return data;
  }
}
