import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/payment/presentation/views/widgets/payment_view_body.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';
import 'package:lms/features/user_management/data/models/user_model.dart';

class ProductDetailPage extends StatefulWidget {
  final RegionProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController _licenseCountController = TextEditingController();
  final TextEditingController _authorizationCodeController =
      TextEditingController();
  late UserManagementRemoteDataSource _userRemoteDataSource;
  bool _isButtonPressed = false;
  @override
  void initState() {
    super.initState();
    Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082'));
    Api api = Api(dio);
    _userRemoteDataSource = UserManagementRemoteDataSource(api);
  }

  // Function to check authorization code
  Future<bool> _checkAuthorizationCode(String code) async {
    // Replace this mock logic with actual API call if available
    return true;
  }

  Future<void> _createOrder(Map<String, dynamic>? billingData) async {
    final url = Uri.parse('http://localhost:8082/api/billing/create-order');

    try {
      final users = await _userRemoteDataSource.getUsers();
      final matchedUser =
          users.firstWhere((user) => user.username == usernamePublic);
      final userId = matchedUser.id;

      final orderData = {
        "userId": userId,
        "items": [
          {
            "productId": widget.product.id,
            "quantity": int.parse(_licenseCountController.text),
            "price": widget.product.price,
          }
        ],
        "totalAmount":
            widget.product.price * int.parse(_licenseCountController.text),
      };

      if (_authorizationCodeController.text.isNotEmpty) {
        orderData["authorizationCode"] = _authorizationCodeController.text;
      } else if (billingData != null) {
        orderData["billing"] = billingData;
      } else {
        showSnackBar("Payment information required.", Colors.red);
        return;
      }

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(orderData),
      );

      if (response.statusCode == 200) {
        showSnackBar("Invoice generated successfully!", Colors.green);
      } else {
        showSnackBar("Failed to create order.", Colors.red);
      }
    } catch (e) {
      showSnackBar("An error occurred: $e", Colors.red);
    }
  }

  void _openPaymentFormFromRight(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
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
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PaymentViewBody(
                    // Use an anonymous function to call _createOrder
                    onBillingDataSubmitted: (billingData) async {
                      await _createOrder(billingData);
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
  }

  Future<void> _handleCheckout() async {
    final authCode = _authorizationCodeController.text;

    if (authCode.isNotEmpty) {
      final isAuthorized = await _checkAuthorizationCode(authCode);
      if (isAuthorized) {
        await _createOrder(null); // No billing data needed if authorized
      } else {
        showSnackBar("Invalid authorization code.", Colors.red);
      }
    } else {
      _openPaymentFormFromRight(context);
    }
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductHeader(),
                const SizedBox(height: 30),
                _buildProductInfo(),
                const SizedBox(height: 30),
                _buildSectionTitle('Number of Licenses'),
                const SizedBox(height: 15),
                _buildLicenseCountInput(),
                const SizedBox(height: 30),
                _buildSectionTitle('Checkout Options'),
                const SizedBox(height: 15),
                _buildCheckoutOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            widget.product.imageUrl,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${widget.product.price.toStringAsFixed(2)} / license',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Text(
      widget.product.description,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildLicenseCountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Licenses',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _licenseCountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter quantity',
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _authorizationCodeController,
          decoration: InputDecoration(
            labelText: 'Authorization Code (optional)',
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, // Make button take full width
          child: ElevatedButton(
            onPressed: _handleCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF017278),
              padding: const EdgeInsets.symmetric(
                  vertical: 20), // Increase vertical padding for height
              minimumSize: const Size.fromHeight(60), // Set a minimum height
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18), // Increase font size
            ),
          ),
        ),
      ],
    );
  }
}
