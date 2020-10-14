import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../pages/dash/dash.dart';
import '../../../shared_module/widgets/http_loading_dialog.dart';
import '../../auth.service.dart';

const String REGISTER_URL = 'https://sm.ms/register';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final authService = getIt<AuthService>();
  TextEditingController _unameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameFocus =  FocusNode();
  final _pwdFocus =  FocusNode();

  bool get isValidate {
    if (_formKey.currentState.validate()) {
      return true;
    } else {
      Toast.show(
        "验证登陆表单失败!",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
      );
    }
    return false;
  }

  String get _username => _unameController.text.trim();
  String get _password => _passwordController.text.trim();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    _unameController?.dispose();
    _passwordController?.dispose();
    _formKey = null;
    _nameFocus.dispose();
    _pwdFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (isValidate) {
      showHttpLoadingDialog(context, 'login...');
      try {
        _nameFocus.unfocus();
        _pwdFocus.unfocus();
        await authService.login(_username, _password);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (_) => Dash()));
      } catch (e) {
        print(e);
        Navigator.of(context).pop();
        Toast.show(
          e.toString(),
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
        );
      }
    }
  }

  Future<void> _launchURL() async {
    if (await canLaunch(REGISTER_URL)) {
      await launch(REGISTER_URL);
    } else {
      throw 'Could not launch $REGISTER_URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  focusNode: _nameFocus,
                  controller: _unameController,
                  decoration: InputDecoration(labelText: "用户名/邮件地址"),
                  validator: (String v) {
                    return v.trim().isNotEmpty ? null : "不能为空";
                  },
                ),
                TextFormField(
                  focusNode: _pwdFocus,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "密码"),
                  validator: (String v) {
                    return v.trim().isNotEmpty ? null : "不能为空";
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      child: InkWell(
                        onTap: _launchURL,
                        child: Text(
                          '注册账号?',
                          style: theme.textTheme.caption.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: _login,
                  child: Text('登陆'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
