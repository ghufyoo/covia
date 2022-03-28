import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/firestore_controller.dart';
import 'package:covia/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Qrscanner_Screen extends StatefulWidget {
  const Qrscanner_Screen({Key? key}) : super(key: key);

  @override
  State<Qrscanner_Screen> createState() => _Qrscanner_ScreenState();
}

DateTime now = DateTime.now();
var formatterTime = DateFormat('kk:mm');
String time = formatterTime.format(now);

class _Qrscanner_ScreenState extends State<Qrscanner_Screen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  String c = '';
  QRViewController? controller;
  void getData() async {
    await for (var snapshot in FirestoreController.instance.firebaseFirestore
        .collection('StoreInformation')
        .snapshots()) {
      for (var document in snapshot.docs) {
        //You'll get printed the email field.
        print(document.id);
        c = document.id;
        print('this from c $c'); //You'll get printed the document ID
      }
    }
  }

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
          title: Text('Qr Scanner'),
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
          padding: EdgeInsets.only(right: 20, bottom: 25),
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
                  return Icon(Icons.flash_on);
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
    setState(() {
      this.controller = controller;
      print(FirestoreController.instance.firebaseFirestore
          .collection('StoreInformation'));
    });
    controller.scannedDataStream.listen((barcode) {
      this.barcode = barcode;
      if (barcode.code == c) {
        FirestoreController.instance.firebaseFirestore
            .collection('InOut')
            .add({'storename': c, 'inTime': time});
        Get.off(() => Home_Screen(
              storeName: c,
              timeLimit: '1 hour',
              startTimer: true,
            ));
      }
      getData();
    });
  }
}
