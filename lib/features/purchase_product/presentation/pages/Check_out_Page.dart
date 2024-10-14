import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lms/features/purchase_product/application/providers/cart_provider.dart';
import 'package:lms/features/purchase_product/presentation/pages/Payment_Summary_Page.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Summary of Purchase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartProvider.cartItems[index];
                return ListTile(
                  title: Text(cartItem.product.name),
                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                  trailing: Text(
                      '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showPaymentMethodDialog(context);
                  },
                  child: Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
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
              title: Text('Choose Payment Method'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Payment Method'),
                      items: [
                        DropdownMenuItem(
                          value: 'Credit Card',
                          child: Text('Credit Card'),
                        ),
                        DropdownMenuItem(
                          value: 'PayPal',
                          child: Text('PayPal'),
                        ),
                        DropdownMenuItem(
                          value: 'Bank Transfer',
                          child: Text('Bank Transfer'),
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
                    if (paymentMethod == 'Credit Card') ...[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Card Number'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          cardNumber = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter card number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                        keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          expiryDate = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter expiry date';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'CVV'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          cvv = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter CVV';
                          }
                          return null;
                        },
                      ),
                    ] else if (paymentMethod == 'PayPal') ...[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'PayPal Email'),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          paypalEmail = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter PayPal email';
                          }
                          return null;
                        },
                      ),
                    ] else if (paymentMethod == 'Bank Transfer') ...[
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Bank Account Number'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          bankAccount = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter bank account number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      _showConfirmationPage(context, paymentMethod, cardNumber,
                          expiryDate, cvv, bankAccount, paypalEmail);
                    }
                  },
                  child: Text('Pay'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showConfirmationPage(
    BuildContext context,
    String paymentMethod,
    String cardNumber,
    String expiryDate,
    String cvv,
    String bankAccount,
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
          bankAccount: paymentMethod == 'Bank Transfer' ? bankAccount : null,
          paypalEmail: paymentMethod == 'PayPal' ? paypalEmail : null,
        ),
      ),
    );
  }
}
