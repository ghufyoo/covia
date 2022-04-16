import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/newUser_screen.dart';
import '../screens/home_screen.dart';

num fromRegister = 1;

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print('Login page');

      Get.offAll(() => Login_Screen());
    } else if (fromRegister == 2) {
      Get.offAll(() => Newuser_Screen());
    } else {
      Get.offAll(() => Home_Screen());
    }
  }

  void register(
    String email,
    password,
  ) async {
    try {
      fromRegister = 2;
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {});
    } catch (e) {
      Get.snackbar(
        "About User",
        "User message",
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          "Registration Failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          'Please Try Again',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void login(String email, password) async {
    try {
      fromRegister = 1;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        "About Login",
        "Login message",
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          "Login failed",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          'Please make sure your password and email are right',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void logOut() async {
    await auth.signOut();
  }
}
