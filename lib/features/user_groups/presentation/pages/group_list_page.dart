import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_groups/presentation/widgets/group_card.dart';
import 'package:lms/core/utils/app_router.dart';

class GroupListPage extends StatelessWidget {
  final ApiService _apiService;

  GroupListPage({Key? key})
      : _apiService = ApiService(api: Api(Dio())),
        super(key: key);

  // Fetches the list of groups asynchronously
  Future<List<GroupModel>> _fetchGroups() async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Groups'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back when the back button is pressed
            GoRouter.of(context).push(AppRouter.kHomeView);
          },
        ),
      ),
      body: FutureBuilder<List<GroupModel>>(
        future: _fetchGroups(),
        builder: (context, snapshot) {
          // Print the connection state and other debug info
          print('Connection state: ${snapshot.connectionState}');
          print('Has data: ${snapshot.hasData}');
          print('Has error: ${snapshot.hasError}');

          // Show loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Show error message if data fetch fails
          else if (snapshot.hasError) {
            print('Error details: ${snapshot.error}');
            return const Center(child: Text('Failed to load groups'));
          }
          // Show group list if data is available
          else if (snapshot.hasData) {
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
          }
          // Handle unexpected scenarios
          else {
            return const Center(child: Text('Unexpected error'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Group page when the FAB is pressed
          GoRouter.of(context).go(AppRouter.kAddGroup);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF017278), // Use LMS color
      ),
    );
  }
}
