import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';

class BillingAccountPage extends StatefulWidget {
  const BillingAccountPage({Key? key}) : super(key: key);

  @override
  State<BillingAccountPage> createState() => _BillingAccountPageState();
}

class _BillingAccountPageState extends State<BillingAccountPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: AdaptiveLayout(
        mobileLayout: (context) => const BillingAccountPageBody(),
        tabletLayout: (context) => const BillingAccountPageBody(),
        desktopLayout: (context) =>
            const BillingAccountPageBody(isDesktop: true),
      ),
    );
  }
}

class BillingAccountPageBody extends StatelessWidget {
  final bool isDesktop;

  const BillingAccountPageBody({super.key, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 46.0, vertical: 32.0), // Adjusted padding
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop)
              CustomBreadcrumb(
                items: const ['Home', 'Billing Account'],
                onTap: (index) {
                  if (index == 0) {
                    GoRouter.of(context).go(AppRouter.kHomeView);
                  } else if (index == 1) {
                    // Navigate to Active Users
                  }
                },
              ),
            const SizedBox(height: 20), // Reduced spacing
            _buildProgressBar(),
            const SizedBox(height: 20), // Reduced spacing
            const Text(
              'Create a New Billing Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Enter your organization's details to create a new billing account.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '* Indicates a required field',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
            const SizedBox(height: 16),
            _buildForm(context),
            const SizedBox(height: 16), // Reduced spacing
            Align(
              alignment: isDesktop ? Alignment.centerRight : Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // Perform form submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF017278),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 30.0,
                  ),
                ),
                child: const Text("Next"),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Read our Privacy Statement for how your data is handled. By selecting Next, you agree to our terms and conditions in the Intelligile Customer Agreement.",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepIndicator("Account Details", true),
        _buildStepDivider(),
        _buildStepIndicator("Sign-in Details", false),
        _buildStepDivider(),
        _buildStepIndicator("Payment Setup and Finish", false),
      ],
    );
  }

  Widget _buildStepIndicator(String step, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isActive ? const Color(0xFF017278) : Colors.grey,
        ),
        const SizedBox(height: 8),
        Text(
          step,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? const Color(0xFF017278) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildTextInput("First Name *", "Enter first name")),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildTextInput("Middle Name", "Enter middle name")),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildTextInput("Last Name *", "Enter last name")),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextInput("Business Name *", "Enter business name"),
          const SizedBox(height: 10),
          _buildTextInput("Address Line 1 *", "Enter address line 1"),
          const SizedBox(height: 10),
          _buildTextInput("Address Line 2", "Enter address line 2 (optional)"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTextInput("City *", "Enter city")),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildTextInput("Postal Code *", "Enter postal code")),
            ],
          ),
          const SizedBox(height: 10),
          _buildDropdownInput("Country/Region *", [
            "Lebanon",
            "United States",
            "Canada",
            "Australia",
            "United Kingdom"
          ]),
          const SizedBox(height: 10),
          _buildTextInput(
              "Business Phone Number *", "Enter business phone number"),
        ],
      ),
    );
  }

  Widget _buildTextInput(String label, String hint) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (label.contains("*") && (value == null || value.isEmpty)) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  Widget _buildDropdownInput(String label, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: (value) {},
      validator: (value) {
        if (label.contains("*") && (value == null || value.isEmpty)) {
          return "$label is required";
        }
        return null;
      },
    );
  }
}
