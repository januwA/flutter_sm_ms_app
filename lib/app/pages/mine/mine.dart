import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sm_ms/app/dto/userinfo/user_info_dto.dart';
import 'package:sm_ms/app/shared_module/client/client.dart';
import 'package:http/http.dart' as http;

class Mine extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: client.post('profile'),
        builder: (context, AsyncSnapshot<http.Response> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasError) {
              return Center(child: Text('${snap.error}'));
            }
            var r = snap.data;
            if (r.statusCode == HttpStatus.ok) {
              var body = UserInfoDto.fromJson(r.body);
              if (body.success) {
                return Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: Text(body.data.username),
                          subtitle: Text(body.data.email),
                        ),
                        ListTile(
                          title: Text("总磁盘: " + body.data.diskLimit),
                          subtitle: Text('已使用: ' + body.data.diskUsage),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text(body.message));
              }
            }
            return Center(child: Text('get user info error.'));
          }
          return SizedBox();
        },
      ),
    );
  }
}
