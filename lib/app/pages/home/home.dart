import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:sm_ms/app/dto/history_images/history_images.dto.dart';
import 'package:sm_ms/app/shared_module/pipes/image_size.dart';
import 'package:sm_ms/app/shared_module/service/images.service.dart';
import 'package:sm_ms/app/shared_module/widgets/delete_image_dialog.dart';
import 'package:toast/toast.dart';

import '../../../main.dart';
import '../full_screen_image/full_screen_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController controller = ScrollController();
  final imagesService = getIt<ImagesService>();
  Widget loadingWidget = Center(child: CircularProgressIndicator());

  @override
  void initState() {
    super.initState();
    imagesService.init();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (imagesService.loading) {
            return loadingWidget;
          }

          if (imagesService.error != null) {
            return Center(child: Text('Error: ${imagesService.error}'));
          }
          return _historyImages(imagesService.images);
        },
      ),
    );
  }

  /// 展示所有历史上传的图片
  Widget _historyImages(ObservableList<DataDto> images) {
    return RefreshIndicator(
      onRefresh: () async {
        // 下拉刷新
        imagesService.update();
        await imagesService.init();
        return true;
      },
      child: GridView.count(
        key: PageStorageKey('images'),
        controller: controller,
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: <Widget>[
          for (var image in images) _imageItem(image),
        ],
      ),
    );
  }

  Widget _imageItem(DataDto image) {
    return Card(
      key: ValueKey(image.hash),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FullScreenImage(
                          index: imagesService.images.indexOf(image),
                        )));
              },
              child: AjanuwImage(
                image: AjanuwNetworkImage(image.url),
                fit: BoxFit.cover,
                loadingWidget: AjanuwImage.defaultLoadingWidget,
                loadingBuilder: AjanuwImage.defaultLoadingBuilder,
                errorBuilder: AjanuwImage.defaultErrorBuilder,
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
                  bool next = await showDeleteImageDiaLog<bool>(
                    context: context,
                    child: DeleteImageDiaLog(
                      onCancel: () => Navigator.of(context).pop(null),
                      onDelete: () => Navigator.of(context).pop(true),
                    ),
                  );

                  if (next == null) return;

                  try {
                    var r = await imagesService.remove(image);
                    Toast.show(r.toString(), context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } catch (e) {
                    Toast.show(e.toString(), context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                },
              ),
              FlatButton(
                child: const Text('复制'),
                onPressed: () async {
                  /* 将image.url写入粘贴板  */
                  await Clipboard.setData(ClipboardData(text: image.url));
                  Toast.show("复制完成", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
