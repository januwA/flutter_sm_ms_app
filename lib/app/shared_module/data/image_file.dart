import 'dart:io';

import 'package:mobx/mobx.dart';

part 'image_file.g.dart';

enum ImageFileStaus {
  normal,
  error,
  sucess,
}
class ImageFile = _ImageFile with _$ImageFile;

abstract class _ImageFile with Store {
  _ImageFile(
    this.image, {
    this.size,
    this.filename,
  });

  @observable
  File image;

  @observable
  int size;

  @observable
  String filename;

  @action
  void setFilename(String name) {
    filename = name;
  }

  @observable
  ImageFileStaus _status = ImageFileStaus.normal;

  @action
  void setStatus(ImageFileStaus v) {
    _status = v;
  }

  @computed
  bool get success => _status == ImageFileStaus.sucess;

  @computed
  bool get error => _status == ImageFileStaus.error;

  @computed
  bool get normal => _status == ImageFileStaus.normal;
}
