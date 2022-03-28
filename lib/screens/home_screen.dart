import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/components/widget.dart';
import 'package:covia/controller/firestore_controller.dart';

import 'package:covia/screens/crowdchecker_screen.dart';
import 'package:covia/screens/highrisk_screen.dart';
import 'package:covia/screens/history_screen.dart';
import 'package:covia/screens/profile_screen.dart';
import 'package:covia/screens/qrscanner.dart';
import 'package:covia/screens/version_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class Home_Screen extends StatefulWidget {
  Home_Screen({Key? key, this.storeName, this.timeLimit, this.startTimer})
      : super(key: key);
  String? storeName = '';
  String? timeLimit = '';
  bool? startTimer;
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  TimeOfDay day = TimeOfDay.now();
  Duration duration = Duration();
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer(widget.startTimer);
  }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
  }

  void resetTimer() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    print('$hours : $minutes : $seconds');
    setState(() {
      duration = Duration();
      timer?.cancel();
    });
  }

  void startTimer(bool? start) {
    if (start == true) {
      timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.storeName;
      widget.timeLimit;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          child: Text('CovIA'),
          onTap: () {
            print(day.period);
            Get.to(Version_Screen());
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                AuthController.instance.logOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      // body: StreamBuilder<DocumentSnapshot>(
      //     stream: FirestoreController.instance.firebaseFirestore
      //         .collection('UserInformation')
      //         .doc(AuthController.instance.auth.currentUser!.uid)
      //         .snapshots(),
      //     builder: (context, snapshot) {

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirestoreController.instance.readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      day.period == DayPeriod.am
                          ? 'Good Morning ${users['nickname']}'
                          : 'Good Afternoon ${users['nickname']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconBtn(
                          color1: Colors.pink,
                          color2: Colors.pink[100]!,
                          onPressed: () {
                            Get.to(() => Profile_Screen());
                          },
                          icon: Icons.person,
                          label: 'Profile'),
                      IconBtn(
                          color1: Colors.blue,
                          color2: Colors.blue[100]!,
                          onPressed: () {
                            Get.to(() => History_Screen());
                          },
                          icon: Icons.history,
                          label: 'History'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconBtn(
                          color1: Colors.green,
                          color2: Colors.green[100]!,
                          onPressed: () {
                            Get.to(() => Crowdchecker_Screen());
                          },
                          icon: Icons.groups,
                          label: 'Crowd Checker'),
                      IconBtn(
                          color1: Colors.red,
                          color2: Colors.red[100]!,
                          onPressed: () {
                            Get.to(() => Highrisk_Screen());
                          },
                          icon: Icons.priority_high,
                          label: 'High-risk areas'),
                    ],
                  ),
                  if (widget.storeName != null && widget.timeLimit != null) ...[
                    Text('You are now at ${widget.storeName}'),
                    Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(child: buildTime()),
                    ),
                    RoundedButton(
                      label: 'Check-out',
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        resetTimer();
                        setState(() {
                          widget.storeName = null;
                          widget.timeLimit = null;
                        });
                      },
                    )
                  ] else
                    Column(
                      children: [
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(child: Text('Check-In First')),
                        ),
                        RoundedButton(
                          label: 'Check-in',
                          icon: Icons.arrow_forward,
                          onPressed: () {
                            Get.to(Qrscanner_Screen());
                          },
                        )
                      ],
                    )
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$hours:$minutes:$seconds',
      style: TextStyle(fontSize: 25),
    );
  }
}
