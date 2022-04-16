import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/auth_controller.dart';
import 'package:covia/model/inout_model.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';
import '../screens/home_screen.dart';

class FirestoreController extends GetxController {
  static FirestoreController instance = Get.find();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  //search function
  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('StoreInformation')
        .where('storename', isGreaterThanOrEqualTo: queryString)
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

  checkOut(num docId, String outTime, String storeName, num activeuser,
      String duration, bool isReachedLimit) {
    activeuser = activeuser - 1;
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
        .doc(storeName)
        .update({'activeuser': activeuser});
  }

  //StoreInformation

  storeInformation(String storeemail, String store, String timeLimit) async {
    num activeuser = 0;
    num totaluser = 0;
    try {
      activeuser = activeuser + 1;
      await FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation')
          .doc(storeemail)
          .update({'activeuser': activeuser}).then((value) {
        Get.off(
          () => Home_Screen(
            storeName: store,
            storeEmail: storeemail,
            timeLimit: timeLimit,
            startTimer: true,
            activeuser: 1,
          ),
        );
      });

      totaluser = activeuser;
    } catch (e) {
      Get.snackbar('$e', 'message');
    }
  }

  checkIn(String code, String docId, String inTime, String date,
      String username) async {
    String store = code;
    String riskstatus = '';
    String storeemail = '';
    String timeLimit = '';
    await FirestoreController.instance.firebaseFirestore
        .collection('StoreInformation')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        // print(element['storename']);
        //store = element['storename'];
        storeemail = element['email'];
        riskstatus = element['riskstatus'];
        timeLimit = element['durationHours'].toString() +
            element['durationMinutes'].toString() +
            element['durationSeconds'].toString();
        if (code == element['storename']) {
          //TODO: test qr code and find solution for time limit
          final session = InOut(
              docId: docId,
              email: AuthController.instance.auth.currentUser!.email.toString(),
              inTime: inTime,
              date: date,
              isOut: false,
              duration: '',
              isReachedLimit: false,
              outTime: '',
              storename: store,
              riskstatus: riskstatus,
              username: username);
          FirestoreController.instance.createSession(session).then((value) {
            print('called');
            storeInformation(storeemail, store, timeLimit);
          });
        }
      }
    });
    return store;
  }
}
