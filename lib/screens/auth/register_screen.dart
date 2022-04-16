import 'package:covia/components/widget.dart';
import 'package:covia/controller/auth_controller.dart';
import 'package:covia/screens/auth/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Registration_Screen extends StatefulWidget {
  const Registration_Screen({Key? key}) : super(key: key);

  @override
  State<Registration_Screen> createState() => _Registration_ScreenState();
}

class _Registration_ScreenState extends State<Registration_Screen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CovIA',
                      style: TextStyle(color: Colors.white, fontSize: 70),
                    ),
                    Text(
                      'COVID-19 Intelligent App',
                      style: TextStyle(color: Colors.white30, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  'Registration Page',
                  style: TextStyle(color: Colors.black, fontSize: 50),
                ),
              ),
              InputField(
                textCapitalization: TextCapitalization.none,
                inputAction: TextInputAction.next,
                isPassword: false,
                controller: emailController,
                label1: 'Email',
                label2: '',
                hint: 'Enter Your Email',
                inputType: TextInputType.emailAddress,
                read: false,
              ),
              SizedBox(
                height: 5,
              ),
              InputField(
                textCapitalization: TextCapitalization.none,
                inputAction: TextInputAction.done,
                isPassword: true,
                controller: passwordController,
                label1: 'Password',
                label2: '',
                hint: 'Enter Your Password',
                inputType: TextInputType.visiblePassword,
                read: false,
              ),
              SizedBox(
                height: 5,
              ),
              NoIconButton(
                  label: 'Register',
                  onPressed: () {
                    AuthController.instance.register(
                        emailController.text.trim(),
                        passwordController.text.trim());
                  }),
              RichText(
                text: TextSpan(
                    text: 'Have an account?',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Login Now',
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 18),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(Login_Screen());
                            }),
                    ]),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
