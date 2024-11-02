import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final List<Widget>? suffixIcons;
  final double? textFieldSize;
  final String? errorText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters; // Add inputFormatters

  const CustomTextField({
    Key? key,
    this.textFieldSize,
    this.hint,
    this.suffixIcons,
    this.label,
    this.errorText,
    this.controller,
    this.validator,
    this.inputFormatters, // Initialize inputFormatters
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SizedBox(
        width: textFieldSize ?? 400,
        child: TextFormField(
          controller: controller,
          validator: validator,
          inputFormatters: inputFormatters, // Apply inputFormatters here
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
                width: 1.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.0,
              ),
            ),
            labelText: label ?? '',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(),
            hintText: hint ?? '',
          ),
        ),
      ),
    );
  }
}
