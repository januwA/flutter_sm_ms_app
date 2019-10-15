import 'package:flutter/material.dart';

class NotFound extends StatefulWidget {
  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NotFound'),
      ),
      body: Center(
        child: Text('NotFound work.'),
      ),
    );
  }
}