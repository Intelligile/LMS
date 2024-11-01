import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/adaptive_layout_widget.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/core/widgets/custom_button.dart';
import 'package:lms/core/widgets/custom_scaffold.dart';
import 'package:lms/features/auth_code/presentation/view_model/authorization_code_view_model.dart';
import 'package:provider/provider.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access ViewModel

    return CustomScaffold(
      body: AdaptiveLayout(
        mobileLayout: (context) => const SizedBox(),
        tabletLayout: (context) => const SizedBox(),
        desktopLayout: (context) => FormPageBody(),
      ),
    );
  }
}

class FormPageBody extends StatelessWidget {
  FormPageBody({super.key});

  final _formKey = GlobalKey<FormState>();
  int? licenseeId, productId;
  double? amount, totalCredit, discount;
  int? periodMonths, productLimit;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthorizationCodeViewModel>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CustomBreadcrumb(
                  items: const ['Home', 'Generate authorization code'],
                  onTap: (index) {
                    // Add navigation logic based on index
                    if (index == 0) {
                      GoRouter.of(context).go(AppRouter.kHomeView);
                    } else if (index == 1) {
                      // Navigate to Active Users
                    }
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Generate Authorization Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter the details below to generate the code",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),
                        // Remove print statements from onChanged callbacks
                        _buildCustomTextField(
                          label: "Licensee ID",
                          icon: Icons.perm_identity,
                          onChanged: (value) =>
                              licenseeId = int.tryParse(value),
                        ),
                        _buildCustomTextField(
                          label: "Product ID",
                          icon: Icons.confirmation_num,
                          onChanged: (value) => productId = int.tryParse(value),
                        ),
                        _buildCustomTextField(
                          label: "Amount",
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => amount = double.tryParse(value),
                        ),
                        _buildCustomTextField(
                          label: "Period Months",
                          icon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              periodMonths = int.tryParse(value),
                        ),
                        _buildCustomTextField(
                          label: "Total Credit",
                          icon: Icons.credit_card,
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              totalCredit = double.tryParse(value),
                        ),
                        _buildCustomTextField(
                          label: "Product Limit",
                          icon: Icons.production_quantity_limits,
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              productLimit = int.tryParse(value),
                        ),
                        _buildCustomTextField(
                          label: "Discount",
                          icon: Icons.percent,
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              discount = double.tryParse(value),
                        ),

                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Expanded(child: SizedBox()),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  buildAnimatedButton(
                                    label: "Submit Amount-Based Code",
                                    onPressed: () {
                                      // Check for null values before calling the method
                                      if (_formKey.currentState!.validate()) {
                                        if (licenseeId != null &&
                                            productId != null &&
                                            amount != null &&
                                            periodMonths != null &&
                                            totalCredit != null &&
                                            discount != null &&
                                            productLimit != null) {
                                          // Print all the values just before submission
                                          print(
                                              "Submitting: Licensee ID: $licenseeId, Product ID: $productId, Amount: $amount, Period Months: $periodMonths, Total Credit: $totalCredit, Product Limit: $productLimit, Discount: $discount");

                                          viewModel.generateAmountBasedCode(
                                              amount!,
                                              periodMonths!,
                                              totalCredit!,
                                              licenseeId!,
                                              productId!,
                                              discount!,
                                              productLimit!);
                                          showSnackBar(
                                              context,
                                              'Authorization code generated and sent',
                                              Colors.green);
                                        } else {
                                          // Handle the case where one or more values are null
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Please fill in all fields.")),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  buildAnimatedButton(
                                    label: "Submit Product-Based Code",
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (productLimit != null &&
                                            licenseeId != null &&
                                            productId != null &&
                                            discount != null) {
                                          viewModel.generateProductBasedCode(
                                              productLimit!,
                                              licenseeId!,
                                              productId!,
                                              discount!);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Please fill in all fields.")),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  buildAnimatedButton(
                                      label: "Submit Combined Code",
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          if (amount != null &&
                                              periodMonths != null &&
                                              totalCredit != null &&
                                              productLimit != null &&
                                              licenseeId != null &&
                                              productId != null &&
                                              discount != null) {
                                            viewModel.generateCombinedCode(
                                                amount!,
                                                periodMonths!,
                                                totalCredit!,
                                                productLimit!,
                                                licenseeId!,
                                                productId!,
                                                discount!);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      "Please fill in all fields.")),
                                            );
                                          }
                                        }
                                      }),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon,
              color:
                  const Color(0xFF017278)), // Set icon color to primary color
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}
