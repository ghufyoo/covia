import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/components/widget.dart';
import 'package:covia/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';

var t = TextEditingController(text: 'yo');

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ProfileStream(),
          // child: Center(
          //   child: Column(
          //     children: [
          //
          //
          //
          //       InputField(
          //           textCapitalization: TextCapitalization.none,
          //           isPassword: false,
          //           controller: nullController,
          //           read: true,
          //           label1: 'Vaccination Status',
          //           label2: ' ',
          //           hint: 'Vaccination Status',
          //           inputType: TextInputType.phone),
          //       RichText(
          //         text: TextSpan(
          //             text: 'Only details with ',
          //             style: const TextStyle(color: Colors.grey, fontSize: 20),
          //             children: [
          //               TextSpan(
          //                   text: '*',
          //                   style: TextStyle(
          //                     color: Colors.red,
          //                   )),
          //               TextSpan(text: ' can be modified')
          //             ]),
          //       ),
          //       SizedBox(
          //         height: 10,
          //       ),

          //       RoundedButton(
          //         label: 'Save',
          //         icon: Icons.save,
          //         onPressed: () {},
          //       )
          //     ],
          //   ),

          // ),
        );
      }),
    );
  }
}

var name = TextEditingController();
var phoneNumber = TextEditingController();

class ProfileStream extends StatelessWidget {
  const ProfileStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirestoreController.instance.readUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final data = snapshot.data;

        var NRIC = TextEditingController(text: "${data?["NRIC"]}");
        var VaccineStatus =
            TextEditingController(text: "${data?["isVaccine"]}");

        return Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.grey[900],
                ),
              ),
              InputField(
                  textCapitalization: TextCapitalization.characters,
                  inputAction: TextInputAction.next,
                  isPassword: false,
                  controller: name,
                  read: false,
                  label1: "${data?["fullname"]}",
                  label2: ' *',
                  hint: "Enter New Name",
                  inputType: TextInputType.name),
              const SizedBox(
                height: 20,
              ),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  isPassword: false,
                  controller: NRIC,
                  read: true,
                  label1: 'NRIC/Passport',
                  label2: '',
                  hint: 'NRIC/Passport',
                  inputType: TextInputType.number),
              const SizedBox(
                height: 5,
              ),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  isPassword: false,
                  controller: phoneNumber,
                  read: false,
                  label1: "${data?["phonenumber"]}",
                  label2: ' *',
                  hint: 'Enter Your New Phone Number',
                  inputType: TextInputType.phone),
              const SizedBox(
                height: 5,
              ),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  isPassword: false,
                  controller: VaccineStatus,
                  read: true,
                  label1: 'Vaccination Status',
                  label2: ' ',
                  hint: 'Vaccination Status',
                  inputType: TextInputType.phone),
              RichText(
                text: const TextSpan(
                    text: 'Only details with ',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                    children: [
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                          )),
                      TextSpan(text: ' can be modified')
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              RoundedButton(
                label: 'Save',
                icon: Icons.save,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('UserInformation')
                      .doc(AuthController.instance.auth.currentUser!.uid)
                      .update({
                    'name': name.text.trim(),
                    'phoneNumber': phoneNumber.text.trim()
                  });
                },
              )
            ],
          ),
        );
      },
    );
  }
}
