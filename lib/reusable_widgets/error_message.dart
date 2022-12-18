import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  ErrorMessage({this.message = ""});

  @override
  Widget build(BuildContext context) {
    return message != ""
        ? Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          )
        : Container();
  }
}