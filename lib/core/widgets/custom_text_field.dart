import 'package:flutter/material.dart';
import 'package:lms/core/utils/styles.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      this.textFieldSize,
      this.hint,
      this.suffixIcons,
      this.label,
      this.errorText});
  String? label;
  String? hint;
  List<Widget>? suffixIcons;
  double? textFieldSize;
  final String? errorText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        width: textFieldSize ?? 400,
        child: TextField(
          decoration: InputDecoration(
              errorText: errorText,
              suffixIcon: suffixIcons != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: suffixIcons!,
                    )
                  : null,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              labelText: label ?? '',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(color: Colors.black),
              hintText: hint ?? '',
              hintStyle: Styles.textStyle16),
        ),
      ),
    );
  }
}
