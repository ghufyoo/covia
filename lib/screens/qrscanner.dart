import 'dart:io';
import 'package:covia/controller/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrscannerScreen extends StatefulWidget {
  const QrscannerScreen({Key? key, required this.docId}) : super(key: key);
  final num docId;
  @override
  State<QrscannerScreen> createState() => _QrscannerScreenState();
}

//var formatterTime = DateFormat('kk:mm');
//String time = formatterTime.format(now);

class _QrscannerScreenState extends State<QrscannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  String c = '';
  num activeuser = 0;
  QRViewController? controller;
  int time = DateTime.now().millisecondsSinceEpoch;
  DateTime now = DateTime.now();

  // void getData() async {
  //   await for (var snapshot in FirestoreController.instance.firebaseFirestore
  //       .collection('StoreInformation')
  //       .snapshots()) {
  //     for (var document in snapshot.docs) {
  //       //You'll get printed the email field.
  //       print(document.id);
  //       activeuser = document['activeuser'];
  //       c = document.id;
  //       print('this from c $c'); //You'll get printed the document ID
  //     }
  //   }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Qr Scanner'),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
            Positioned(top: 10, child: buildResult()),
            Positioned(bottom: 10, child: buildFlash())
          ],
        ),
      ),
    );
  }

  Widget buildFlash() => Center(
        child: Container(
          padding: const EdgeInsets.only(right: 20, bottom: 25),
          child: IconButton(
            icon: FutureBuilder<bool?>(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Icon(
                    snapshot.data! ? Icons.flash_on : Icons.flash_off,
                    size: 70,
                    color: Colors.yellow,
                  );
                } else {
                  return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
          ),
        ),
      );

  Widget buildResult() =>
      Text(barcode != null ? 'Result : ${barcode!.code}' : 'Scan a code');

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderWidth: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.8),
      );
  void onQRViewCreated(QRViewController controller) async {
    String formattedTime = DateFormat.Hm().format(now);

    setState(() {
      this.controller = controller;
      print(FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation'));
    });
    controller.scannedDataStream.listen((barcode) async {
      this.barcode = barcode;
      FirestoreController.instance.checkIn(
          barcode.code.toString(), widget.docId.toString(), formattedTime);

      // if (barcode.code == c) {
      //   final session = InOut(
      //       docId: widget.docId.toString(),
      //       email: AuthController.instance.auth.currentUser!.email.toString(),
      //       inTime: formattedTime,
      //       isOut: false,
      //       duration: '',
      //       isReachedLimit: false,
      //       outTime: '',
      //       storename: c);
      //   FirestoreController.instance.createSession(session).then((value) {
      //     activeuser = activeuser + 1;
      //     FirestoreController.instance.firebaseFirestore
      //         .collection('StoreInformation')
      //         .doc(c)
      //         .update({'activeuser': activeuser});
      //     Get.off(() => Home_Screen(
      //           storeName: c,
      //           timeLimit: '1 hour',
      //           startTimer: true,
      //           activeuser: activeuser,
      //         ));
      //   });
      //   // FirestoreController.instance.firebaseFirestore
      //   //     .collection('InOut')
      //   //     .add({'storename': c, 'inTime': now.hour + now.minute});

      // }
      // getData();
    });
  }
}
