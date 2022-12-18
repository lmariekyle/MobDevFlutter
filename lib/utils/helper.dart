import 'package:flutter/material.dart';

class Helper {
  static nextScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return screen;
        },
      ),
    );
  }

  static nextScreenWithoutPrevious(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (BuildContext context) {
          return screen;
        },
      ),
    );
  }
}
