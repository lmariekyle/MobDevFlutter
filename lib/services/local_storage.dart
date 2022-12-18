import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  // get a reference of the box
  final userBox = Hive.box('userBox');
  var user;

  void getUser() {
    user = userBox.get('CURRENT_USER');
  }

  void deleteUser() {
    userBox.delete('CURRENT_USER');
  }

  void setUser(userInfo) {
    userBox.put('CURRENT_USER', userInfo);
  }

}