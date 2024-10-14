import 'package:flutter/material.dart';

class CustomTabBarView extends StatelessWidget {
  const CustomTabBarView({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: const [
        Center(child: Text('Users Content')),
        Center(child: Text('Teams Content')),
        Center(child: Text('Subscription Content')),
        Center(child: Text('Learn Content')),
      ],
    );
  }
}
