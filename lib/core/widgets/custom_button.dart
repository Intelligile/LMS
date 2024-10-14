import 'package:flutter/material.dart';
import 'package:lms/constants.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({Key? key, this.color, required this.buttonName, this.onTap})
      : super(key: key);
  String buttonName;
  VoidCallback? onTap;
  Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: color ?? kIconColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            buttonName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
