import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<Object> register(
    {required String email,
    required String password,
    required String firstName,
    required String lastName}) async {
  try {
    var res = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var user = res.user;

    await user?.updateDisplayName("$firstName $lastName");
    return {
      'info': "successful",
      'user': {
        'uid': user?.uid,
        'displayName': user?.displayName,
        'email': user?.email,
        'lastSignInTime': user?.metadata.lastSignInTime
      }
    };
  } on FirebaseAuthException catch (err) {
    if (err.code == "invalid-email") {
      return {'info': "Invalid Email.", 'user': {}};
    }

    if (err.code == 'weak-password') {
      return {'info': "Weak Password", 'user': {}};
    }

    if (err.code == 'email-already-in-use') {
      return {'info': "Email is already in use.", 'user': {}};
    }
  }
  return {'info': "Cannot Perform Action.", 'user': {}};
}

Future<Object> signIn({required String email, required String password}) async {
  try {
    var instance = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return {
      'info': "successful",
      'user': {
        'uid': instance.user?.uid,
        'displayName': instance.user?.displayName,
        'email': instance.user?.email,
        'lastSignInTime': instance.user?.metadata.lastSignInTime
      }
    };
  } on FirebaseAuthException catch (err) {
    if (err.code == "invalid-email") {
      return {'info': "Invalid Email.", 'user': {}};
    }

    if (err.code == "user-not-found") {
      return {'info': "User is not found.", 'user': {}};
    }

    if (err.code == "wrong-password") {
      return {'info': "Wrong Password.", 'user': {}};
    }
  }
  return {'info': "Cannot Perform Action.", 'user': {}};
}

Future loginWithGoogle() async {
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? account = await googleSignIn.signIn();

    if (account == null) {
      return {'info': "Account does not exist.", 'user': {}};
    }

    final googleAuth = await account.authentication;

    UserCredential user = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken));

    if (user.user == null) {
      return {'info': "User does not exist.", 'user': {}};
    }

    return {
      'info': "successful",
      'user': {
        'uid': user.user?.uid,
        'displayName': user.user?.displayName,
        'email': user.user?.email,
        'lastSignInTime': user.user?.metadata.lastSignInTime
      }
    };

  } catch (e) {
    print("LOGIN WITH GOOGLE ERROR: " + e.toString());
  }
    return {'info': "Cannot Perform Action.", 'user': {}};
}

Future<void> signOut() async {
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.disconnect();

    await FirebaseAuth.instance.signOut();
  } catch (e) {
    print("SIGN OUT ERROR: ${e.toString()}");
  }
}
