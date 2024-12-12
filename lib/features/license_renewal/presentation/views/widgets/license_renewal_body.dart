import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';

class LicenseManagementPage extends StatefulWidget {
  const LicenseManagementPage({super.key});

  @override
  State<LicenseManagementPage> createState() => _LicenseManagementPageState();
}

class _LicenseManagementPageState extends State<LicenseManagementPage> {
  late Dio _dio;
  late Dio _dioLicense;
  List<Map<String, dynamic>> _licenseData = [];
  bool _isLoading = true;
  final Color primaryColor = const Color(0xFF017278); // LMS Primary Color
  final String _authToken =
      "Bearer $jwtTokenPublic"; // Replace with actual token

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082'));
    _dioLicense = Dio(BaseOptions(baseUrl: 'http://localhost:8081'));
    _fetchLicenseData();
  }

  Future<int?> _fetchUserId() async {
    try {
      final response = await _dio.get(
        '/api/auth/user/profile/$usernamePublic',
        options: Options(headers: {"Authorization": _authToken}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['id']; // Assuming the response contains `id` for the user
      } else {
        throw Exception('Failed to fetch user ID');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }

  Future<void> _fetchLicenseData() async {
    try {
      debugPrint("Starting _fetchLicenseData...");

      // Step 1: Fetch userId
      debugPrint("Fetching userId...");
      final userId = await _fetchUserId();
      if (userId == null) {
        debugPrint("Failed to fetch userId");
        throw Exception("Failed to fetch userId");
      }
      debugPrint("Fetched userId: $userId");

      // Step 2: Fetch billing data
      debugPrint("Fetching billing data for username: $usernamePublic");
      final billingResponse = await _dio.get(
        '/api/billing/orders/username/$usernamePublic',
        options: Options(headers: {"Authorization": _authToken}),
      );
      debugPrint("Billing response received: ${billingResponse.statusCode}");

      // Step 3: Fetch license expiration data
      debugPrint("Fetching license data for userId: $userId");
      final licenseResponse = await _dioLicense.get(
        '/api/license/user/$userId',
        options: Options(headers: {"Authorization": _authToken}),
      );
      debugPrint("License response received: ${licenseResponse.statusCode}");

      if (billingResponse.statusCode == 200 &&
          licenseResponse.statusCode == 200) {
        final billingData = billingResponse.data;
        final licenseData = licenseResponse.data;

        debugPrint("Billing data fetched: ${billingData.length} items");
        debugPrint("License data fetched: ${licenseData.length} items");

        // Map license expiration data by licenseId
        debugPrint("Mapping license expiration data...");
        final Map<int, String> licenseExpirationMap = {};
        for (var license in licenseData) {
          final licenseId = license["licenseId"];
          final endDate = license["endDate"];
          if (licenseId != null && endDate != null) {
            licenseExpirationMap[licenseId] = endDate;
            debugPrint("Mapped licenseId: $licenseId with endDate: $endDate");
          }
        }

        // Process billing data
        debugPrint("Processing billing data...");
        final Map<String, Map<String, dynamic>> groupedData = {};
        for (var order in billingData) {
          if (order['status'] == 'Paid' && order['items'] != null) {
            debugPrint("Processing order with status 'Paid': ${order['id']}");
            for (var item in order['items']) {
              final productName = item["productName"] ?? "N/A";
              final iconName = item["iconName"] ?? "questionCircle";
              final licenseId = item["licenseId"];
              final expirationDate = licenseId != null
                  ? licenseExpirationMap[licenseId] ?? "N/A"
                  : "License ID Missing";

              debugPrint(
                  "Processing item: $productName, licenseId: $licenseId, expirationDate: $expirationDate");

              if (!groupedData.containsKey(productName)) {
                groupedData[productName] = {
                  "productName": productName,
                  "quantityPurchased": item["quantity"] ?? 0,
                  "licensesAssigned": item["licensesAssigned"] ?? 0,
                  "subscriptionType": order["subscriptionType"] ?? "N/A",
                  "paymentType": order["paymentType"] ?? "N/A",
                  "iconName": iconName,
                  "licenseId": licenseId,
                  "expirationDate": expirationDate,
                  "userId": userId,
                  "productId": item["productId"],
                };
                debugPrint("Added new group for productName: $productName");
              } else {
                groupedData[productName]!["quantityPurchased"] +=
                    item["quantity"] ?? 0;
                groupedData[productName]!["licensesAssigned"] +=
                    item["licensesAssigned"] ?? 0;
                debugPrint("Updated group for productName: $productName");
              }
            }
          }
        }

        debugPrint(
            "Grouped data processed. Total groups: ${groupedData.length}");

        setState(() {
          _licenseData = groupedData.values.toList();
          _isLoading = false;
        });
        debugPrint("License data updated in state.");
      } else {
        debugPrint(
            "Failed to fetch data: billingResponse or licenseResponse not 200.");
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showSnackBar(context, "Failed to fetch license data: $e", Colors.red);
    }
  }

  Future<void> _renewLicense(Map<String, dynamic> license) async {
    try {
      print("LICENSE ID IN RENEW LICENSE ${license['licenseId']}");
      final response = await _dio.post(
        '/api/billing/renew-order',
        data: {
          "userId": license["userId"],
          "licenseId": license["licenseId"],
          "productId": license["productId"],
          "subscriptionType": license["subscriptionType"],
        },
        options: Options(
          headers: {"Authorization": _authToken},
        ),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, "License renewed successfully", Colors.green);
        _fetchLicenseData(); // Refresh data
      } else {
        throw Exception("Failed to renew license");
      }
    } catch (e) {
      showSnackBar(context, "Failed to renew license: $e", Colors.red);
    }
  }

  IconData iconFromName(String iconName) {
    switch (iconName) {
      case 'MAP for Operation Engineering':
        return FontAwesomeIcons.gears;
      case 'code-fork':
        return FontAwesomeIcons.codeFork;
      case ' MAP for Governance and Risk':
        return FontAwesomeIcons.buildingColumns;
      case ' MAP for Digital Transformation':
        return FontAwesomeIcons.cubes;
      case ' MAP for Enterprise Architecture':
        return FontAwesomeIcons.cloud;
      case ' MAP for Human Capital':
        return FontAwesomeIcons.streetView;
      case ' MAP for Strategy':
        return FontAwesomeIcons.eye;
      case 'ravelry':
        return FontAwesomeIcons.ravelry;
      default:
        return FontAwesomeIcons.questionCircle;
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _fetchLicenseData,
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
                              label: Text('Product Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Quantity Purchased',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Licenses Assigned',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Subscription Type',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text('Payment Type',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            // DataColumn(
                            //   label: Text('Expiration Date',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold)),
                            // ),
                            // DataColumn(
                            //   label: Text('Actions',
                            //       style:
                            //           TextStyle(fontWeight: FontWeight.bold)),
                            // ),
                          ],
                          rows: _licenseData.map((license) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Row(
                                    children: [
                                      Icon(
                                        iconFromName(license["productName"] ??
                                            'questionCircle'),
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        license["productName"] ?? 'N/A',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(
                                  license["quantityPurchased"].toString(),
                                  style: const TextStyle(fontSize: 14),
                                )),
                                DataCell(Text(
                                  license["licensesAssigned"].toString(),
                                  style: const TextStyle(fontSize: 14),
                                )),
                                DataCell(Text(
                                  license["subscriptionType"] ?? 'N/A',
                                  style: const TextStyle(fontSize: 14),
                                )),
                                DataCell(Text(
                                  license["paymentType"] ?? 'N/A',
                                  style: const TextStyle(fontSize: 14),
                                )),
                                // DataCell(Text(
                                //   license["expirationDate"] ?? 'N/A',
                                //   style: const TextStyle(fontSize: 14),
                                // )),
                                // DataCell(
                                //   ElevatedButton(
                                //     onPressed: () {
                                //       debugPrint(
                                //           "Renewing license for licenseId: ${license["licenseId"]}");
                                //       _renewLicense(license);
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: primaryColor,
                                //     ),
                                //     child: const Text(
                                //       'Renew',
                                //       style: TextStyle(color: Colors.white),
                                //     ),
                                //   ),
                                // ),
                              ],
                            );
                          }).toList(),
                        )),
                  ),
          ),
        ],
      ),
    );
  }
}
