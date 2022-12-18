import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_project/screens/settings_screen.dart';
import 'package:first_flutter_project/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final userBox = Hive.box('userBox');
  final LocalStorage _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _localStorage.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Dashboard",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              icon: const Icon(Icons.settings),
              tooltip: "Setting Icon",
              color: Colors.black,
            ),
          ],
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: Text("userID: ${user?.uid}\ndisplayName: ${user?.displayName}\nemail: ${user?.email}\nlastSignInTime: ${user?.metadata.lastSignInTime}\n",
            style: TextStyle(
              fontSize: 18.0,
              height: 1.3,
              color: Color.fromRGBO(22, 27, 40, 70),
            ),
          ),
        ));
  }
}
