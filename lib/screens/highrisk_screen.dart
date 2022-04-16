import 'package:flutter/material.dart';

class Highrisk_Screen extends StatefulWidget {
  const Highrisk_Screen({Key? key}) : super(key: key);

  @override
  State<Highrisk_Screen> createState() => _Highrisk_ScreenState();
}

class _Highrisk_ScreenState extends State<Highrisk_Screen> {
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
                  child: DropdownButton<String>(
                    value: value,
                    onChanged: ((value) => setState(() {
                          this.value = value;
                          print(value);
                        })),
                    items: state.map(buildMenuItem).toList(),
                    hint: Text("Select state"),
                    elevation: 8,
                    isExpanded: true,
                  ),
                ),
              ),
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
