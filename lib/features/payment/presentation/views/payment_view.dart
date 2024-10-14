import 'package:flutter/material.dart';
import 'package:lms/features/payment/presentation/views/widgets/payment_view_body.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PaymentViewBody(),
    );
  }
}
