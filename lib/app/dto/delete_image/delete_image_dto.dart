/// repo: https://github.com/januwA/p5_object_2_builtvalue
/// generate: https://januwa.github.io/p5_object_2_builtvalue/index.html

library delete_image_dto;

import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'delete_image_dto.g.dart';

/// DeleteImageDto
abstract class DeleteImageDto
    implements Built<DeleteImageDto, DeleteImageDtoBuilder> {
  DeleteImageDto._();

  factory DeleteImageDto([updates(DeleteImageDtoBuilder b)]) = _$DeleteImageDto;

  @BuiltValueField(wireName: 'success')
  bool get success;

  @BuiltValueField(wireName: 'code')
  String get code;

  @BuiltValueField(wireName: 'message')
  String get message;

  String toJson() {
    return jsonEncode(
        serializers.serializeWith(DeleteImageDto.serializer, this));
  }

  static DeleteImageDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        DeleteImageDto.serializer, jsonDecode(jsonString));
  }

  static List<DeleteImageDto> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<DeleteImageDto>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<DeleteImageDto> get serializer =>
      _$deleteImageDtoSerializer;
}
