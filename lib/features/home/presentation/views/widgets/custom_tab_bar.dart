import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 570,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        indicatorColor: const Color.fromARGB(255, 4, 128, 163),
        unselectedLabelColor: Colors.grey,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            child: Row(
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
      ),
    );
  }
}
