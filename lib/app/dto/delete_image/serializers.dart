import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'delete_image_dto.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  DeleteImageDto
])
final Serializers serializers = (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();