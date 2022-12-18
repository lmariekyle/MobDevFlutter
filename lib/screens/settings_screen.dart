import 'package:first_flutter_project/screens/layout.dart';
import 'package:first_flutter_project/services/auth_service.dart';
import 'package:first_flutter_project/services/local_storage.dart';
import 'package:first_flutter_project/utils/color_utils.dart';
import 'package:first_flutter_project/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

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
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
            "Settings",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)
        ),
        automaticallyImplyLeading: true,
      ),
        body: Container (
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:
            [hexStringToColor("D6CCC2"),
              hexStringToColor("EDEDE9"),
              hexStringToColor("F5EbE0")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 280, 20, 280),
              child: Column(
                children: <Widget>[
                  ElevatedButton(onPressed: () async {
                    await signOut();
                    _localStorage.deleteUser();
                    Helper.nextScreenWithoutPrevious(context, Layout());
                  }, child: Text(
                    'LOG OUT',
                    style: const TextStyle(
                        color:Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black26;
                        }
                        return Colors.white;
                      }),
                    )
                  )
                ],
              ),
              ),
            )
          ),
    );
  }
}
