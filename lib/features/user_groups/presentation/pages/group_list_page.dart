import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_groups/presentation/widgets/group_card.dart';

class GroupListPage extends StatelessWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: AdaptiveLayout(
        mobileLayout: (context) => const SizedBox(),
        tabletLayout: (context) => const SizedBox(),
        desktopLayout: (context) => GroupListPageBody(),
      ),
      floatingActionButton: const CustomAddFloatingActionButton(),
    );
  }
}

class CustomAddFloatingActionButton extends StatelessWidget {
  const CustomAddFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigate to the Add Group page when the FAB is pressed
        GoRouter.of(context).go(AppRouter.kAddGroup);
      },
      backgroundColor: kPrimaryColor,
      child: const Icon(Icons.add), // Use LMS color
    );
  }
}

class GroupListPageBody extends StatelessWidget {
  final ApiService _apiService;
  GroupListPageBody({
    super.key,
  }) : _apiService = ApiService(api: Api(Dio()));

  // Fetches the list of groups asynchronously
  Future<List<GroupModel>> fetchGroups() async {
    try {
      return await _apiService.fetchGroups();
    } catch (e) {
      // Log the exception details for debugging purposes
      print('Exception occurred while fetching groups: $e');
      throw Exception('Failed to load groups');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add the breadcrumb at the top
          CustomBreadcrumb(
            items: const ['Home', 'Groups'],
            onTap: (index) {
              // Add navigation logic based on index
              if (index == 0) {
                GoRouter.of(context).go(AppRouter.kHomeView);
              } else if (index == 1) {
                // Navigate to Active Users
              }
            },
          ),
          // Add FutureBuilder to load group data below the breadcrumb
          Expanded(
            child: FutureBuilder<List<GroupModel>>(
              future: fetchGroups(),
              builder: (context, snapshot) {
                print('Connection state: ${snapshot.connectionState}');
                print('Has data: ${snapshot.hasData}');
                print('Has error: ${snapshot.hasError}');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error details: ${snapshot.error}');
                  return const Center(child: Text('Failed to load groups'));
                } else if (snapshot.hasData) {
                  List<GroupModel>? groups = snapshot.data;
                  if (groups == null || groups.isEmpty) {
                    return const Center(child: Text('No groups available'));
                  }
                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return GroupCard(group: groups[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('Unexpected error'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
