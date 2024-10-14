import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/providers/cart_provider.dart';

class PaymentSummaryPage extends StatelessWidget {
  final String paymentMethod;
  final String? cardNumber;
  final String? expiryDate;
  final String? cvv;
  final String? bankAccount;
  final String? paypalEmail;

  const PaymentSummaryPage({
    Key? key,
    required this.paymentMethod,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.bankAccount,
    this.paypalEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method: $paymentMethod',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (paymentMethod == 'Credit Card') ...[
              Text('Card Number: $cardNumber'),
              Text('Expiry Date: $expiryDate'),
              Text('CVV: $cvv'),
            ] else if (paymentMethod == 'PayPal') ...[
              Text('PayPal Email: $paypalEmail'),
            ] else if (paymentMethod == 'Bank Transfer') ...[
              Text('Bank Account: $bankAccount'),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement the action to confirm the payment and clear the cart
                Provider.of<CartProvider>(context, listen: false).clearCart();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
