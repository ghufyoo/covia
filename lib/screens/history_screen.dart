import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'detailedhistoryscreen.dart';

class History_Screen extends StatefulWidget {
  const History_Screen({Key? key}) : super(key: key);

  @override
  State<History_Screen> createState() => _History_ScreenState();
}

class _History_ScreenState extends State<History_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History'),
      ),
      body: const HistoryStream(),
    );
  }
}

class HistoryStream extends StatelessWidget {
  const HistoryStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreController.instance.firebaseFirestore
            .collection('InOut')
            .where('isOut', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          final data = snapshot.data?.docs;

          List<HistoryUi> history = [];
          for (var dat in data!) {
            final date = dat.get('date');
            final storename = dat.get('storename');
            final checkIn = dat.get('inTime');
            final checkOut = dat.get('outTime');
            final duration = dat.get('duration');
            final riskstatus = dat.get('riskstatus');
            final userfullname = dat.get('userfullname');
            final uservaccinestatus = dat.get('uservaccinestatus');

            final historyBubble = HistoryUi(
                date: date,
                storename: storename,
                checkin: checkIn,
                checkout: checkOut,
                duration: duration,
                riskstatus: riskstatus,
                userfullname: userfullname,
                uservaccinestatus: uservaccinestatus,
                );

            history.add(historyBubble);
          }

          return ListView(
            padding: const EdgeInsets.all(5.0),
            children: history,
          );
        });
  }
}

class HistoryUi extends StatefulWidget {
  const HistoryUi(
      {Key? key,
      required this.date,
      required this.storename,
      required this.checkin,
      required this.checkout,
      required this.duration,
      required this.riskstatus,
      required this.userfullname,
      required this.uservaccinestatus
      })
      : super(key: key);
  final String date;
  final String storename;
  final String checkin;
  final String checkout;
  final String duration;
  final String riskstatus;
  final String userfullname;
  final bool uservaccinestatus;

  @override
  State<HistoryUi> createState() => _HistoryUiState();
}

class _HistoryUiState extends State<HistoryUi> {
  @override
  Widget build(BuildContext context) {
    Color color(String riskstatus) {
      Color col;
      if (riskstatus == 'Normal') {
        col = Colors.green;
        return col;
      } else if (riskstatus == 'Moderate') {
        col = Colors.yellow.shade700;
        return col;
      } else {
        col = Colors.red;
        return col;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
           onTap: (() => Get.to(()=> DetailedHistoryScreen(userfullname: widget.userfullname, uservaccinestatus: widget.uservaccinestatus, checkin: widget.checkin, checkout: widget.checkout, duration: widget.duration))),
          child: Container(
            padding: EdgeInsets.only(top: 10.0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                color: color(widget.riskstatus)),
            child: Column(
              children: [
                Text(
                  widget.storename,
                  style: TextStyle(
                    fontSize: 30,
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(0, 2))
                    ],
                    color: Colors.white,
                    // decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    decorationThickness: 4,
                    //   decorationStyle: TextDecorationStyle.wavy,
                  ),
                ),
                Text(
                  'Check-in: ${widget.checkin}. Check-out: ${widget.checkout}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Duration: ${widget.duration}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Date : ${widget.date}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}
