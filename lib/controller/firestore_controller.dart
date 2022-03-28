import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/auth_controller.dart';
import 'package:get/get.dart';

import '../model/user_model.dart';

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

  Stream<DocumentSnapshot> readUser() => firebaseFirestore
      .collection('UserInformation')
      .doc(AuthController.instance.auth.currentUser?.uid)
      .snapshots();
}
