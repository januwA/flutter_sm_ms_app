import 'dart:convert';
import 'dart:io';

import 'package:ajanuw_http/ajanuw_http.dart';
import 'package:mobx/mobx.dart';
import 'package:sm_ms/app/shared_module/data/image_file.dart';
import '../../dto/delete_image/delete_image_dto.dart';
import '../../dto/history_images/history_images.dto.dart';
import '../client.dart';

part 'images.service.g.dart';

class ImagesService = IimagesService with _$ImagesService;

abstract class IimagesService with Store {
  bool _init = false;

  @observable
  bool loading = false;

  @observable
  String error;

  /// 初始化[images]
  @action
  Future<void> init() async {
    if (!_init) {
      try {
        loading = true;
        var r = await client.get('upload_history');
        var body = HistoryImagesDto.fromJson(r.body);
        if (body.success) {
          images = ObservableList.of(body.data.toList().reversed.toList());
          _init = true;
          error = null;
          loading = false;
        } else {
          throw body.message;
        }
      } catch (e) {
        loading = false;
        error = e.toString();
      }
    }
  }

  /// 已经上传的图片列表
  @observable
  ObservableList<DataDto> images = ObservableList<DataDto>();

  /// 同步服务器添加图片
  @action
  Future<String> add(MultipartFile file) async {
    try {
      var r = await client.post(
        'upload',
        AjanuwHttpConfig(files: [file]),
      );
      if (r.statusCode == HttpStatus.ok) {
        Map body = jsonDecode(r.body);
        if (body["success"]) {
          DataDto image = DataDto.fromJson(jsonEncode(body["data"]));
          images.insert(0, image);
          return body['message'];
        } else {
          throw body['message'];
        }
      } else {
        throw "uoload error!";
      }
    } catch (e) {
      throw e;
    }
  }

  /// 同步服务器删除图片
  @action
  Future<String> remove(DataDto image) async {
    try {
      var r = await client.get('delete/${image.hash}');
      if (r.statusCode == HttpStatus.ok) {
        var body = DeleteImageDto.fromJson(r.body);
        if (body.success) {
          images.removeWhere((x) => x == image);
        }
        return body.message;
      } else {
        throw "删除失败";
      }
    } catch (e) {
      return e;
    }
  }

  /// 如果要更新[images],先执行[update]在执行[init]
  @action
  update() {
    _init = false;
  }

  /// 准备上传的图片列表
  @observable
  ObservableList<ImageFile> imageFiles = ObservableList<ImageFile>();

  /// 过滤掉上传成功的image
  @computed
  ObservableList<ImageFile> get displayImageFiles =>
      ObservableList.of(imageFiles.where((e) => !e.success));

  @action
  addImageFile(ImageFile imageFile) {
    imageFiles.add(imageFile);
  }

  @action
  remImageFile(ImageFile imageFile) {
    imageFiles.removeWhere((e) => e == imageFile);
  }

  @action
  remSuccessAll(List<ImageFile> successAll) {
    imageFiles.removeWhere((e) => successAll.contains(e));
  }
}
