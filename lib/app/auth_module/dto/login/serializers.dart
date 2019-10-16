import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:sm_ms/app/auth_module/dto/login/login_dto.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  LoginDto,
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();