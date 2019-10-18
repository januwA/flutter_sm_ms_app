/// repo: https://github.com/januwA/p5_object_2_builtvalue
/// generate: https://januwa.github.io/p5_object_2_builtvalue/index.html

library user_info_dto;

import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'user_info_dto.g.dart';

/// UserInfoDto
abstract class UserInfoDto implements Built<UserInfoDto, UserInfoDtoBuilder> {
  UserInfoDto._();

  factory UserInfoDto([updates(UserInfoDtoBuilder b)]) = _$UserInfoDto;

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
    return jsonEncode(serializers.serializeWith(UserInfoDto.serializer, this));
  }

  static UserInfoDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        UserInfoDto.serializer, jsonDecode(jsonString));
  }

  static List<UserInfoDto> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<UserInfoDto>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<UserInfoDto> get serializer => _$userInfoDtoSerializer;
}

/// DataDto
abstract class DataDto implements Built<DataDto, DataDtoBuilder> {
  DataDto._();

  factory DataDto([updates(DataDtoBuilder b)]) = _$DataDto;

  @BuiltValueField(wireName: 'username')
  String get username;

  @BuiltValueField(wireName: 'email')
  String get email;

  @BuiltValueField(wireName: 'role')
  String get role;

  @BuiltValueField(wireName: 'group_expire')
  String get groupExpire;

  @BuiltValueField(wireName: 'disk_usage')
  String get diskUsage;

  @BuiltValueField(wireName: 'disk_limit')
  String get diskLimit;

  @BuiltValueField(wireName: 'disk_usage_raw')
  int get diskUsageRaw;

  @BuiltValueField(wireName: 'disk_limit_raw')
  int get diskLimitRaw;

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
