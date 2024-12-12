import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:path_provider/path_provider.dart';

class BillingAndPaymentsManagementPage extends StatefulWidget {
  const BillingAndPaymentsManagementPage({Key? key}) : super(key: key);

  @override
  _BillingAndPaymentsManagementPageState createState() =>
      _BillingAndPaymentsManagementPageState();
}

class _BillingAndPaymentsManagementPageState
    extends State<BillingAndPaymentsManagementPage> {
  late Dio _dio;
  bool _isLoading = true;
  List<Map<String, dynamic>> _billingData = [];

  final Color primaryColor = const Color(0xFF017278);

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082'));
    _fetchBillingAndPayments();
  }

  Future<void> _fetchBillingAndPayments() async {
    try {
      final response = await _dio.get(
        '/api/billing/billing-and-payments',
        options: Options(
          headers: {'Authorization': 'Bearer $jwtTokenPublic'},
        ),
      );
      setState(() {
        _billingData = List<Map<String, dynamic>>.from(response.data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(
          context, 'Failed to fetch billing and payments data: $e', Colors.red);
    }
  }

  Future<void> _downloadPDF(String billId) async {
    try {
      final response = await _dio.get(
        '/api/billing/download-bill/$billId',
        options: Options(
          headers: {'Authorization': 'Bearer $jwtTokenPublic'},
          responseType: ResponseType.bytes,
        ),
      );

      // Convert the response data to Uint8List
      final bytes = Uint8List.fromList(response.data);

      // Create a blob and a download link
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'bill_$billId.pdf'
        ..click();
      html.Url.revokeObjectUrl(url);

      showSnackBar(context, 'PDF downloaded successfully!', Colors.green);
    } catch (e) {
      showSnackBar(context, 'Failed to download PDF: $e', Colors.red);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: AdaptiveLayout(
        mobileLayout: (_) => _buildPageBody(),
        tabletLayout: (_) => _buildPageBody(),
        desktopLayout: (_) => _buildPageBody(isDesktop: true),
      ),
    );
  }

  Widget _buildPageBody({bool isDesktop = false}) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBreadcrumb(
                  items: const ['Home', 'Billing and Payments'],
                  onTap: (index) {
                    if (index == 0) {
                      // Handle navigation to Home
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Billing and Payments Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300], thickness: 1),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Bill ID',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Invoice Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Total Amount',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Billing Account Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Payment Method',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Download PDF',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: _billingData
                          .map(
                            (data) => DataRow(
                              cells: [
                                DataCell(Text(data['billId'].toString())),
                                DataCell(Text(
                                  data['invoiceDate'] != null
                                      ? formatter.format(
                                          DateTime.parse(data['invoiceDate']))
                                      : 'N/A',
                                )),
                                DataCell(Text('\$${data['totalAmount']}')),
                                DataCell(Text(
                                    data['billingAccountName']?.toString() ??
                                        'N/A')),
                                DataCell(Text(
                                    data['paymentMethod']?.toString() ??
                                        'N/A')),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.download,
                                        color: primaryColor),
                                    onPressed: () =>
                                        _downloadPDF(data['billId'].toString()),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
