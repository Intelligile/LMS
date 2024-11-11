import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/license_renewal/data/license_remote_datasource.dart';
import 'package:lms/features/license_renewal/presentation/model/license_model.dart';
import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';

class LicenseRenewalBody extends StatefulWidget {
  const LicenseRenewalBody({super.key});

  @override
  _LicenseRenewalBodyState createState() => _LicenseRenewalBodyState();
}

class _LicenseRenewalBodyState extends State<LicenseRenewalBody> {
  late LicenseRemoteDataSource _licenseRemoteDataSource;
  List<LicenseModel> _licenses = [];
  bool _isLoading = true;
  late UserManagementRemoteDataSource _userRemoteDataSource;
  final Color primaryColor = const Color(0xFF017278); // LMS Primary Color

  @override
  void initState() {
    super.initState();
    Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8081'));
    Api api = Api(dio);
    _userRemoteDataSource = UserManagementRemoteDataSource(api);
    _licenseRemoteDataSource =
        LicenseRemoteDataSource(baseUrl: 'http://localhost:8081', api);

    _fetchLicenses();
  }

  Future<void> _fetchLicenses() async {
    try {
      final users = await _userRemoteDataSource.getUsers();
      final matchedUser =
          users.firstWhere((user) => user.username == usernamePublic);
      final userId = matchedUser.id;
      final licenses =
          await _licenseRemoteDataSource.getLicensesByUserId(userId);
      if (mounted) {
        setState(() {
          _licenses = licenses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showSnackBar(context, "Failed to fetch licenses: $e", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomBreadcrumb(
            items: const ['Home', 'License Management'],
            onTap: (index) {
              if (index == 0) {
                GoRouter.of(context).go(AppRouter.kHomeView);
              }
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'License Management',
            style: TextStyle(
              fontSize: 28, // Larger font for title
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _fetchLicenses(),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Refresh',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {}, // Placeholder for export action
                icon: const Icon(Icons.file_download, color: Colors.black),
                label: const Text('Export to Excel',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[300], thickness: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width),
                      child: DataTable(
                        dividerThickness: 1,
                        columnSpacing: 24.0,
                        columns: const [
                          DataColumn(
                              label: Text('License Key',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Feature Key',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Key Expiry Date',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: _licenses.expand((license) {
                          return license.features!.map((feature) {
                            return DataRow(cells: [
                              buildDataCell(
                                dataCell:
                                    license.features!.indexOf(feature) == 0
                                        ? license.licenseKey ?? 'N/A'
                                        : '',
                              ),
                              buildDataCell(dataCell: feature.key ?? 'N/A'),
                              buildDataCell(
                                  dataCell: feature.keyExpiryDate
                                          ?.toLocal()
                                          .toString() ??
                                      'N/A'),
                              DataCell(
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: license.valid == true
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      license.valid == true
                                          ? 'Enabled'
                                          : 'Disabled',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ]);
                          }).toList();
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  DataCell buildDataCell({required String dataCell}) {
    return DataCell(Text(
      dataCell,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
    ));
  }
}
