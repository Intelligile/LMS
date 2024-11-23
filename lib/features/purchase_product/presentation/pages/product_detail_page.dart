import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:lms/core/utils/api.dart';
import 'package:lms/core/utils/assets.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/payment/presentation/views/widgets/payment_view_body.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/user_management/data/data_sources/user_remote_data_source.dart';

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

  @override
  void initState() {
    super.initState();
    Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082'));
    Api api = Api(dio);
    _userRemoteDataSource = UserManagementRemoteDataSource(api);
  }

  Future<bool> _checkAuthorizationCode(String code) async {
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
              width: MediaQuery.of(context).size.width * 0.9,
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
                    child: PaymentViewBody(
                      onBillingDataSubmitted: (billingData) async {
                        await _createOrder(billingData);
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

  Future<void> _handleCheckout() async {
    final authCode = _authorizationCodeController.text;

    if (authCode.isNotEmpty) {
      final isAuthorized = await _checkAuthorizationCode(authCode);
      if (isAuthorized) {
        await _createOrder(null);
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

  IconData iconFromName(String iconName) {
    switch (iconName) {
      case 'gears':
        return FontAwesomeIcons.gears;
      case 'code-fork':
        return FontAwesomeIcons.codeFork;
      case 'bank':
        return FontAwesomeIcons.buildingColumns;
      case 'cubes':
        return FontAwesomeIcons.cubes;
      case 'cloud':
        return FontAwesomeIcons.cloud;
      case 'street':
        return FontAwesomeIcons.streetView;
      case 'eye':
        return FontAwesomeIcons.eye;
      case 'ravelry':
        return FontAwesomeIcons.ravelry;
      default:
        return FontAwesomeIcons.questionCircle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Product Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: AdaptiveLayout(
          mobileLayout: (context) => _buildMobileLayout(),
          tabletLayout: (context) => _buildTabletLayout(),
          desktopLayout: (context) => _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(),
            const SizedBox(height: 20),
            _buildProductInfo(),
            const SizedBox(height: 30),
            _buildSectionTitle('Number of Licenses'),
            const SizedBox(height: 15),
            _buildLicenseCountInput(),
            const SizedBox(height: 30),
            _buildSectionTitle('Checkout Options'),
            const SizedBox(height: 15),
            _buildCheckoutOptions(),
            const SizedBox(height: 30),
            _buildImageGrid(widget.product.name, crossAxisCount: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductHeader(),
                        const SizedBox(height: 20),
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
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child:
                      _buildImageGrid(widget.product.name, crossAxisCount: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotebookLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductHeader(),
                        const SizedBox(height: 20),
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
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child:
                      _buildImageGrid(widget.product.name, crossAxisCount: 3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(),
                  const SizedBox(height: 20),
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
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: _buildImageGrid(widget.product.name, crossAxisCount: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(String productName, {int crossAxisCount = 3}) {
    final Map<String, List<String>> productImages = {
      'Operation Engineering': [
        AssetsData.oe_n1,
        AssetsData.oen2,
        AssetsData.oen3,
        AssetsData.oen4,
        AssetsData.oen5,
        AssetsData.oen6,
        AssetsData.oen7,
        AssetsData.oen8,
      ],
      'Governance and Risk': [
        AssetsData.grc4,
        AssetsData.grcn1,
        AssetsData.grcn2,
        AssetsData.grcn3,
      ],
      'Digital Transformation': [
        AssetsData.oen5,
        AssetsData.oen6,
        AssetsData.oen7,
        AssetsData.oen8,
      ],
      'Enterprise Architecture': [
        AssetsData.stn6,
        AssetsData.stn7,
        AssetsData.st10,
        AssetsData.st11,
      ],
      'Human Capital': [
        AssetsData.hc_n1,
        AssetsData.hcn1,
        AssetsData.hcn2,
        AssetsData.hcn3,
        AssetsData.hcn4,
        AssetsData.hcn5,
      ],
      'Strategy': [
        AssetsData.st1,
        AssetsData.st5,
        AssetsData.stn1,
        AssetsData.stn2,
        AssetsData.stn3,
        AssetsData.stn4,
        AssetsData.stn5,
        AssetsData.stn6,
        AssetsData.stn7,
        AssetsData.st10,
        AssetsData.st11,
      ],
    };

    String? matchedCategory;
    for (String category in productImages.keys) {
      if (productName.contains(category)) {
        matchedCategory = category;
        break;
      }
    }

    List<String> imageUrls =
        matchedCategory != null ? productImages[matchedCategory] ?? [] : [];

    return Padding(
      padding:
          const EdgeInsets.all(0), // Remove any padding around the GridView
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageUrls.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 3, // Reduce to further minimize vertical gap
          crossAxisSpacing: 3, // Reduce horizontal gap if needed
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 350,
                maxHeight: 350,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrls[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            iconFromName(widget.product.imageUrl),
            size: 30,
            color: const Color(0xFF017278),
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
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF017278),
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size.fromHeight(60),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
