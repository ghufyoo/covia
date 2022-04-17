import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/firestore_controller.dart';
import 'package:covia/screens/detailedcrowdchecker_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Crowdchecker_Screen extends StatefulWidget {
  const Crowdchecker_Screen({Key? key}) : super(key: key);

  @override
  State<Crowdchecker_Screen> createState() => _Crowdchecker_ScreenState();
}

class _Crowdchecker_ScreenState extends State<Crowdchecker_Screen> {
  var searchController = TextEditingController();
  late QuerySnapshot snapshotData;
  bool isExecuted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crowd Checker'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 100,
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            hintText: 'Search Courses',
                            hintStyle: TextStyle(color: Colors.black)),
                        controller: searchController,
                      ),
                    ),
                    GetBuilder<FirestoreController>(
                        init: FirestoreController(),
                        builder: (val) {
                          return IconButton(
                              onPressed: () {
                                val
                                    .queryData(searchController.text)
                                    .then((value) {
                                  snapshotData = value;
                                  setState(() {
                                    isExecuted = true;
                                  });
                                });
                              },
                              icon: const Icon(Icons.search));
                        })
                  ],
                ),
              ),
              isExecuted
                  ? searchedData()
                  : Container(
                      child: const Text('Please enter the place name'),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget searchedData() {
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

    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              tileColor: color(snapshotData.docs[index]['riskstatus']),
              title: Text(
                snapshotData.docs[index]['storename'],
                textAlign: TextAlign.center,
              ),
              onTap: () {
                Get.to(() => DetailCrowdCheckerScreen(
                    storename: snapshotData.docs[index]['storename'].toString(),
                    riskstatus: snapshotData.docs[index]['riskstatus'],
                    activeuser: snapshotData.docs[index]['activeuser']));
              },
            ),
          );
        },
      ),
    );
  }
}
