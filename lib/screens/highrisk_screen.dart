import 'package:flutter/material.dart';

class Highrisk_Screen extends StatefulWidget {
  const Highrisk_Screen({Key? key}) : super(key: key);

  @override
  State<Highrisk_Screen> createState() => _Highrisk_ScreenState();
}

class _Highrisk_ScreenState extends State<Highrisk_Screen> {
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
