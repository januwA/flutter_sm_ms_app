import 'package:flutter/material.dart';
import 'package:flutter_imagenetwork/flutter_imagenetwork.dart';
import 'package:sm_ms/app/shared_module/service/images.service.dart';

import '../../../main.dart';

class FullScreenImage extends StatefulWidget {
  final int index;

  const FullScreenImage({Key key, this.index = 0}) : super(key: key);
  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  final imagesService = getIt<ImagesService>();
  PageController controller;
  int page = 0;

  @override
  void initState() {
    super.initState();
    page = widget.index;
    controller = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imagesService.images[page].filename),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: imagesService.images.length,
        itemBuilder: (context, int index) {
          var image = imagesService.images[index];
          return AjanuwImage(
            image: AjanuwNetworkImage(image.url),
            fit: BoxFit.contain,
            loadingWidget: AjanuwImage.defaultLoadingWidget,
            loadingBuilder: AjanuwImage.defaultLoadingBuilder,
            errorBuilder: AjanuwImage.defaultErrorBuilder,
          );
        },
        onPageChanged: (int index) {
          setState(() {
            page = index;
          });
        },
      ),
    );
  }
}
