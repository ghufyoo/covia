import 'package:flutter/material.dart';

class IconBtn extends StatelessWidget {
  const IconBtn({
    Key? key,
    required this.color1,
    required this.color2,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);
  final Color color1;
  final Color color2;
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  color1,
                  color2,
                ],
              ),
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                size: 80,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  RoundedButton({
    Key? key,
    required this.label,
    this.icon,
    this.color,
    required this.onPressed,
  }) : super(key: key);
  final String label;
  IconData? icon;
  final VoidCallback onPressed;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
            elevation: 5.0,
            color: color,
            borderRadius: BorderRadius.circular(30.0),
            child: SizedBox(
              width: 200,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Icon(
                    icon,
                    color: Colors.white,
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  InputField(
      {Key? key,
      this.inputAction,
      required this.label1,
      required this.label2,
      required this.hint,
      required this.inputType,
      required this.read,
      required this.controller,
      required this.isPassword,
      required this.textCapitalization})
      : super(key: key);
  final String label1;
  final String label2;
  final String hint;
  final TextInputType inputType;
  final bool read;
  final TextEditingController controller;
  final bool isPassword;
  final TextCapitalization textCapitalization;
  TextInputAction? inputAction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        textCapitalization: textCapitalization,
        textInputAction: inputAction,
        onChanged: (value) {},
        obscureText: isPassword,
        controller: controller,
        readOnly: read,
        maxLines: 1,
        keyboardType: inputType,
        decoration: InputDecoration(
            label: RichText(
              text: TextSpan(
                  text: label1,
                  style: const TextStyle(color: Colors.grey, fontSize: 20),
                  children: [
                    TextSpan(
                        text: label2,
                        style: const TextStyle(
                          color: Colors.red,
                        ))
                  ]),
            ),
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
      ),
    );
  }
}
