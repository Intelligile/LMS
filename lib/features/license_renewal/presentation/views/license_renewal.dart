import 'package:flutter/material.dart';
import 'package:lms/features/license_renewal/presentation/views/widgets/license_renewal_body.dart';

class LicenseRenewal extends StatelessWidget {
  const LicenseRenewal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffef7ff),
      ),
      body: const SafeArea(
        child: LicenseRenewalBody(),
      ),
    );
  }
}
