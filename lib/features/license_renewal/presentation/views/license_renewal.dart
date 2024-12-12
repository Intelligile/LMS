import 'package:flutter/material.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/license_renewal/presentation/views/widgets/license_renewal_body.dart';

class LicenseRenewal extends StatelessWidget {
  const LicenseRenewal({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: AdaptiveLayout(
          mobileLayout: (context) => const LicenseManagementPage(),
          tabletLayout: (context) => const SizedBox(),
          desktopLayout: (context) => const LicenseManagementPage(),
        ),
      ),
    );
  }
}
