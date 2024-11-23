import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/utils/assets.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_card.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_card_container.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_tab_bar.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_tab_bar_view.dart';

class DesktopHomeViewBody extends StatefulWidget {
  final String username; // Add this parameter

  const DesktopHomeViewBody({
    super.key,
    required this.username, // Add this required parameter
  });

  @override
  _DesktopHomeViewBodyState createState() => _DesktopHomeViewBodyState();
}

class _DesktopHomeViewBodyState extends State<DesktopHomeViewBody>
    with SingleTickerProviderStateMixin {
  //bool _drawerOpen = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  // void _toggleDrawer() {
  //   setState(() {
  //     _drawerOpen = !_drawerOpen;
  //   });
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        // Add SingleChildScrollView here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const CustomCard(),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Good morning, ${widget.username}', // Use the username here
              style: Styles.textStyle28,
            ),
            const Text(
              'The Simplified view helps you focus on the most common tasks for the organization like you',
              style: Styles.textStyle16,
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const Text(
                  'For organization like yours',
                  style: Styles.textStyle20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Show more',
                  style: Styles.textStyle20.copyWith(color: kIconColor),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                CustomContainer(
                    iconPath: AssetsData.copilotImage,
                    cardTitle: 'Assign unused licenses',
                    cardText:
                        'You have 1 unused license for Microsoft 365 Business Standard.'),
                SizedBox(
                  width: 50,
                ),
                CustomContainer(
                    icon: Icon(FontAwesomeIcons.chalkboardUser),
                    cardTitle: 'Help people stay productive on the go',
                    cardText:
                        'Share training for the Microsoft 365 app for iOS or Android.'),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Your organization',
              style: Styles.textStyle20,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: CustomTabBar(tabController: _tabController)),
                const Expanded(child: SizedBox()),
              ],
            ),
            AspectRatio(
                aspectRatio: 3,
                child: CustomTabBarView(tabController: _tabController)),
          ],
        ),
      ),
    );
  }
}