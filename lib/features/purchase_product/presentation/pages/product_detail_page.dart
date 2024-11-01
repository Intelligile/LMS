import 'package:flutter/material.dart';
import 'package:lms/features/payment/presentation/views/widgets/payment_view_body.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';

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

  bool _isButtonPressed = false;

  void _openPaymentFormFromRight(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Allows background to remain visible
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.6, // 60% width of screen
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
              child: const Scaffold(
                body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: PaymentViewBody(),
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
                '\$${widget.product.price.toStringAsFixed(2)} per license',
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
        GestureDetector(
          onTapDown: (_) => setState(() => _isButtonPressed = true),
          onTapUp: (_) => setState(() => _isButtonPressed = false),
          onTapCancel: () => setState(() => _isButtonPressed = false),
          onTap: () => _openPaymentFormFromRight(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.identity()..scale(_isButtonPressed ? 0.98 : 1.0),
            decoration: BoxDecoration(
              color: const Color(0xFF017278),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: const Text(
              'Checkout with Credit Card',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
      ],
    );
  }
}
