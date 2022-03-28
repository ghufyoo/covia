import 'package:covia/components/widget.dart';
import 'package:flutter/material.dart';

class Mysejahtera_Screen extends StatelessWidget {
  Mysejahtera_Screen({Key? key}) : super(key: key);
  var nullController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            Container(
              width: 200,
              height: 200,
              child: Image.asset('assets/MySejahtera_logo.png'),
            ),
            SizedBox(
              height: 5,
            ),
            InputField(
                textCapitalization: TextCapitalization.none,
                label1: 'NRIC/Passport',
                label2: '',
                hint: 'NRIC/PASSPORT',
                inputType: TextInputType.none,
                read: false,
                controller: nullController,
                isPassword: false),
            SizedBox(
              height: 15,
            ),
            Text('Please enter your NRIC/Passport associated with MySejahtera'),
            SizedBox(
              height: 15,
            ),
            IconBtn(
                color1: Colors.blue,
                color2: Colors.blue,
                onPressed: () {},
                icon: Icons.arrow_forward,
                label: '')
          ],
        ),
      ),
    );
  }
}
