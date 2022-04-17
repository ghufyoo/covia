import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/auth_controller.dart';
import 'package:covia/model/inout_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';
import '../screens/home_screen.dart';

class FirestoreController extends GetxController {
  static FirestoreController instance = Get.find();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  num activeuser = 0;
  //selected dropdown function
  Future dropdownData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('HighRiskArea')
        .where('state', isEqualTo: queryString)
        .get();
  }

  //search function
  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('StoreInformation')
        .where('storename', isGreaterThan: queryString)
        .get();
  }

  Future createUser(User user) async {
    final docUser = firebaseFirestore
        .collection('UserInformation')
        .doc(AuthController.instance.auth.currentUser?.uid);

    final json = user.toJson();

    await docUser.set(json);
  }

  Future createSession(InOut inOut) async {
    final docInOut = firebaseFirestore.collection('InOut').doc(inOut.docId);

    final json = inOut.toJson();

    await docInOut.set(json);
// await ref.doc(docId).set({
//   'title' : title,
//   'type' : type,
//   'date' : dayDate,
//   'time' : _dayTime,
//   'category' : category,
//   'author' : loggedInUser.uid,
//   'id' : docId
// });
  }

  Stream<DocumentSnapshot> readUser() => firebaseFirestore
      .collection('UserInformation')
      .doc(AuthController.instance.auth.currentUser?.uid)
      .snapshots();

  checkOut(num docId, String outTime, String storeemail, num activeuser,
      String duration, bool isReachedLimit) {
    FirestoreController.instance.firebaseFirestore
        .collection('InOut')
        .doc(docId.toString())
        .update({
      'outTime': outTime,
      'isOut': true,
      'duration': duration,
      'isReachedLimit': isReachedLimit
    });
    FirestoreController.instance.firebaseFirestore
        .collection('StoreInformation')
        .doc(storeemail)
        .update({'activeuser': activeuser--});
  }

  //StoreInformation

  storeInformation(String storeemail, String docId, String inTime, String date,
      String userfullname, bool uservaccinestatus) async {
    String storename = '';
    String riskstatus = '';
    num durationHours = 0;
    num durationMinutes = 0;
    num durationSeconds = 0;
    num totaluser = 0;
    //num totaluser = 0;

    try {
      await FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation')
          .doc(storeemail)
          .get()
          .then((value) => {
                storename = value.data()?['storename'],
                riskstatus = value.data()?['riskstatus'],
                durationHours = value.data()?['durationHours'],
                durationMinutes = value.data()?['durationMinutes'],
                durationSeconds = value.data()?['durationSeconds'],
                activeuser = value.data()?['activeuser'],
              });
      totaluser = activeuser + 1;
      final session = InOut(
          docId: docId,
          email: AuthController.instance.auth.currentUser!.email.toString(),
          inTime: inTime,
          date: date,
          isOut: false,
          duration: '',
          isReachedLimit: false,
          outTime: '',
          storename: storename,
          riskstatus: riskstatus,
          userfullname: userfullname,
          uservaccinestatus: uservaccinestatus);
      FirestoreController.instance.createSession(session);
      FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation')
          .doc(storeemail)
          .update({'activeuser': totaluser});
      Get.off(
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
      // FirestoreController.instance.firebaseFirestore
      //     .collection('StoreInformation')
      //     .doc(storeemail)
      //     .update({'activeuser': activeuser}).then((value) {});

      // totaluser = activeuser;
    } catch (e) {
      Get.snackbar('$e', 'message');
    }
  }

  checkIn(String code, String docId, String inTime, String date,
      String userfullname, bool uservaccinestatus) async {
    String store = code;
    //String riskstatus = '';
    // String storeemail = '';
    // num timeLimitHours = 0;
    // num timeLimitMinutes = 0;
    // num timeLimitSeconds = 0;
    try {
      await FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var element in querySnapshot.docs) {
          // print(element['storename']);
          //store = element['storename'];
          //
          //  riskstatus = element['riskstatus'];
          //timeLimitHours = element['durationHours'];
          // timeLimitMinutes = element['durationMinutes'];
          //timeLimitSeconds = element['durationSeconds'];
          if (code == element['storename']) {
            storeInformation(element.id, docId, inTime, date, userfullname,
                uservaccinestatus);

            //TODO: test qr code and find solution for time limit

            // final session = InOut(
            //     docId: docId,
            //     email:
            //         AuthController.instance.auth.currentUser!.email.toString(),
            //     inTime: inTime,
            //     date: date,
            //     isOut: false,
            //     duration: '',
            //     isReachedLimit: false,
            //     outTime: '',
            //     storename: store,
            //     riskstatus: riskstatus,
            //     username: username);
            // FirestoreController.instance
            //     .createSession(session)
            //     .then((value) async {
            //   print('called');
            //   await storeInformation(storeemail, store, timeLimitHours,
            //       timeLimitMinutes, timeLimitSeconds);
            // });
          }
        }
      });
      return store;
    } catch (e) {
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
