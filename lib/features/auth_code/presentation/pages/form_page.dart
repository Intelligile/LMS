import 'package:flutter/material.dart';
import 'package:lms/features/auth_code/presentation/view_model/authorization_code_view_model.dart';
import 'package:provider/provider.dart';

class FormPage extends StatelessWidget {
  final AuthorizationCodeViewModel viewModel;

  FormPage({Key? key, required this.viewModel}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  String? licenseeId, productId;
  double? amount, totalCredit, discount;
  int? periodMonths, productLimit;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthorizationCodeViewModel>(
        context); // Access ViewModel here
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Authorization Code")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Licensee ID"),
                onChanged: (value) => licenseeId = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Product ID"),
                onChanged: (value) => productId = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                onChanged: (value) => amount = double.tryParse(value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Period Months"),
                keyboardType: TextInputType.number,
                onChanged: (value) => periodMonths = int.tryParse(value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Total Credit"),
                keyboardType: TextInputType.number,
                onChanged: (value) => totalCredit = double.tryParse(value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Product Limit"),
                keyboardType: TextInputType.number,
                onChanged: (value) => productLimit = int.tryParse(value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Discount"),
                keyboardType: TextInputType.number,
                onChanged: (value) => discount = double.tryParse(value),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel.generateAmountBasedCode(amount!, periodMonths!,
                        totalCredit!, licenseeId!, productId!, discount!);
                  }
                },
                child: const Text("Submit Amount-Based Code"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel.generateProductBasedCode(
                        productLimit!, licenseeId!, productId!, discount!);
                  }
                },
                child: const Text("Submit Product-Based Code"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    viewModel.generateCombinedCode(
                        amount!,
                        periodMonths!,
                        totalCredit!,
                        productLimit!,
                        licenseeId!,
                        productId!,
                        discount!);
                  }
                },
                child: const Text("Submit Combined Code"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
