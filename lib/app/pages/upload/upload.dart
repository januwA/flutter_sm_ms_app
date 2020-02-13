import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sm_ms/app/shared_module/data/image_file.dart';
import 'package:sm_ms/app/shared_module/service/images.service.dart';
import 'package:sm_ms/app/shared_module/widgets/http_loading_dialog.dart';

import '../../../main.dart';
import '../../shared_module/pipes/image_size.dart';
import '../../shared_module/widgets/http_loading_dialog.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final imagesService = getIt<ImagesService>();
  TextEditingController _editNameController = TextEditingController();
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
    _editNameController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('上传'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            imagesService.displayImageFiles.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.cloud_upload),
                    onPressed: () => _updateAll(context),
                  )
                : SizedBox(),
          ],
        ),
        body: GridView.count(
          key: PageStorageKey('upload images'),
          controller: controller,
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: imagesService.displayImageFiles
              .map((e) => _imageItem(context, e))
              .toList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _pickImage(context),
        ),
      ),
    );
  }

  _editImageName(BuildContext context, ImageFile imageFile) async {
    String newName = await showDialog<String>(
      context: context,
      builder: (context) {
        _editNameController.text = imageFile.filename;
        return AlertDialog(
          title: Text('Edit name of the image.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    controller: _editNameController,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            RaisedButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(_editNameController.text);
              },
            ),
          ],
        );
      },
    );
    if (newName != null) {
      imageFile.setFilename(newName);
    }
  }

  Widget _imageItem(BuildContext context, ImageFile imageFile) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: imageFile.error
                ? ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.red, BlendMode.modulate),
                    child: Image.file(imageFile.image),
                  )
                : Image.file(imageFile.image),
          ),
          ListTile(
            dense: true,
            title: Text(
              imageFile.filename,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(imageSize(imageFile.size)),
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: const Text('删除'),
                onPressed: () => imagesService.remImageFile(imageFile),
              ),
              FlatButton(
                child: const Text('修改'),
                onPressed: () => _editImageName(context, imageFile),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 选择图片
  Future<void> _pickImage(BuildContext context) async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      int size = await imageFile.length();
      imagesService.addImageFile(
        ImageFile(
          imageFile,
          size: size,
          filename: basename(imageFile.path),
        ),
      );
    }
  }

  /// 上传所有
  _updateAll(BuildContext context) async {
    showHttpLoadingDialog(context, "All are uploading, please wait...");

    List<ImageFile> successAll = [];
    for (var imageFile in imagesService.imageFiles) {
      try {
        await _upload(imageFile);
        successAll.add(imageFile);
        imageFile.setStatus(ImageFileStaus.sucess);
      } catch (e) {
        imageFile.setStatus(ImageFileStaus.error);
      }
    }
    Navigator.of(context).pop();
    imagesService.remSuccessAll(successAll);
  }

  Future<void> _upload(ImageFile imageFile) async {
    final image = imageFile.image;
    var stream = http.ByteStream(
      DelegatingStream.typed(image.openRead()),
    );
    var multipartFile = http.MultipartFile(
      'smfile',
      stream,
      imageFile.size,
      filename: imageFile.filename,
    );
    try {
      return await imagesService.add(multipartFile);
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
