import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/billing/data/data_sources/billing_account_management_data_source.dart';
import 'package:lms/features/billing/data/models/billing_account_model.dart';
import 'package:lms/features/billing/presentation/widgets/billing_account_form.dart';
import 'package:lms/features/organization_management/data/models/organization_model.dart';

class BillingAccountManagementPage extends StatefulWidget {
  final int organizationId; // Pass dynamic organization ID

  const BillingAccountManagementPage({
    super.key,
    required this.organizationId,
  });

  @override
  _BillingAccountManagementPageState createState() =>
      _BillingAccountManagementPageState();
}

class _BillingAccountManagementPageState
    extends State<BillingAccountManagementPage> {
  late BillingAccountRemoteDataSource _billingAccountRemoteDataSource;
  List<BillingAccountModel> _billingAccounts = [];
  bool _isLoading = true;

  final Color primaryColor = const Color(0xFF017278);
  final Color accentColor = Colors.white;
  String _organizationName = 'Loading...';

  @override
  void initState() {
    super.initState();
    Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    Api api = Api(dio);
    _billingAccountRemoteDataSource = BillingAccountRemoteDataSource(api);
    _fetchOrganizationDetails();
    _fetchBillingAccounts();
  }

  Future<void> _fetchOrganizationDetails() async {
    try {
      String token = jwtTokenPublic;

      final dio = Dio(BaseOptions(headers: {
        'Authorization': 'Bearer $token',
      }));

      final response = await dio.get(
          'http://localhost:8082/api/organizations/${widget.organizationId}');
      final organization = OrganizationModel.fromJson(response.data);

      if (mounted) {
        setState(() {
          _organizationName = organization.name;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _organizationName = 'Unknown Organization';
        });
      }
      showSnackBar(
          context, 'Failed to fetch organization details: $e', Colors.red);
    }
  }

  Future<void> _fetchBillingAccounts() async {
    try {
      final accounts = await _billingAccountRemoteDataSource
          .getBillingAccountsByOrganizationId(widget.organizationId);
      if (mounted) {
        setState(() {
          _billingAccounts = accounts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showSnackBar(context, 'Failed to fetch billing accounts: $e', Colors.red);
    }
  }

  void _openBillingAccountForm(BuildContext context,
      {BillingAccountModel? account, required bool isEditing}) {
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
              width: MediaQuery.of(context).size.width * 0.9,
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
              child: BillingAccountForm(
                billingAccount: account,
                isEditing: isEditing,
                onSubmit: (BillingAccountModel updatedAccount) async {
                  try {
                    String result;
                    updatedAccount.organization = OrganizationModel(
                        id: widget.organizationId,
                        name: '',
                        address: '',
                        contactEmail: '',
                        contactPhone: '',
                        country: '');

                    if (isEditing) {
                      result = await _billingAccountRemoteDataSource
                          .updateBillingAccount(updatedAccount);
                    } else {
                      result = await _billingAccountRemoteDataSource
                          .addBillingAccount(updatedAccount);
                    }
                    _fetchBillingAccounts();
                    Navigator.of(context).pop();
                    showSnackBar(context, result, Colors.green);
                  } catch (e) {
                    showSnackBar(context,
                        'Failed to update billing account: $e', Colors.red);
                  }
                },
              ),
            ),
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _viewBillingAccountDetails(
      BuildContext context, BillingAccountModel account) {
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
              width: MediaQuery.of(context).size.width * 0.8,
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
                  appBar: AppBar(
                    title: const Text('Billing Account Details'),
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    titleTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    iconTheme: const IconThemeData(color: Colors.black),
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Business Name Header
                          Text(
                            account.businessName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Section: Billing account details
                          const Text(
                            'Billing account details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildDetailRow('Sold to address:',
                              '${account.firstName} ${account.lastName}\n${account.addressLine1}\n${account.city ?? ''}\n${account.country ?? ''}\n${account.businessPhoneNumber ?? ''}'),
                          const SizedBox(height: 20),

                          // Agreement Link
                          GestureDetector(
                            onTap: () {
                              // Handle agreement navigation here
                            },
                            child: const Text(
                              'Agreement: View Microsoft Online Subscription Agreement',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(thickness: 1),

                          // Section: Registration number
                          const Text(
                            'Registration number (Optional)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),

                          // Section: Additional details (optional)
                          const Divider(thickness: 1),
                          const SizedBox(height: 10),
                          const Text(
                            'These numbers help us review the details of your account. Learn more about registration numbers.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildDetailRow(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value ?? 'N/A',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBreadcrumb(
                  items: const ['Home', 'Billing Accounts'],
                  onTap: (index) {
                    if (index == 0) {
                      GoRouter.of(context).go(AppRouter.kHomeView);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Billing Accounts - $_organizationName',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300], thickness: 1),
                ElevatedButton.icon(
                  onPressed: () =>
                      _openBillingAccountForm(context, isEditing: false),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Billing Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                            label: Text('Business Name',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Phone',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('City',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _billingAccounts
                          .map(
                            (account) => DataRow(cells: [
                              DataCell(
                                InkWell(
                                  onTap: () => _viewBillingAccountDetails(
                                      context, account),
                                  child: Text(
                                    account.businessName,
                                    style: TextStyle(
                                      color: primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(account.businessPhoneNumber)),
                              DataCell(Text(account.city)),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete_outline,
                                      color: primaryColor),
                                  onPressed: () async {
                                    try {
                                      await _billingAccountRemoteDataSource
                                          .deleteBillingAccount(account.id);
                                      _fetchBillingAccounts();
                                    } catch (e) {
                                      showSnackBar(
                                          context,
                                          'Failed to delete account: $e',
                                          Colors.red);
                                    }
                                  },
                                ),
                              ),
                            ]),
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
