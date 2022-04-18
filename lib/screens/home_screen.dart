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
import 'package:intl/intl.dart';

import '../controller/auth_controller.dart';

class Home_Screen extends StatefulWidget {
  Home_Screen(
      {Key? key,
      this.storeName,
      this.storeEmail,
      this.docId,
      this.timeLimitHours,
      this.timeLimitMinutes,
      this.timeLimitSeconds,
      this.startTimer,
      this.activeuser})
      : super(key: key);
  String? storeName = '';
  String? storeEmail = '';
  String? docId = '1';
  num? timeLimitHours = 0;
  num? timeLimitMinutes = 0;
  num? timeLimitSeconds = 0;

  bool? startTimer;
  num? activeuser;
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

num docId = 1;
bool isReachLimit = false;

class _Home_ScreenState extends State<Home_Screen> {
  TimeOfDay day = TimeOfDay.now();
  Duration duration = const Duration();
  Timer? timer;
  bool isExceeded = false;
  bool limit = false;
  void isLimit() async {
    var data = await FirebaseFirestore.instance
        .collection("InOut")
        .doc(widget.docId)
        .update({'isReachedLimit': true});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer(widget.startTimer);
    //isLimit();

    //fetchData();
    // if (isReachLimit) {
    //   SchedulerBinding.instance?.addPostFrameCallback((_) {
    //     Get.defaultDialog(title: 'yy');
    //   });
    // }
  }

  void addTime() {
    const addSeconds = 1;

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
      duration = const Duration();
      timer?.cancel();
    });
  }

  void startTimer(bool? start) {
    if (start == true) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String durationHours(String hours, String minutes, String seconds) {
    if (hours == '00' && minutes == '00') {
      return '$seconds seconds';
    } else if (hours == '00') {
      return '$minutes minutes $seconds seconds';
    } else {
      return '$hours hour and $minutes minutes $seconds seconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //isLimit();
    });
    // if (limit) {
    //   print('object');
    // }
    String username = '';
    bool uservaccinestatus = false;
    DateTime now = DateTime.now();
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    String outTime = DateFormat.Hm().format(now);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          child: const Text('CovIA'),
          onTap: () {
            print(day.period);
            Get.to(const VersionScreen());
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                AuthController.instance.logOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirestoreController.instance.readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something Went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            username = users['fullname'];
            uservaccinestatus = users['isVaccine'];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Text(
                      day.period == DayPeriod.am
                          ? 'Good Morning ${users['nickname']}'
                          : 'Good Afternoon ${users['nickname']}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                            Get.to(() => const Profile_Screen());
                          },
                          icon: Icons.person,
                          label: 'Profile'),
                      IconBtn(
                          color1: Colors.blue,
                          color2: Colors.blue[100]!,
                          onPressed: () {
                            Get.to(() => const History_Screen());
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
                            Get.to(() => const Crowdchecker_Screen());
                          },
                          icon: Icons.groups,
                          label: 'Crowd Checker'),
                      IconBtn(
                          color1: Colors.red,
                          color2: Colors.red[100]!,
                          onPressed: () {
                            Get.to(() => const Highrisk_Screen());
                          },
                          icon: Icons.priority_high,
                          label: 'High-risk areas'),
                    ],
                  ),
                  if (widget.storeName != null) ...[
                    Text('You are now at ${widget.storeName}'),
                    Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(child: buildTime()),
                    ),
                    RoundedButton(
                      color: Colors.red,
                      label: 'Check-out',
                      icon: Icons.arrow_back,
                      onPressed: () async {
                        await FirestoreController.instance.checkOut(
                            docId,
                            outTime,
                            widget.storeEmail.toString(),
                            widget.activeuser as num,
                            durationHours(hours, minutes, seconds),
                            isReachLimit);
                        // await FirestoreController.instance.firebaseFirestore
                        //     .collection('InOut')
                        //     .doc(docId.toString())
                        //     .update({'outTime': day.hour, 'isOut': true});

                        resetTimer();

                        widget.storeName = null;
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Center(child: Text('Check-In First')),
                        ),
                        RoundedButton(
                          color: Colors.blue,
                          label: 'Check-in',
                          icon: Icons.arrow_forward,
                          onPressed: () async {
                            await FirestoreController.instance.firebaseFirestore
                                .collection('InOut')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var element in querySnapshot.docs) {
                                print(element['docId']);
                                while (docId <= int.parse(element['docId'])) {
                                  docId = docId + 1;
                                  print(docId);
                                }
                              }
                            });
                            // fetchData();
                            Get.to(QrscannerScreen(
                              docId: docId,
                              username: username,
                              uservaccinestatus: uservaccinestatus,
                            ));
                          },
                        )
                      ],
                    )
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
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
    if ((duration.inHours >= widget.timeLimitHours!.toInt()) &&
        (duration.inMinutes >= widget.timeLimitMinutes!.toInt()) &&
        (duration.inSeconds >= widget.timeLimitSeconds!.toInt())) {
      isLimit();
      return Text(
        '$hours:$minutes:$seconds',
        style: const TextStyle(fontSize: 25, color: Colors.red),
      );
    } else {
      return Text(
        '$hours:$minutes:$seconds',
        style: const TextStyle(fontSize: 25),
      );
    }
  }

  // Widget _showMyDialog() {
  //   if (duration.inMinutes > 0.5) {
  //     return AlertDialog(
  //       title: const Text('AlertDialog Title'),
  //       content: SingleChildScrollView(
  //         child: ListBody(
  //           children: const <Widget>[
  //             Text('This is a demo alert dialog.'),
  //             Text('Would you like to approve of this message?'),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('Approve'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  // void _showMyDialog(bool isReachLimit) async {
  //   if (!isReachLimit) {
  //     print('hey');
  //   } else {
  //     return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (BuildContext context) {
  //         isReachLimit = false;

  //         return AlertDialog(
  //           title: const Text('AlertDialog Title'),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: const <Widget>[
  //                 Text('This is a demo alert dialog.'),
  //                 Text('Would you like to approve of this message?'),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Approve'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
}
