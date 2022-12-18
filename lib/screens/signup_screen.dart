import 'package:first_flutter_project/reusable_widgets/error_message.dart';
import 'package:first_flutter_project/screens/dashboard_screen.dart';
import 'package:first_flutter_project/services/auth_service.dart';
import 'package:first_flutter_project/services/local_storage.dart';
import 'package:first_flutter_project/utils/color_utils.dart';
import 'package:first_flutter_project/reusable_widgets/reusable_widget.dart';
import 'package:first_flutter_project/screens/signin_screen.dart';
import 'package:first_flutter_project/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _emailAddressTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPassTextController =
      TextEditingController();
  bool isHidden = true;
  bool isConfirmPasswordHidden = true;
  String errorMessage = "";
  final userBox = Hive.box('userBox');
  final LocalStorage _localStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Sign Up",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          automaticallyImplyLeading: false,
        ),
        body: LoaderOverlay(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                hexStringToColor("D6CCC2"),
                hexStringToColor("EDEDE9"),
                hexStringToColor("F5EbE0")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      ErrorMessage(message: errorMessage),
                      reusableTextField(
                          text: "Enter First Name",
                          icon: Icons.person_outline,
                          isPasswordType: false,
                          controller: _firstNameTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          text: "Enter Last Name",
                          icon: Icons.person_outline,
                          isPasswordType: false,
                          controller: _lastNameTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          text: "Enter Email Address",
                          icon: Icons.email_outlined,
                          isPasswordType: false,
                          controller: _emailAddressTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          text: "Enter Password",
                          icon: Icons.lock_outline,
                          isPasswordType: true,
                          isHidden: isHidden,
                          onTap: () {
                            setPasswordVisibility();
                          },
                          controller: _passwordTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                          text: "Confirm Password",
                          icon: Icons.lock_outline,
                          isPasswordType: true,
                          isHidden: isConfirmPasswordHidden,
                          onTap: () {
                            setConfirmPasswordVisibility();
                          },
                          controller: _confirmPassTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      signInSignUpButton(context, false, registerMe),
                      const SizedBox(
                        height: 20,
                      ),
                      signInOption()
                    ],
                  ),
                ),
              )),
        ));
  }

  void setPasswordVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void setConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordHidden = !isConfirmPasswordHidden;
    });
  }

  void registerMe() async {
    if (_firstNameTextController.text.isEmpty &&
        _lastNameTextController.text.isEmpty &&
        _emailAddressTextController.text.isEmpty &&
        _passwordTextController.text.isEmpty &&
        _confirmPassTextController.text.isEmpty) {
      setState(() {
        errorMessage = "Fields cannot be empty.";
      });
      return;
    }

    if (_firstNameTextController.text.isEmpty) {
      setState(() {
        errorMessage = "First Name cannot be empty.";
      });
      return;
    }

    if (_lastNameTextController.text.isEmpty) {
      setState(() {
        errorMessage = "Last Name cannot be empty.";
      });
      return;
    }

    if (_emailAddressTextController.text.isEmpty) {
      setState(() {
        errorMessage = "Email is required.";
      });
      return;
    }

    if (_passwordTextController.text.isEmpty) {
      setState(() {
        errorMessage = "Password is required.";
      });
      return;
    }

    if (_passwordTextController.text != _confirmPassTextController.text) {
      setState(() {
        errorMessage = "Password and Confirm Password doesn't match.";
      });
      return;
    }

    context.loaderOverlay.show();

    var res;
    res = await register(
        email: _emailAddressTextController.text,
        password: _passwordTextController.text,
        firstName: _firstNameTextController.text,
        lastName: _lastNameTextController.text);
    context.loaderOverlay.hide();
    if (res['info'] != "successful") {
      setState(() {
        errorMessage = res['info'];
      });
      return;
    }

    // save to local storage
    var userInfo = res['user'];
    _localStorage.setUser(userInfo);
    Helper.nextScreenWithoutPrevious(context, DashboardScreen());
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ",
            style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white,
                shadows: [Shadow(color: Colors.white, offset: Offset(2, 1))]),
          ),
        )
      ],
    );
  }
}
