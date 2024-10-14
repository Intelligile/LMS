import 'package:flutter/material.dart';
import 'package:lms/core/utils/styles.dart';

class ActionsContainer extends StatelessWidget {
  const ActionsContainer({
    super.key,
    required this.containerIcon,
    required this.containerText,
    required this.containerBgColor,
    required this.txtColor,
    this.onPressed,
  });
  final Icon containerIcon;
  final String containerText;
  final Color containerBgColor;
  final Color txtColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: containerBgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              containerIcon,
              Text(
                containerText,
                style: Styles.textStyle20.copyWith(
                  fontSize: 16,
                  color: txtColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
