import 'package:flutter/material.dart';

class DetailCrowdCheckerScreen extends StatelessWidget {
  const DetailCrowdCheckerScreen(
      {Key? key,
      required this.storename,
      required this.riskstatus,
      required this.activeuser})
      : super(key: key);
  final String storename;
  final String riskstatus;
  final num activeuser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crowd Checker'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(storename),
              Text('Risk status: $riskstatus'),
              const Text('Real-time amount of people'),
              Text(activeuser.toString())
            ],
          ),
        ),
      ),
    );
  }
}
