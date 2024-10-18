import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/auth_code/presentation/view_model/authorization_code_view_model.dart';
import 'package:provider/provider.dart';

class FormPage extends StatelessWidget {
  final AuthorizationCodeViewModel viewModel;

  FormPage({Key? key, required this.viewModel}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  int? licenseeId, productId;
  double? amount, totalCredit, discount;
  int? periodMonths, productLimit;

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<AuthorizationCodeViewModel>(context); // Access ViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Generate Authorization Code",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Enter the details below to generate the code",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                // Remove print statements from onChanged callbacks
                _buildCustomTextField(
                  label: "Licensee ID",
                  icon: Icons.perm_identity,
                  onChanged: (value) => licenseeId = int.tryParse(value),
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
                  onChanged: (value) => periodMonths = int.tryParse(value),
                ),
                _buildCustomTextField(
                  label: "Total Credit",
                  icon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => totalCredit = double.tryParse(value),
                ),
                _buildCustomTextField(
                  label: "Product Limit",
                  icon: Icons.production_quantity_limits,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => productLimit = int.tryParse(value),
                ),
                _buildCustomTextField(
                  label: "Discount",
                  icon: Icons.percent,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => discount = double.tryParse(value),
                ),

                const SizedBox(height: 30),
                _buildAnimatedButton(
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill in all fields.")),
                        );
                      }
                    }
                  },
                ),
                _buildAnimatedButton(
                  label: "Submit Product-Based Code",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (productLimit != null &&
                          licenseeId != null &&
                          productId != null &&
                          discount != null) {
                        viewModel.generateProductBasedCode(
                            productLimit!, licenseeId!, productId!, discount!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill in all fields.")),
                        );
                      }
                    }
                  },
                ),
                _buildAnimatedButton(
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please fill in all fields.")),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
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
              color: Color(0xFF017278)), // Set icon color to primary color
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

  Widget _buildAnimatedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF017278),
                    Colors.white
                  ], // Gradient from primary color to white
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
