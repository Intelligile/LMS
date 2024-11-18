import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/dmz_management/data/data_sources/dmz_remote_data_source.dart';
import 'package:lms/features/dmz_management/data/models/dmz_model.dart';
import 'package:lms/features/dmz_management/presentation/widgets/dmz_form.dart';

class DMZManagementPage extends StatefulWidget {
  const DMZManagementPage({super.key});

  @override
  _DMZManagementPageState createState() => _DMZManagementPageState();
}

class _DMZManagementPageState extends State<DMZManagementPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: AdaptiveLayout(
        mobileLayout: (context) => const DMZManagementPageBody(),
        tabletLayout: (context) => const SizedBox(),
        desktopLayout: (context) => const DMZManagementPageBody(),
      ),
    );
  }
}

class DMZManagementPageBody extends StatefulWidget {
  const DMZManagementPageBody({super.key});

  @override
  State<DMZManagementPageBody> createState() => _DMZManagementPageBodyState();
}

class _DMZManagementPageBodyState extends State<DMZManagementPageBody> {
  late DMZManagementRemoteDataSource _dmzRemoteDataSource;
  List<DMZModel> _dmzAccounts = [];
  bool _isLoading = true;

  final Color primaryColor = const Color(0xFF017278); // LMS Primary Color

  @override
  void initState() {
    super.initState();
    Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    Api api = Api(dio);
    _dmzRemoteDataSource = DMZManagementRemoteDataSource(api);
    _fetchDMZAccounts();
  }

  Future<void> _fetchDMZAccounts() async {
    try {
      final accounts = await _dmzRemoteDataSource.getDMZAccounts();
      if (mounted) {
        setState(() {
          _dmzAccounts = accounts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Failed to fetch DMZ accounts: $e");
    }
  }

  void _openDMZFormFromRight(BuildContext context,
      {DMZModel? dmz, required bool isEditing}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0))
                  .animate(animation),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(-4, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DMZForm(
                      dmzAccounts:
                          dmz != null ? [dmz] : [], // Wrap dmz in a list
                      isEditing: isEditing,
                      onSubmit: (List<DMZModel> updatedDMZList) async {
                        try {
                          String result;
                          if (updatedDMZList.isNotEmpty &&
                              updatedDMZList.first.dmzId != 0) {
                            result =
                                await _dmzRemoteDataSource.updateDMZAccount(
                                    updatedDMZList.first, jwtToken);
                          } else {
                            result = await _dmzRemoteDataSource
                                .addDMZAccounts(updatedDMZList);
                          }
                          _fetchDMZAccounts();
                          Navigator.of(context).pop();
                          showSnackBar(context, result, Colors.green);
                        } catch (e) {
                          showSnackBar(context,
                              'Failed to save DMZ account: $e', Colors.red);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  DataRow _buildDMZListDataRow(DMZModel dmz) {
    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onTap: () =>
                _openDMZFormFromRight(context, dmz: dmz, isEditing: true),
            child: Text(dmz.dmzOrganization,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DataCell(Text(dmz.uniqueId)),
        DataCell(Text(dmz.dmzCountry)),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete_outline, color: primaryColor),
            onPressed: () async {
              try {
                await _dmzRemoteDataSource.removeDMZAccount(dmz.dmzId);
                showSnackBar(
                    context, 'DMZ account deleted successfully', Colors.green);
                _fetchDMZAccounts();
              } catch (e) {
                showSnackBar(
                    context, 'Failed to delete DMZ account: $e', Colors.red);
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBreadcrumb(
                  items: const ['Home', 'DMZ Accounts'],
                  onTap: (index) {
                    if (index == 0) {
                      // Navigate to Home
                    }
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'DMZ Accounts',
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          _openDMZFormFromRight(context, isEditing: false),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Add DMZ',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dividerThickness: 1,
                      columnSpacing: 24.0,
                      columns: const [
                        DataColumn(
                            label: Text('Organization',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Unique ID',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Country',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _dmzAccounts
                          .map((dmz) => _buildDMZListDataRow(dmz))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
