import 'package:covia/components/widget.dart';
import 'package:covia/controller/firestore_controller.dart';
import 'package:covia/model/user_model.dart';
import 'package:covia/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Newuser_Screen extends StatefulWidget {
  const Newuser_Screen({Key? key}) : super(key: key);

  @override
  State<Newuser_Screen> createState() => _Newuser_ScreenState();
}

class _Newuser_ScreenState extends State<Newuser_Screen> {
  final controllerFullname = TextEditingController();
  final controllerNickname = TextEditingController();
  final controllerPhonenumber = TextEditingController();
  final controllerNRIC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Welcome To Covia'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
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
                  controller: controllerFullname,
                  read: false,
                  label1: "Enter your full name",
                  label2: ' *',
                  hint: "Enter your full name",
                  inputType: TextInputType.name),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  inputAction: TextInputAction.next,
                  isPassword: false,
                  controller: controllerNickname,
                  read: false,
                  label1: "Enter your nick name",
                  label2: ' *',
                  hint: "Enter your nick name",
                  inputType: TextInputType.name),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  inputAction: TextInputAction.next,
                  isPassword: false,
                  controller: controllerPhonenumber,
                  read: false,
                  label1: "Enter your phone number",
                  label2: ' *',
                  hint: "Enter your phone number",
                  inputType: TextInputType.number),
              InputField(
                  textCapitalization: TextCapitalization.none,
                  inputAction: TextInputAction.next,
                  isPassword: false,
                  controller: controllerNRIC,
                  read: false,
                  label1: "Enter your NRIC/Passport",
                  label2: ' *',
                  hint: "Enter your NRIC/Passport",
                  inputType: TextInputType.number),
              const SizedBox(
                height: 10,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                label: 'Register',
                onPressed: () async {
                  try {
                    final user = User(
                        fullname: controllerFullname.text,
                        nickname: controllerNickname.text,
                        phone: int.parse(controllerPhonenumber.text),
                        NRIC: int.parse(controllerNRIC.text),
                        isVaccine: false);
                    await FirestoreController.instance
                        .createUser(user)
                        .then((value) {
                      Get.off(() => Home_Screen());
                      Get.snackbar(
                        "Successful",
                        "",
                        snackPosition: SnackPosition.TOP,
                        titleText: const Text(
                          "Successful",
                          style: TextStyle(color: Colors.white),
                        ),
                        messageText: Text(
                          'Hi ${controllerNickname.text}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    });
                  } catch (e) {
                    Get.snackbar(
                      "About Registration",
                      "Fail to Save User Data",
                      snackPosition: SnackPosition.TOP,
                      titleText: const Text(
                        "Registration failed",
                        style: TextStyle(color: Colors.white),
                      ),
                      messageText: Text(
                        e.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
