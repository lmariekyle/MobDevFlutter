import 'package:first_flutter_project/reusable_widgets/error_message.dart';
import 'package:first_flutter_project/screens/dashboard_screen.dart';
import 'package:first_flutter_project/services/auth_service.dart';
import 'package:first_flutter_project/services/local_storage.dart';
import 'package:first_flutter_project/utils/color_utils.dart';
import 'package:first_flutter_project/reusable_widgets/reusable_widget.dart';
import 'package:first_flutter_project/screens/signup_screen.dart';
import 'package:first_flutter_project/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  String errorMessage = "";
  bool isHidden = true;
  final userBox = Hive.box('userBox');
  final LocalStorage _localStorage = LocalStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoaderOverlay(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  hexStringToColor("D6CCC2"),
                  hexStringToColor("EDEDE9"),
                  hexStringToColor("F5EbE0")
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 250, 20, 50),
                    child: Column(
                      children: <Widget>[
                        logoWidget("assets/images/lmkc_big.png"),
                        const SizedBox(
                          height: 20,
                        ),
                        ErrorMessage(message: errorMessage),
                        reusableTextField(
                            text: "Enter Email",
                            icon: Icons.person_outline,
                            isPasswordType: false,
                            controller: _emailTextController),
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
                        signInSignUpButton(context, true, login),
                        googleOption(),
                        signUpOption()
                      ],
                    ),
                  ),
                ))));
  }

  void setPasswordVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void login() async {
    if (_emailTextController.text.isEmpty &&
        _passwordTextController.text.isEmpty) {
      setState(() {
        errorMessage = "Fields cannot be empty.";
      });
      return;
    }

    if (_emailTextController.text.isEmpty) {
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

    context.loaderOverlay.show();
    var res;
    res = await signIn(
        email: _emailTextController.text,
        password: _passwordTextController.text);

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
    Helper.nextScreenWithoutPrevious(context, const DashboardScreen());
  }

  void logInUsingGoogle() async {
    context.loaderOverlay.show();
    print("logging in using google...");
    var res = await loginWithGoogle();

    context.loaderOverlay.hide();
    if (res['info'] != 'successful') {
       setState(() {
        errorMessage = res['info'];
      });
      return;
    }

    // save to local storage
    var userInfo = res['user'];
    _localStorage.setUser(userInfo);
    Helper.nextScreenWithoutPrevious(context, const DashboardScreen());
    
  }

  Widget googleOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: const <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "OR",
                style: TextStyle(),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: logInUsingGoogle,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                width: 120.0,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/google.svg",
                      width: 30.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "Google",
                      style: TextStyle(
                        color: Color.fromRGBO(105, 108, 121, 1),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 35.0,
        ),
      ],
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.black54)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
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
