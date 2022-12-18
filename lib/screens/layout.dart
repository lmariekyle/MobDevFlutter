import 'package:first_flutter_project/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:first_flutter_project/screens/dashboard_screen.dart';
import 'package:first_flutter_project/screens/signin_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final userBox = Hive.box('userBox');
  final LocalStorage _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _localStorage.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return _localStorage.user != null && !_localStorage.user.isEmpty ? DashboardScreen() : SignInScreen();
  }
}
