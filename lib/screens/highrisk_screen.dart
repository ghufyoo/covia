import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covia/controller/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Highrisk_Screen extends StatefulWidget {
  const Highrisk_Screen({Key? key}) : super(key: key);

  @override
  State<Highrisk_Screen> createState() => _Highrisk_ScreenState();
}

class _Highrisk_ScreenState extends State<Highrisk_Screen> {
  late QuerySnapshot snapshotData;
  bool isExecuted = false;
  final state = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Malacca',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu'
  ];
  String? value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Crowd Checker'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: GetBuilder<FirestoreController>(
                      init: FirestoreController(), // pause here
                      builder: (context) {
                        return DropdownButton<String>(
                          value: value,
                          onChanged: ((value) {
                            this.value = value;
                            print(value);
                            context
                                .dropdownData(value.toString())
                                .then((value) {
                              snapshotData = value;
                              setState(() {
                                isExecuted = true;
                              });
                            });
                          }),
                          items: state.map(buildMenuItem).toList(),
                          hint: Text("Select state"),
                          elevation: 8,
                          isExpanded: true,
                        );
                      }),
                ),
              ),
              isExecuted
                  ? selectedData()
                  : Container(
                      child:
                          const Text('Choose the state that you want to check'),
                    )
            ],
          ),
        ));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );

  Widget selectedData() {
    Color color(num cases) {
      Color col;
      if (cases <= 5) {
        col = Colors.green;
        return col;
      } else if (cases > 5 && cases <= 25) {
        col = Colors.yellow.shade700;
        return col;
      } else {
        col = Colors.red;
        return col;
      }
    }

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Please avoid these areas if possible until further notice 5 high-risk areas in $value as of 1st April 2022',
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: snapshotData.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
            
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  tileColor: color(snapshotData.docs[index]['cases']),
                  title: Text(
                    snapshotData.docs[index]['district'],
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    '${snapshotData.docs[index]['cases']} reported positive cases',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    // Get.to(() => DetailCrowdCheckerScreen(
                    //     storename: snapshotData.docs[index]['storename'].toString(),
                    //     riskstatus: snapshotData.docs[index]['riskstatus'],
                    //     activeuser: snapshotData.docs[index]['activeuser']));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
//nanti pakai
// class HighRiskStream extends StatelessWidget {
//   const HighRiskStream({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: FirestoreController.instance.firebaseFirestore
//             .collection('InOut')
//             .where('isOut', isEqualTo: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 backgroundColor: Colors.lightBlueAccent,
//               ),
//             );
//           }

//           final data = snapshot.data?.docs;

//           List<HighRiskUI> highrisk = [];
//           for (var dat in data!) {
//            final state = dat.get('state');
//            final cases = dat.get('cases');
//             final riskstatus = dat.get('riskstatus');

//             final historyBubble = HighRiskUI(
//                state: state,
//                cases: cases,
//                 riskstatus: riskstatus);

//             highrisk.add(historyBubble);
//           }

//           return ListView(
//             padding: const EdgeInsets.all(5.0),
//             children: highrisk,
//           );
//         });
//   }
// }


// class HighRiskUI extends StatefulWidget {
//   const HighRiskUI({ Key? key, required this.state, required this.cases, required this.riskstatus }) : super(key: key);
//  final String state;
//   final String cases;
//   final String riskstatus;
//   @override
//   State<HighRiskUI> createState() => _HighRiskUIState();
// }

// class _HighRiskUIState extends State<HighRiskUI> {
//   @override
//   Widget build(BuildContext context) {
//     Color color(String riskstatus) {
//       Color col;
//       if (riskstatus == 'Normal') {
//         col = Colors.green;
//         return col;
//       } else if (riskstatus == 'Moderate') {
//         col = Colors.yellow;
//         return col;
//       } else {
//         col = Colors.red;
//         return col;
//       }
//     }

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           'widget.date',
//           style: TextStyle(fontSize: 200),
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height / 8,
//           decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset: Offset(0, 3), // changes position of shadow
//                 ),
//               ],
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(30),
//               ),
//               color: color(widget.riskstatus)),
//           child: Column(
//             children: [
//               Text(
//                 widget.state,
//                 style: TextStyle(
//                   fontSize: 30,
//                   shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
//                   color: Colors.transparent,
//                   decoration: TextDecoration.underline,
//                   decorationColor: Colors.black,
//                   decorationThickness: 4,
//                   decorationStyle: TextDecorationStyle.dashed,
//                 ),
//               ),
//               Text(
//                 '${widget.cases} reported positive cases',
//                 style: TextStyle(fontSize: 20),
//               ),
             
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
