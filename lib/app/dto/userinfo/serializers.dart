import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:sm_ms/app/dto/userinfo/user_info_dto.dart';

part 'serializers.g.dart';

@SerializersFor(const [UserInfoDto])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
