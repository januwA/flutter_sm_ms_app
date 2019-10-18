import 'package:flutter/material.dart';
import 'package:sm_ms/app/dto/history_images/history_images.dto.dart';

class FullScreenImage extends StatefulWidget {
  final List<DataDto> images;
  final int index;

  const FullScreenImage({Key key, @required this.images, this.index = 0})
      : super(key: key);
  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  PageController controller;
  int page = 0;
  DataDto get image => widget.images[page];

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
        title: Text(image.filename),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: widget.images.length,
        itemBuilder: (context, int index) {
          var image = widget.images[index];
          return Image.network(
            image.url,
            fit: BoxFit.contain,
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
