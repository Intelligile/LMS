import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/constants.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/user_groups/data/data_sources/user_group_service.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import 'package:lms/features/user_groups/presentation/widgets/group_form.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  _GroupListPageState createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: AdaptiveLayout(
        mobileLayout: (context) => const SizedBox(),
        tabletLayout: (context) => const SizedBox(),
        desktopLayout: (context) => const GroupListPageBody(),
      ),
    );
  }
}

class GroupListPageBody extends StatefulWidget {
  const GroupListPageBody({super.key});

  @override
  State<GroupListPageBody> createState() => _GroupListPageBodyState();
}

class _GroupListPageBodyState extends State<GroupListPageBody> {
  final ApiService _apiService = ApiService(api: Api(Dio()));
  List<GroupModel> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      final groups = await _apiService.fetchGroups();
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Failed to fetch groups: $e");
    }
  }

  void _openGroupFormDrawer(BuildContext context, {GroupModel? group}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(-4, 0))
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              child: GroupForm(
                group: group,
                api: _apiService,
                onSave: () {
                  Navigator.of(context).pop();
                  _fetchGroups();
                },
              ),
            ),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                CustomBreadcrumb(
                  items: const ['Home', 'Groups'],
                  onTap: (index) {
                    if (index == 0)
                      GoRouter.of(context).go(AppRouter.kHomeView);
                  },
                ),
                const SizedBox(height: 30),

                // Title
                const Text(
                  'Groups',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Divider(color: Colors.grey[300], thickness: 1),

                // Action buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _openGroupFormDrawer(context),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Add Group',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _fetchGroups,
                      icon: const Icon(Icons.refresh, color: Colors.black),
                      label: const Text('Refresh',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon:
                          const Icon(Icons.file_download, color: Colors.black),
                      label: const Text('Export to Excel',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(color: Colors.grey[300], thickness: 1),

                // Data Table
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      child: DataTable(
                        dividerThickness: 1,
                        columnSpacing: 24.0,
                        columns: const [
                          DataColumn(
                            label: Text('Group ID',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Group Name',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Description',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: _groups.map((group) {
                          return DataRow(
                            cells: [
                              DataCell(Text(group.id.toString())),
                              DataCell(
                                InkWell(
                                  onTap: () => _openGroupFormDrawer(context,
                                      group: group),
                                  child: Text(
                                    group.name,
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                  Text(group.description ?? 'No description')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: kPrimaryColor),
                                  onPressed: () async {
                                    try {
                                      await _apiService.deleteGroup(group.id);
                                      showSnackBar(
                                          context,
                                          'Group deleted successfully',
                                          Colors.green);
                                      _fetchGroups();
                                    } catch (e) {
                                      showSnackBar(
                                          context,
                                          'Failed to delete group: $e',
                                          Colors.red);
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
