/// repo: https://github.com/januwA/p5_object_2_builtvalue
/// generate: https://januwa.github.io/p5_object_2_builtvalue/index.html

library history_images_dto;

import 'dart:convert';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'history_images.dto.g.dart';
  
/// HistoryImagesDto
abstract class HistoryImagesDto implements Built<HistoryImagesDto, HistoryImagesDtoBuilder> {
  HistoryImagesDto._();

  factory HistoryImagesDto([updates(HistoryImagesDtoBuilder b)]) = _$HistoryImagesDto;
  
  @BuiltValueField(wireName: 'success')
  bool get success;

  @BuiltValueField(wireName: 'code')
  String get code;

  @BuiltValueField(wireName: 'message')
  String get message;

  @BuiltValueField(wireName: 'data')
  BuiltList<DataDto> get data;


  String toJson() {
    return jsonEncode(serializers.serializeWith(HistoryImagesDto.serializer, this));
  }

  static HistoryImagesDto fromJson(String jsonString) {
    return serializers.deserializeWith(
        HistoryImagesDto.serializer, jsonDecode(jsonString));
  }

  static List<HistoryImagesDto> fromListJson(String jsonString) {
    return jsonDecode(jsonString)
        .map<HistoryImagesDto>((e) => fromJson(jsonEncode(e)))
        .toList();
  }

  static Serializer<HistoryImagesDto> get serializer => _$historyImagesDtoSerializer;
}

/// DataDto
abstract class DataDto implements Built<DataDto, DataDtoBuilder> {
  DataDto._();

  factory DataDto([updates(DataDtoBuilder b)]) = _$DataDto;
  
  @BuiltValueField(wireName: 'width')
  int get width;

  @BuiltValueField(wireName: 'height')
  int get height;

  @BuiltValueField(wireName: 'filename')
  String get filename;

  @BuiltValueField(wireName: 'storename')
  String get storename;

  @BuiltValueField(wireName: 'size')
  int get size;

  @BuiltValueField(wireName: 'path')
  String get path;

  @BuiltValueField(wireName: 'hash')
  String get hash;

  @BuiltValueField(wireName: 'url')
  String get url;

  @BuiltValueField(wireName: 'delete')
  String get delete;

  @BuiltValueField(wireName: 'page')
  String get page;


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