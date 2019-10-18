import 'package:flutter/material.dart';
import 'package:sm_ms/app/pages/home/home.dart';
import 'package:sm_ms/app/pages/mine/mine.dart';
import 'package:sm_ms/app/pages/upload/upload.dart';

class Dash extends StatefulWidget {
  @override
  _DashState createState() => _DashState();
}

class _DashState extends State<Dash> {
  int _currentIndex = 0;
  final PageController _controller = PageController();

  pageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: pageChange,
        children: <Widget>[
          Home(),
          Upload(),
          Mine(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          pageChange(index);
          _controller.jumpToPage(index);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_upload),
              activeIcon: Icon(Icons.file_upload),
              title: Text("上传")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              title: Text("我的")),
        ],
      ),
    );
  }
}
