import 'package:flutter/material.dart';

class Version_Screen extends StatelessWidget {
  const Version_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CovIA'),
      ),
      body: Center(
          child: Column(
        children: [
          Text(
            'About',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'CovIA',
            style: TextStyle(fontSize: 55),
          ),
          Text(
            'COVID-19 Intelligent App',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 55,
          ),
          Text(
            'Version 1.0',
            style: TextStyle(fontSize: 20),
          ),
        ],
      )),
    );
  }
}
