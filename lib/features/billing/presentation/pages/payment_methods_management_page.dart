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
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:lms/features/payment/presentation/views/widgets/payment_view_body.dart';

class PaymentMethodManagementPage extends StatefulWidget {
  final int organizationId;

  const PaymentMethodManagementPage({
    super.key,
    required this.organizationId,
  });

  @override
  _PaymentMethodManagementPageState createState() =>
      _PaymentMethodManagementPageState();
}

class _PaymentMethodManagementPageState
    extends State<PaymentMethodManagementPage> {
  late Dio _dio;
  List<Map<String, dynamic>> _billingAccounts = [];
  List<Map<String, dynamic>> _paymentMethods = [];
  bool _isLoadingBillingAccounts = true;
  bool _isLoadingPaymentMethods = false;
  Map<String, dynamic>? _selectedBillingAccount;

  final Color primaryColor = const Color(0xFF017278);

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082'));
    _fetchBillingAccounts();
  }

  Future<void> _fetchBillingAccounts() async {
    try {
      String token = jwtTokenPublic;

      final dio = Dio(BaseOptions(headers: {
        'Authorization': 'Bearer $token',
      }));

      final response = await dio.get(
          'http://localhost:8082/api/billing-accounts/org/${widget.organizationId}');
      final billingAccounts = List<Map<String, dynamic>>.from(response.data);

      if (mounted) {
        setState(() {
          _billingAccounts = billingAccounts;
          _isLoadingBillingAccounts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBillingAccounts = false;
        });
      }
      showSnackBar(context, 'Failed to fetch billing accounts: $e', Colors.red);
    }
  }

  Future<void> _fetchPaymentMethods(int billingAccountId) async {
    try {
      String token = jwtTokenPublic;

      final dio = Dio(BaseOptions(headers: {
        'Authorization': 'Bearer $token',
      }));

      setState(() {
        _isLoadingPaymentMethods = true;
      });

      final response = await dio.get(
          'http://localhost:8082/api/payment-methods/billing-account/$billingAccountId');
      final paymentMethods = List<Map<String, dynamic>>.from(response.data);

      if (mounted) {
        setState(() {
          _paymentMethods = paymentMethods;
          _isLoadingPaymentMethods = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPaymentMethods = false;
        });
      }
      showSnackBar(context, 'Failed to fetch payment methods: $e', Colors.red);
    }
  }

  void _openAddPaymentMethodForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        final TextEditingController holderNameController =
            TextEditingController();
        final TextEditingController cardNumberController =
            TextEditingController();
        final TextEditingController expiryDateController =
            TextEditingController();
        final TextEditingController cvvController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Payment Method',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: holderNameController,
                    decoration: InputDecoration(
                      labelText: 'Account Holder Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the account holder name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: cardNumberController,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    validator: (value) {
                      if (value == null || value.length != 16) {
                        return 'Card number must be 16 digits.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: expiryDateController,
                          decoration: InputDecoration(
                            labelText: 'Expiry Date (MM/YY)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null ||
                                !RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                              return 'Invalid expiry date format.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: cvvController,
                          decoration: InputDecoration(
                            labelText: 'CVV',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          validator: (value) {
                            if (value == null || value.length != 3) {
                              return 'CVV must be 3 digits.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await _dio.post(
                                'http://localhost:8082/api/payment-methods/billing-account/${_selectedBillingAccount!['id']}',
                                data: {
                                  'accountHolderName':
                                      holderNameController.text,
                                  'cardNumber': cardNumberController.text,
                                  'expiryDate': expiryDateController.text,
                                  'cvv': cvvController.text,
                                  'methodName': 'Credit Card',
                                });
                            Navigator.of(context).pop();
                            _fetchPaymentMethods(
                                _selectedBillingAccount!['id']);
                            showSnackBar(
                              context,
                              'Payment method added successfully!',
                              Colors.green,
                            );
                          } catch (e) {
                            showSnackBar(context,
                                'Failed to add payment method: $e', Colors.red);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Add Payment Method',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openPaymentMethodDetails(
      BuildContext context, Map<String, dynamic> paymentMethod) {
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
                    offset: Offset(-4, 0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Material(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethod['methodName'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Payment Method Details',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Account Holder: ${paymentMethod['accountHolderName']}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Card Number: ${paymentMethod['cardNumber']}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expiry Date: ${paymentMethod['expiryDate']}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the details
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
    return _isLoadingBillingAccounts
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBreadcrumb(
                  items: const ['Home', 'Payment Methods'],
                  onTap: (index) {
                    if (index == 0) {
                      GoRouter.of(context).go(AppRouter.kHomeView);
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Payment Methods Management',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<Map<String, dynamic>>(
                  value: _selectedBillingAccount,
                  hint: const Text("Select Billing Account"),
                  isExpanded: true,
                  items: _billingAccounts.map((account) {
                    return DropdownMenuItem(
                      value: account,
                      child: Text(account['businessName']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBillingAccount = value;
                      _paymentMethods = [];
                    });
                    _fetchPaymentMethods(value!['id']);
                  },
                ),
                const SizedBox(height: 16),
                if (_selectedBillingAccount != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_selectedBillingAccount == null) {
                        showSnackBar(
                            context,
                            'Please select a billing account first.',
                            Colors.red);
                        return;
                      }
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0), // Start from the right
                              end: Offset.zero, // Slide to the center
                            ).animate(animation),
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
                                child: Scaffold(
                                  appBar: AppBar(
                                    title: const Text('Add Payment Method'),
                                    backgroundColor: primaryColor,
                                    automaticallyImplyLeading: false,
                                    actions: [
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the form
                                        },
                                      ),
                                    ],
                                  ),
                                  body: Padding(
                                    padding: const EdgeInsets.all(70.0),
                                    child: PaymentViewBody(
                                      onBillingDataSubmitted:
                                          (billingData) async {
                                        try {
                                          await _dio.post(
                                            'http://localhost:8082/api/payment-methods/billing-account/${_selectedBillingAccount!['id']}',
                                            options: Options(
                                              headers: {
                                                'Authorization':
                                                    'Bearer $jwtTokenPublic', // Include token for authorization
                                                'Content-Type':
                                                    'application/json',
                                              },
                                            ),
                                            data: {
                                              'accountHolderName':
                                                  billingData['cardholderName'],
                                              'cardNumber': billingData[
                                                  'creditCardNumber'],
                                              'expiryDate':
                                                  billingData['expiryDate'],
                                              'cvv': billingData['cvv'],
                                              'postalCode':
                                                  billingData['postalCode'],
                                              'region': billingData['region'],
                                              'methodName': 'Credit Card',
                                            },
                                          );

                                          Navigator.of(context)
                                              .pop(); // Close the drawer
                                          _fetchPaymentMethods(
                                              _selectedBillingAccount![
                                                  'id']); // Refresh methods
                                          showSnackBar(
                                              context,
                                              'Payment method added successfully!',
                                              Colors.green);
                                        } catch (e) {
                                          showSnackBar(
                                              context,
                                              'Failed to add payment method: $e',
                                              Colors.red);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Payment Method'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                const SizedBox(height: 16),
                if (_isLoadingPaymentMethods)
                  const Center(child: CircularProgressIndicator())
                else if (_selectedBillingAccount != null)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text('Account Holder',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Payment Method ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Card Number',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: _paymentMethods
                            .map(
                              (method) => DataRow(cells: [
                                DataCell(
                                  InkWell(
                                    onTap: () => _openPaymentMethodDetails(
                                        context, method),
                                    child: Text(
                                      method['accountHolderName'],
                                      style: const TextStyle(
                                        color: kPrimaryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(method['methodName'] ?? 'N/A')),
                                DataCell(Text(method['cardNumber'] ?? 'N/A')),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete_outline,
                                        color: primaryColor),
                                    onPressed: () async {
                                      try {
                                        await _dio.delete(
                                            '/api/payment-methods/${method['id']}');
                                        _fetchPaymentMethods(
                                            _selectedBillingAccount!['id']);
                                      } catch (e) {
                                        showSnackBar(
                                            context,
                                            'Failed to delete method: $e',
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
