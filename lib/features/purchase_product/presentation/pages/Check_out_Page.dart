import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import 'package:lms/features/purchase_product/presentation/pages/Payment_Summary_Page.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final lmsPrimaryColor = Color(0xFF017278); // LMS color

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lmsPrimaryColor,
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Text(
              'Summary of Purchase',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: lmsPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        cartItem.product.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Quantity: ${cartItem.quantity}'),
                      trailing: Text(
                        '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: lmsPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: lmsPrimaryColor,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lmsPrimaryColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _showPaymentMethodDialog(context, lmsPrimaryColor);
                  },
                  child: const Text(
                    'Pay',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context, Color primaryColor) {
    final _formKey = GlobalKey<FormState>();
    String paymentMethod = '';
    String cardNumber = '';
    String expiryDate = '';
    String cvv = '';
    String bankAccount = '';
    String paypalEmail = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                'Choose Payment Method',
                style: TextStyle(color: primaryColor),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Payment Method',
                        labelStyle: TextStyle(color: primaryColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Credit Card',
                          child: Text('Credit Card'),
                        ),
                        DropdownMenuItem(
                          value: 'Authorization Code',
                          child: Text('Authorization Code'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please choose a payment method';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    if (paymentMethod == 'Credit Card') ...[
                      _buildTextField('Card Number', primaryColor, (value) {
                        cardNumber = value;
                      }),
                      const SizedBox(height: 10),
                      _buildTextField('Expiry Date (MM/YY)', primaryColor,
                          (value) {
                        expiryDate = value;
                      }),
                      const SizedBox(height: 10),
                      _buildTextField('CVV', primaryColor, (value) {
                        cvv = value;
                      }),
                    ] else if (paymentMethod == 'Authorization Code') ...[
                      _buildTextField('Authorization Code', primaryColor,
                          (value) {
                        bankAccount = value;
                      }),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      _showConfirmationPage(
                        context,
                        paymentMethod,
                        cardNumber,
                        expiryDate,
                        cvv,
                        bankAccount,
                        paypalEmail,
                      );
                    }
                  },
                  child: const Text('Pay'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
      String label, Color primaryColor, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  void _showConfirmationPage(
    BuildContext context,
    String paymentMethod,
    String cardNumber,
    String expiryDate,
    String cvv,
    String authorizationCode,
    String paypalEmail,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSummaryPage(
          paymentMethod: paymentMethod,
          cardNumber: paymentMethod == 'Credit Card' ? cardNumber : null,
          expiryDate: paymentMethod == 'Credit Card' ? expiryDate : null,
          cvv: paymentMethod == 'Credit Card' ? cvv : null,
          authCode:
              paymentMethod == 'Authorization Code' ? authorizationCode : null,
          // paypalEmail: paymentMethod == 'PayPal' ? paypalEmail : null,
        ),
      ),
    );
  }
}
