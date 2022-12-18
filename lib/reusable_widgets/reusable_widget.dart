import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(imageName, width: 340, height: 140);
}

TextField reusableTextField({required String text, required IconData icon, required bool isPasswordType, bool? isHidden, Function? onTap, 
    required TextEditingController controller}) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType && isHidden != null && isHidden,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black38,
      ),
      suffixIcon: isPasswordType ? GestureDetector(
            onTap: () { 
              if (onTap != null) {
                onTap();
              }
            },
            child: Icon(isHidden != null && isHidden ? Icons.visibility_off : Icons.visibility),
          )
          : null,
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.1),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
