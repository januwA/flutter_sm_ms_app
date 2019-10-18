import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sm_ms/app/app.router.dart';
import 'package:sm_ms/app/dto/delete_image/delete_image_dto.dart';
import 'package:sm_ms/app/dto/history_images/history_images.dto.dart';
import 'package:sm_ms/app/shared_module/client/client.dart';
import 'package:http/http.dart' as http;
import 'package:sm_ms/app/shared_module/pipes/image_size.dart';
import 'package:toast/toast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController controller = ScrollController();
  List<DataDto> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: client.get('upload_history'),
        builder: (context, AsyncSnapshot<http.Response> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snap.connectionState == ConnectionState.done) {
            var r = snap.data;
            if (r.statusCode == HttpStatus.ok) {
              var body = HistoryImagesDto.fromJson(r.body);
              if (body.success) {
                images = body.data.toList().reversed.toList();
                return _historyImages(images);
              } else {
                return Center(
                  child: Text(body.message),
                );
              }
            } else {
              return Center(
                child: Text('Error: ${snap.error}'),
              );
            }
          }
          return SizedBox();
        },
      ),
    );
  }

  /// 展示所有历史上传的图片
  Widget _historyImages(List<DataDto> images) {
    return RefreshIndicator(
      onRefresh: () async {
        // 下拉刷新
        setState(() {});
        return true;
      },
      child: GridView.count(
        controller: controller,
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        cacheExtent: 40,
        children: <Widget>[
          for (var image in images) _imageItem(image),
        ],
      ),
    );
  }

  Widget _imageItem(DataDto image) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                router.navigator.pushNamed(
                  '/full-screen-image',
                  arguments: {
                    "images": images,
                    "index": images.indexOf(image),
                  },
                );
              },
              child: Image.network(
                image.url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              image.filename,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(imageSize(image.size)),
          ),
          ButtonBar(
            mainAxisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: const Text('删除'),
                onPressed: () async {
                  /* send delete event. */
                  var url = Uri.parse('delete/${image.hash}');
                  var r = await client.get(url);
                  if (r.statusCode == HttpStatus.ok) {
                    var body = DeleteImageDto.fromJson(r.body);
                    Toast.show(body.message, context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    if (body.success) {
                      setState(() {});
                    }
                  } else {
                    Toast.show("删除失败.", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  }
                },
              ),
              FlatButton(
                child: const Text('复制'),
                onPressed: () {
                  /* 将image.url写入粘贴板  */
                  Clipboard.setData(ClipboardData(text: image.url));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
