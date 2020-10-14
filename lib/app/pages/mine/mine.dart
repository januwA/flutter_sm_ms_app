import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sm_ms/app/shared_module/service/userinfo.service.dart';

import '../../../main.dart';
import '../../auth_module/auth.service.dart';

class Mine extends StatefulWidget {
  @override
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  final userinfoService = getIt<UserinfoService>();
  final authService = getIt<AuthService>();

  @override
  void initState() {
    super.initState();
    userinfoService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (userinfoService.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (userinfoService.error != null) {
            return Center(child: Text(userinfoService.error));
          }

          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(userinfoService.username),
                    subtitle: Text(userinfoService.email),
                  ),
                  ListTile(
                    title: Text("总磁盘: " + userinfoService.diskLimit),
                    subtitle: Text('已使用: ' + userinfoService.diskUsage),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('退出登录'),
                        onPressed: () => authService.logout(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
