import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/functions/get_responsive_font_size.dart';
import 'package:lms/core/utils/app_router.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Expanded(
            flex: 1,
            child: DropdownButton(
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, baseFontSize: 16),
              ),
              underline: const Text(''),
              focusColor: Colors.transparent,
              isExpanded: true,
              hint: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlexibleIcon(
                    icon: FontAwesomeIcons.binoculars,
                  ),
                  FittedBox(
                      fit: BoxFit.scaleDown, child: Text('Simplified view')),
                ],
              ),
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
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    GoRouter.of(context).go(AppRouter.kAddUsers);
                  },
                  child: Row(
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(
                          Icons.person_add_alt,
                          color: kIconColor,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '  Add a user',
                          style: TextStyle(
                              fontSize: getResponsiveFontSize(context,
                                  baseFontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    GoRouter.of(context).go(AppRouter.kAddGroup);
                  },
                  child: Row(
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(
                          Icons.person_add_alt,
                          color: kIconColor,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '  Add a group',
                          style: TextStyle(
                              fontSize: getResponsiveFontSize(context,
                                  baseFontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    // Add action for viewing the bill
                  },
                  child: Row(
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(
                          Icons.shopping_bag,
                          color: kIconColor,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Purchase Product',
                          style: TextStyle(
                              fontSize: getResponsiveFontSize(context,
                                  baseFontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    // Add action for viewing the bill
                  },
                  child: Row(
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(
                          Icons.monetization_on_outlined,
                          color: kIconColor,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '  Add Billing Account',
                          style: TextStyle(
                              fontSize: getResponsiveFontSize(context,
                                  baseFontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //const SizedBox(width: 15),
          //const Icon(FontAwesomeIcons.ellipsis),
          //const Spacer(),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Intelligle',
                style: TextStyle(
                    fontSize: getResponsiveFontSize(context, baseFontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlexibleIcon extends StatelessWidget {
  const FlexibleIcon({super.key, required this.icon, this.iconColor});
  final IconData icon;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Icon(
          icon,
          color: kIconColor,
        ),
      ),
    );
  }
}
