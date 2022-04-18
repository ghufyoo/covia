import 'package:covia/controller/auth_controller.dart';
import 'package:covia/controller/firestore_controller.dart';

import 'package:covia/screens/auth/login_screen.dart';
import 'package:covia/screens/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/auth/register_screen.dart';
import 'screens/crowdchecker_screen.dart';
import 'screens/highrisk_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(AuthController());
    Get.put(FirestoreController());
  });
  runApp(const CovIA());
}

class CovIA extends StatelessWidget {
  const CovIA({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Login_Screen(),
      getPages: [
        GetPage(name: '/', page: () => Login_Screen()),
        GetPage(
            name: '/registration_screen', page: () => Registration_Screen()),
        GetPage(name: '/home_screen', page: () => Home_Screen()),
        GetPage(name: '/profile_screen', page: () => Profile_Screen()),
        GetPage(name: '/history_screen', page: () => History_Screen()),
        GetPage(name: '/highrisk_screen', page: () => Highrisk_Screen()),
        GetPage(
            name: '/crowdchecker_screen', page: () => Crowdchecker_Screen()),
      ],
    );
  }
}
