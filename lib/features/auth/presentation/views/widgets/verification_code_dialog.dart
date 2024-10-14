import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationCodeDialog extends StatefulWidget {
  final void Function(String code)? onSubmit;

  const VerificationCodeDialog({Key? key, this.onSubmit}) : super(key: key);

  @override
  _VerificationCodeDialogState createState() => _VerificationCodeDialogState();
}

class _VerificationCodeDialogState extends State<VerificationCodeDialog> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  String verificationCode = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Verification Code"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                width: 40,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: TextField(
                  controller: _controllers[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    counterText: '', // Hide the counter below the field
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.length == 1 && index < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                    if (index == 5) {
                      verificationCode = _controllers.map((c) => c.text).join();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (verificationCode.length == 6) {
                widget.onSubmit?.call(verificationCode);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter the full 6-digit code.')),
                );
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
