import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/providers/cart_provider.dart';

class PaymentSummaryPage extends StatelessWidget {
  final String paymentMethod;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final String? authCode;

  const PaymentSummaryPage({
    super.key,
    required this.paymentMethod,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.authCode,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Summary'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method: $paymentMethod',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (paymentMethod == 'Credit Card') ...[
                Text('Card Number: $cardNumber'),
                Text('Expiry Date: $expiryDate'),
                Text('CVV: $cvv'),
              ] else if (paymentMethod == 'Authorization Code') ...[
                Text('Authorization Code: $authCode'),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement the action to confirm the payment and clear the cart
                  Provider.of<CartProvider>(context, listen: false).clearCart();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
