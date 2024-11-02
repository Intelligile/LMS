import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/core/utils/styles.dart';

class CustomContainer extends StatelessWidget {
  final Icon? icon;
  final String? iconPath;
  final String? cardTitle;
  final String? cardText;

  const CustomContainer({
    super.key,
    this.icon,
    this.iconPath,
    this.cardTitle,
    this.cardText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 140,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border(
            top: BorderSide(color: Colors.grey, width: 2),
            right: BorderSide(color: Colors.grey, width: 2),
            bottom: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const ColoredOuterLine(),
            const ColoredInnerLine(),
            Expanded(
              child: insideCardContainer(
                icon: icon,
                iconPath: iconPath,
                cardTitle: cardTitle,
                cardText: cardText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container insideCardContainer({
    Icon? icon,
    String? iconPath,
    String? cardTitle,
    String? cardText,
  }) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Icon(FontAwesomeIcons.ellipsis),
            Row(
              children: [
                icon ??
                    Image.asset(
                      iconPath!,
                      height: 25,
                      width: 25,
                    ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text(
                    cardTitle!,
                    style: Styles.textStyle16
                        .copyWith(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 40, // to align with the icon and space above
                ),
                Flexible(
                  child: Text(
                    cardText!,
                    style: Styles.textStyle16,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColoredInnerLine extends StatelessWidget {
  const ColoredInnerLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 4,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xff23253e),
        ),
      ),
    );
  }
}

class ColoredOuterLine extends StatelessWidget {
  const ColoredOuterLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff5256b8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          topLeft: Radius.circular(4),
        ),
      ),
    );
  }
}
