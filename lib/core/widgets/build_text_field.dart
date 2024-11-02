import 'package:flutter/material.dart';

Widget buildAuthTextField({
  required TextEditingController controller,
  required String label,
  bool obscureText = false,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    obscureText: obscureText,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $label.toLowerCase()';
      }
      return null;
    },
  );
}
