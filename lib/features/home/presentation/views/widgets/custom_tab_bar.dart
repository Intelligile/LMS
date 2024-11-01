import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/utils/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return TabBar(
      controller: _tabController,
      // labelColor: Colors.black,
      indicatorColor: kPrimaryColor,
      labelColor: themeProvider.themeMode == ThemeMode.light
          ? Colors.black
          : Colors.white,
      dividerColor: Colors.transparent,
      tabs: const [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.user),
              SizedBox(
                width: 10,
              ),
              Text('Users'),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: [
              Icon(FontAwesomeIcons.peopleGroup),
              SizedBox(
                width: 10,
              ),
              Text('Teams'),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: [
              Icon(FontAwesomeIcons.creditCard),
              SizedBox(
                width: 5,
              ),
              Text('Subscription'),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: [
              Icon(FontAwesomeIcons.bookOpen),
              SizedBox(
                width: 10,
              ),
              Text('Learn'),
            ],
          ),
        ),
      ],
    );
  }
}
