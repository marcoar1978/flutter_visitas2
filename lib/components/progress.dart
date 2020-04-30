import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  String msg;

  Progress({this.msg = "Loading"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text(this.msg),
        ],
      ),
    );
  }
}
