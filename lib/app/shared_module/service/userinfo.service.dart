import 'package:mobx/mobx.dart';

import '../../dto/userinfo/user_info_dto.dart';
import '../client.dart';

part 'userinfo.service.g.dart';

class UserinfoService = _UserinfoService with _$UserinfoService;

abstract class _UserinfoService with Store {
  @observable
  String username;

  @observable
  String email;

  /// 总磁盘
  @observable
  String diskLimit;

  /// 已使用
  @observable
  String diskUsage;

  @observable
  String error;

  @observable
  bool loading = false;

  bool _init = false;

  @action
  Future<void> init() async {
    if (!_init) {
      try {
        loading = true;
        var r = await client.post('profile');
        var body = UserInfoDto.fromJson(r.body);
        if (body.success) {
          username = body.data.username;
          email = body.data.email;
          diskLimit = body.data.diskLimit;
          diskUsage = body.data.diskUsage;
          loading = false;
          _init = true;
          error = null;
        } else {
          throw body.message;
        }
      } catch (e) {
        error = e.toString();
        loading = false;
      }
    }
  }
}
