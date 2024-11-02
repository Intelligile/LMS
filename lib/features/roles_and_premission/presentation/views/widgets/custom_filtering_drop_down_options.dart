import 'package:flutter/material.dart';

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton(
      {super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: value,
          onChanged: (newValue) {},
          items: <String>['All', 'Option 1', 'Option 2']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
