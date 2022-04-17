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
    Color color(String riskstatus) {
      Color col;
      if (riskstatus == 'Low Risk') {
        col = Colors.green;
        return col;
      } else if (riskstatus == 'Medium Risk') {
        col = Colors.yellow.shade700;
        return col;
      } else {
        col = Colors.red;
        return col;
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crowd Checker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: color(riskstatus),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                  child: Text(
                    storename,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                  child: Text(
                    'Risk status: ${riskstatus}',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: const Text(
                    'Real-time amount of people',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  activeuser.toString(),
                  style: TextStyle(fontSize: 60),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
