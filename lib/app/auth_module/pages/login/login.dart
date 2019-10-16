import 'package:flutter/material.dart';
import 'package:sm_ms/store/main/main.store.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _unameController.dispose();
    _passwordController.dispose();
    _formKey = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _unameController,
                  decoration: InputDecoration(labelText: "用户名/邮件地址"),
                  validator: (String v) {
                    return v.trim().isNotEmpty ? null : "不能为空";
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "密码"),
                  validator: (String v) {
                    return v.trim().isNotEmpty ? null : "不能为空";
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      mainStore.authService.login(
                          _unameController.text, _passwordController.text);
                    }
                  },
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
