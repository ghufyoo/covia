import 'package:flutter/material.dart';

class Crowdchecker_Screen extends StatefulWidget {
  const Crowdchecker_Screen({Key? key}) : super(key: key);

  @override
  State<Crowdchecker_Screen> createState() => _Crowdchecker_ScreenState();
}

class _Crowdchecker_ScreenState extends State<Crowdchecker_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Crowd Checker'),
      ),
    );
  }
}
