//Control authentication file

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/newUser_screen.dart';
import '../screens/home_screen.dart';

num fromRegister = 1; // variable to check new user

class AuthController extends GetxController {
  static AuthController instance =
      Get.find(); // declare AuthController as Getcontroller

  late Rx<User?> _user; // store user data
  FirebaseAuth auth =
      FirebaseAuth.instance; // initialize firebase authentication

  @override
  void onReady() {
    // funtion that bind user authentication, like check user, or changing user

    super.onReady();

    _user = Rx<User?>(auth.currentUser); // get current user
    _user.bindStream(auth.userChanges()); //check user session
    ever(_user,
        _initialScreen); // if there is user direct them to initial screen
  }

  _initialScreen(User? user) {
    // function that direct user to the respective screen based on the credentials
    if (user == null) {
      // if no user
      Get.offAll(() => Login_Screen()); // Go to Login screen
    } else if (fromRegister == 2) {
      // if new user
      Get.offAll(() => Newuser_Screen()); // Go to Newuser screen
    } else {
      // if user logged in
      Get.offAll(() => Home_Screen()); // Go to Home screen
    }
  }

  void register(
    String email,
    password,
  ) async {  // Register user function
    
    try {
      fromRegister = 2;  // declare this user as New
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)  // create user and store it on firebase
          .then((result) {});
    } catch (e) { // if something wrong happen show snackbar about it
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

  void login(String email, password) async {  // Login user function
    try {
      fromRegister = 1;  // declare user as old user
      await auth.signInWithEmailAndPassword(email: email, password: password);  // sign the user in with firebase
    } catch (e) { // if something wrong happen show snacbar about it
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

  void logOut() async {  // Log out user function
    await auth.signOut(); // log user out with firebase
  }
}
