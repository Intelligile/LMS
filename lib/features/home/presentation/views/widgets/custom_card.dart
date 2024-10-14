import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/utils/styles.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              height: 60, // Maintain fixed height
              width: MediaQuery.of(context).size.width / 1.2,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 200, // Decreased width for the ExpansionTile
                      child: DropdownButton(
                        style: Styles.textStyle16,
                        underline: const Text(''),
                        focusColor: Colors.transparent,
                        hint: const Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.binoculars,
                              color: kIconColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Simplified view'),
                          ],
                        ),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'item1',
                            child: Text('item1'),
                          ),
                          DropdownMenuItem(
                            value: 'item2',
                            child: Text('item2'),
                          ),
                          DropdownMenuItem(
                            value: 'item3',
                            child: Text('item3'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    const VerticalDivider(
                      width: 10,
                      thickness: 1,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.person_add_alt,
                      color: kIconColor,
                    ),
                    const Text(
                      '  Add a user',
                      style: Styles.textStyle16,
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      FontAwesomeIcons.key,
                      size: 20,
                      color: kIconColor,
                    ),
                    const Text(
                      '  Reset password',
                      style: Styles.textStyle16,
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.person_add_alt,
                      color: kIconColor,
                    ),
                    const Text(
                      '  Add a group',
                      style: Styles.textStyle16,
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      FontAwesomeIcons.creditCard,
                      color: kIconColor,
                    ),
                    const Text(
                      '  View your bill',
                      style: Styles.textStyle16,
                    ),
                    const SizedBox(width: 15),
                    const Icon(FontAwesomeIcons.ellipsis),
                    const Spacer(),
                    Text(
                      'Intelligle',
                      style: Styles.textStyle16
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
