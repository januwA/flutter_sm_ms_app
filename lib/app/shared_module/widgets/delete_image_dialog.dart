import 'package:flutter/material.dart';

Future<T> showDeleteImageDiaLog<T>({
  BuildContext context,
  Widget child,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierColor: Color(0x80000000),
    barrierLabel: 'Dismiss',
    transitionDuration: Duration(milliseconds: 300),
    transitionBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      var tween = Tween(begin: Offset(0, 1.0), end: Offset(0, 0.8));
      return SlideTransition(
        position: tween
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
        child: child,
      );
    },
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return child;
    },
  );
}

class DeleteImageDiaLog extends StatelessWidget {
  final Function onDelete;
  final Function onCancel;

  const DeleteImageDiaLog({Key key, this.onDelete, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var btnStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '是否删除图片 ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        child: Text('取消', style: btnStyle),
                        onPressed: onCancel,
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(color: Colors.grey.withOpacity(.4)),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text('删除', style: btnStyle),
                        onPressed: onDelete,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
