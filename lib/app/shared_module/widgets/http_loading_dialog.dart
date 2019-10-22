import 'package:flutter/material.dart';

Future<T> showHttpLoadingDialog<T>(BuildContext context, String message) async {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return HttpLoadingDialog(message: message);
    },
  );
}

class HttpLoadingDialog extends StatelessWidget {
  final String message;

  const HttpLoadingDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 12),
              Text(message),
            ],
          ),
        ),
      ],
    );
  }
}
