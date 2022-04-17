import 'package:flutter/material.dart';

import '../components/widget.dart';

class DetailedHistoryScreen extends StatelessWidget {
  const DetailedHistoryScreen(
      {Key? key,
      required this.userfullname,
      required this.uservaccinestatus,
      required this.checkin,
      required this.checkout,
      required this.duration})
      : super(key: key);
  final String userfullname;
  final bool uservaccinestatus;
  final String checkin;
  final String checkout;
  final String duration;
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController(text: "$userfullname");
    var vaccinestatusController = TextEditingController(text: "${uservaccinestatus == false ? 'Unvaccinated' : 'Fully Vaccinated'}");
    var checkinoutdurationController =
        TextEditingController(text: "$checkin, $checkout, $duration");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User Profile'),
      ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              size: 70,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InputField(
              textCapitalization: TextCapitalization.characters,
              inputAction: TextInputAction.next,
              isPassword: false,
              controller: nameController,
              read: true,
              label1: "Name",
              label2: ' ',
              hint: "",
              inputType: TextInputType.name),
          SizedBox(
            height: 10,
          ),
          InputField(
              textCapitalization: TextCapitalization.characters,
              inputAction: TextInputAction.next,
              isPassword: false,
              controller: vaccinestatusController,
              read: true,
              label1: "Vaccination Status",
              label2: ' ',
              hint: "",
              inputType: TextInputType.name),
          SizedBox(
            height: 10,
          ),
          InputField(
              textCapitalization: TextCapitalization.characters,
              inputAction: TextInputAction.next,
              isPassword: false,
              controller: checkinoutdurationController,
              read: true,
              label1: "Check-in/out time & Duration",
              label2: ' ',
              hint: "",
              inputType: TextInputType.name),
        ],
      )),
    );
  }
}
