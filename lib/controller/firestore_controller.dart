//Control Firebase file

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/auth_controller.dart';
import 'package:covia/model/inout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';
import '../screens/home_screen.dart';

class FirestoreController extends GetxController {
  static FirestoreController instance =
      Get.find(); // declare FirestoreController as Getcontroller
  FirebaseFirestore firebaseFirestore =
      FirebaseFirestore.instance; // initialize firebase firestore

  num activeuser = 0; // declare active user variable

  Future dropdownData(String queryString) async {
    // Dropdowndata function for HighRisk Area
    return FirebaseFirestore.instance
        .collection('HighRiskArea')
        .where('state', isEqualTo: queryString)
        .get(); //Firestore Query to fetch data
  }

  //search function
  Future queryData(String queryString) async {
    // Searchdata function for Crowdcheck
    return FirebaseFirestore.instance
        .collection('StoreInformation')
        .where('storename', isGreaterThan: queryString)
        .get(); //Firestore Query to fetch data
  }

  Future createUser(User user) async {
    // create user function
    final docUser = firebaseFirestore
        .collection('UserInformation')
        .doc(AuthController.instance.auth.currentUser?.uid);

    final json = user.toJson(); // get user model data and convert to json

    await docUser.set(json); // add the data to firebase
  }

  Future createSession(InOut inOut) async {
    //create session(check in/out) function
    final docInOut = firebaseFirestore.collection('InOut').doc(inOut.docId);

    final json = inOut.toJson(); // get inout model data and convert to json

    await docInOut.set(json); // add the data to firebase
  }

  Stream<DocumentSnapshot> readUser() => firebaseFirestore
      .collection('UserInformation')
      .doc(AuthController.instance.auth.currentUser?.uid)
      .snapshots(); //Firestore Query to fetch data from user

  checkOut(num docId, String outTime, String storeemail, num activeuser,
      String duration, bool isReachedLimit) {
    // check out function
    FirestoreController.instance.firebaseFirestore
        .collection('InOut')
        .doc(docId.toString())
        .update({
      // update the firebase data
      'outTime': outTime,
      'isOut': true,
      'duration': duration,
      'isReachedLimit': isReachedLimit
    });
    FirestoreController.instance.firebaseFirestore
        .collection('StoreInformation')
        .doc(storeemail)
        .update({
      'activeuser': activeuser--
    }); // when check out , this query deduct the active user by 1
  }

  storeInformation(String storeemail, String docId, String inTime, String date,
      String userfullname, bool uservaccinestatus) async {
    // store information function
    String storename = '';
    String riskstatus = '';
    num durationHours = 0;
    num durationMinutes = 0;
    num durationSeconds = 0;
    num totaluser = 0;
    bool isReachedLimit = false;

    try {
      await FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation')
          .doc(storeemail)
          .get() // get StoreInformation data
          .then((value) => {
                storename = value.data()?['storename'],
                riskstatus = value.data()?['riskstatus'],
                durationHours = value.data()?['durationHours'],
                durationMinutes = value.data()?['durationMinutes'],
                durationSeconds = value.data()?['durationSeconds'],
              });
             
      totaluser = activeuser + 1; // add active user
      final session = InOut(
          docId: docId,
          email: AuthController.instance.auth.currentUser!.email.toString(),
          inTime: inTime,
          date: date,
          isOut: false,
          duration: '',
         isReachedLimit: isReachedLimit,
          outTime: '',
          storename: storename,
          riskstatus: riskstatus,
          userfullname: userfullname,
          uservaccinestatus:
              uservaccinestatus); // store the Storeinformation data To inout model
      FirestoreController.instance
          .createSession(session); // call create session
      FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation')
          .doc(storeemail)
          .update({'activeuser': totaluser}); // update active user
      Get.off(
        // Go to HomeScreen
        () => Home_Screen(
          storeName: storename,
          storeEmail: storeemail,
          docId: docId,
          timeLimitHours: durationHours,
          timeLimitMinutes: durationMinutes,
          timeLimitSeconds: durationSeconds,
          startTimer: true,
          activeuser: activeuser,
        ),
      );
    } catch (e) {
      // if something wrong happen show snackbar about it
      Get.snackbar('$e', 'message');
    }
  }

  checkIn(String code, String docId, String inTime, String date,
      String userfullname, bool uservaccinestatus) async {
    // checkIn function

    try {
      await FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation')
          .get()
          .then((QuerySnapshot querySnapshot) {
        // get snapshot of the user data
        for (var element in querySnapshot.docs) {
          if (code == element['storename']) {
            // check if qr code is the same as the storename
            storeInformation(element.id, docId, inTime, date, userfullname,
                uservaccinestatus); // run storeInformation function
          }
        }
      });
    } catch (e) {
      // if something wrong happen show snackbar about it
      print('ERROR IN CHECKIN $e');
      Get.snackbar(
        "About QR Scanner",
        "QR Message",
        snackPosition: SnackPosition.TOP,
        titleText: Text(
          "QR Fail To Scan",
          style: TextStyle(color: Colors.white),
        ),
        messageText: Text(
          '$e',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}
