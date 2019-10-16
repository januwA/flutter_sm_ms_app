/// repo: https://github.com/januwA/p5_object_2_builtvalue
/// generate: https://januwa.github.io/p5_object_2_builtvalue/index.html

library login_dto;

import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'login_dto.g.dart';

/// LoginDto
abstract class LoginDto implements Built<LoginDto, LoginDtoBuilder> {
  LoginDto._();

  factory LoginDto([updates(LoginDtoBuilder b)]) = _$LoginDto;

  @BuiltValueField(wireName: 'success')
  bool get success;

  @BuiltValueField(wireName: 'code')
  String get code;

  @BuiltValueField(wireName: 'message')
  String get message;

  @BuiltValueField(wireName: 'data')
  DataDto get data;

  @BuiltValueField(wireName: 'RequestId')
  String get requestId;

  String toJson() {
    return jsonEncode(serializers.serializeWith(LoginDto.serializer, this));
  }

  static LoginDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        LoginDto.serializer, jsonDecode(jsonString));
  }

  static List<LoginDto> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<LoginDto>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<LoginDto> get serializer => _$loginDtoSerializer;
}

/// DataDto
abstract class DataDto implements Built<DataDto, DataDtoBuilder> {
  DataDto._();

  factory DataDto([updates(DataDtoBuilder b)]) = _$DataDto;

  @BuiltValueField(wireName: 'token')
  String get token;

  String toJson() {
    return jsonEncode(serializers.serializeWith(DataDto.serializer, this));
  }

  static DataDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        DataDto.serializer, jsonDecode(jsonString));
  }

  static List<DataDto> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<DataDto>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<DataDto> get serializer => _$dataDtoSerializer;
}
