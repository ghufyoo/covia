import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/auth_controller.dart';
import 'package:covia/model/inout_model.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';
import '../screens/home_screen.dart';

class FirestoreController extends GetxController {
  static FirestoreController instance = Get.find();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

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

  storeInformation(String store) async {
    num activeuser = 0;
    num totaluser = 0;
    await FirestoreController.instance.firebaseFirestore
        .collection('StoreInformation')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        print(element['activeuser']);
        while (activeuser <= element['activeuser']) {
          activeuser = activeuser + 1;
          print(activeuser);
        }
      }
      firebaseFirestore
          .collection('StoreInformation')
          .doc(store)
          .update({'activeuser': activeuser});

      Get.off(() => Home_Screen(
            storeName: store,
            timeLimit: '1 hour',
            startTimer: true,
            activeuser: 1,
          ));
      // for (var element in querySnapshot.docs) {
      //   activeuser = element['activeuser'];
      //   activeuser++;
      //   if (activeuser > element['activeuser']) {

      //   }
      // }
    });
    totaluser = activeuser;
  }

  checkIn(String code, String docId, String inTime) async {
    String store = '';
    await FirestoreController.instance.firebaseFirestore
        .collection('StoreInformation')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        print(element['storename']);
        store = element['storename'];
      }
      if (code == store) {
        // Get.defaultDialog(title: 'yyy');
        final session = InOut(
            docId: docId,
            email: AuthController.instance.auth.currentUser!.email.toString(),
            inTime: '',
            isOut: false,
            duration: '',
            isReachedLimit: false,
            outTime: '',
            storename: store);
        FirestoreController.instance.createSession(session).then((value) {
          print('calleddd');
          storeInformation(store);
        });
      }
    });
    return store;
  }
}
