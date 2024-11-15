import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/utils/assets.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_card.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_card_container.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_tab_bar.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_tab_bar_view.dart';

class MobileHomeViewBody extends StatefulWidget {
  final String username; // Add this parameter

  const MobileHomeViewBody({
    super.key,
    required this.username, // Add this required parameter
  });

  @override
  _MobileHomeViewBodyState createState() => _MobileHomeViewBodyState();
}

class _MobileHomeViewBodyState extends State<MobileHomeViewBody>
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const MobileCustomCard(),
            const SizedBox(height: 50),
            Text(
              'Good morning, ${widget.username}',
              style: Styles.textStyle28,
            ),
            const Text(
              'The Simplified view helps you focus on the most common tasks for the organization like you',
              style: Styles.textStyle16,
            ),
            const SizedBox(height: 50),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  const Text(
                    'For organization like yours',
                    style: Styles.textStyle20,
                  ),
                  Text(
                    ' Show more',
                    style: Styles.textStyle20.copyWith(color: kIconColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const AspectRatio(
              aspectRatio: 4,
              child: CustomMobileContainer(
                iconPath: AssetsData.copilotImage,
                cardTitle: 'Assign unused licenses',
                cardText:
                    'You have 1 unused license for Microsoft 365 Business Standard.',
              ),
            ),
            const SizedBox(height: 20),
            const AspectRatio(
              aspectRatio: 4,
              child: CustomMobileContainer(
                icon: Icon(FontAwesomeIcons.chalkboardUser),
                cardTitle: 'Help people stay productive on the go',
                cardText:
                    'Share training for the Microsoft 365 app for iOS or Android.',
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Your organization',
              style: Styles.textStyle20,
            ),
            const SizedBox(height: 20),
            CustomTabBar(tabController: _tabController),
            AspectRatio(
              aspectRatio: 2,
              child: CustomTabBarView(tabController: _tabController),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileCustomCard extends StatelessWidget {
  const MobileCustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width to make responsive adjustments
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const FlexibleIcon(icon: FontAwesomeIcons.binoculars),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      hint: const Text('Simplified view'),
                      items: const [
                        DropdownMenuItem(value: 'item1', child: Text('item1')),
                        DropdownMenuItem(value: 'item2', child: Text('item2')),
                        DropdownMenuItem(value: 'item3', child: Text('item3')),
                      ],
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            LayoutBuilder(
              builder: (context, constraints) {
                // Check screen width to adapt layout
                bool isSmallScreen = screenWidth < 400;

                return isSmallScreen
                    ? Column(
                        children: _buildResponsiveButtons(context),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _buildResponsiveButtons(context),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create the buttons
  List<Widget> _buildResponsiveButtons(BuildContext context) {
    return [
      _buildActionButton(
        context,
        Icons.person_add_alt,
        'Add a user',
        () => GoRouter.of(context).go(AppRouter.kAddUsers),
      ),
      _buildActionButton(
        context,
        Icons.group_add,
        'Add a group',
        () => GoRouter.of(context).go(AppRouter.kAddGroup),
      ),
      _buildActionButton(
        context,
        FontAwesomeIcons.creditCard,
        'View your bill',
        () {},
      ),
    ];
  }

  // Button builder method with responsive padding and font size
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenWidth < 400 ? 20 : 24;
    double fontSize = screenWidth < 400 ? 12 : 14;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            size: iconSize,
            color: kIconColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
