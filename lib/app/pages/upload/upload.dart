import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sm_ms/app/shared_module/client/client.dart';
import 'package:sm_ms/app/shared_module/widgets/http_loading_dialog.dart';

import '../../shared_module/pipes/image_size.dart';
import '../../shared_module/widgets/http_loading_dialog.dart';

enum ImageFileStaus {
  normal,
  error,
  sucess,
}

class ImageFile {
  final File image;
  final int size;
  String filename;
  ImageFileStaus status = ImageFileStaus.normal;

  bool get success => status == ImageFileStaus.sucess;
  bool get error => status == ImageFileStaus.error;
  bool get normal => status == ImageFileStaus.normal;

  ImageFile(
    this.image, {
    this.size,
    this.filename,
  });
}

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  Set<ImageFile> _imageFiles = Set();
  Set<ImageFile> get displayImageFiles =>
      _imageFiles.where((element) => !element.success).toSet();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('上传'),
        actions: <Widget>[
          displayImageFiles.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.cloud_upload),
                  onPressed: () => _updateAll(context),
                )
              : SizedBox(),
        ],
      ),
      body: GridView.count(
        controller: controller,
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: <Widget>[
          for (var imageFile in displayImageFiles)
            _imageItem(context, imageFile),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _pickImage(context);
        },
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
      setState(() {
        imageFile.filename = newName;
      });
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
                onPressed: () async {
                  setState(() {
                    _imageFiles.remove(imageFile);
                  });
                },
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
      String filename = basename(imageFile.path);
      setState(() {
        _imageFiles.add(ImageFile(imageFile, size: size, filename: filename));
      });
      // _upload(context, imageFile);
    }
  }

  /// 上传所有
  _updateAll(BuildContext context) async {
    showHttpLoadingDialog(context, "All are uploading, please wait...");

    final successAll = [];
    for (var imageFile in _imageFiles) {
      try {
        await _upload(imageFile);
        successAll.add(imageFile);
        setState(() {
          imageFile.status = ImageFileStaus.sucess;
        });
      } catch (e) {
        setState(() {
          imageFile.status = ImageFileStaus.error;
        });
      }
    }
    Navigator.of(context).pop();
    _imageFiles.removeWhere((element) => successAll.contains(element));
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
    var r = await client.postFile('upload', files: [multipartFile]);
    if (r.statusCode == HttpStatus.ok && jsonDecode(r.body)["success"]) {
      return "success";
    } else {
      return Future.error("uoload error!");
    }
  }
}
