import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sm_ms/app/shared_module/client/client.dart';
import 'package:sm_ms/app/shared_module/widgets/http_loading_dialog.dart';
import 'package:toast/toast.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('上传'),
      ),
      body: Center(
        child: imageFile != null ? Image.file(imageFile) : Text('点击右下角上传.'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _pickImage(context);
        },
      ),
    );
  }

  /// 选择图片
  Future<void> _pickImage(BuildContext context) async {
    File _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile != null) {
      setState(() {
        imageFile = _imageFile;
      });
      _upload(context, imageFile);
    }
  }

  Future<void> _upload(BuildContext context, File imageFile) async {
    var stream = http.ByteStream(
      DelegatingStream.typed(imageFile.openRead()),
    );
    int length = await imageFile.length();
    String filename = basename(imageFile.path);
    var multipartFile =
        http.MultipartFile('smfile', stream, length, filename: filename);
    showHttpLoadingDialog(context, '上传中...');
    var r = await client.postFile('upload', files: [multipartFile]);
    Navigator.of(context).pop();
    if (r.statusCode == HttpStatus.ok) {
      var body = jsonDecode(r.body);
      if (body['success']) {
        Toast.show("上传成功: " + body['message'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("上传失败: " + body['message'], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }
  }
}
