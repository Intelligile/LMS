import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms/core/widgets/custom_button.dart';
import 'package:lms/core/widgets/custom_text_field.dart';

// Custom input formatter for credit card number
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(' ', '');
    if (digits.length > 16) digits = digits.substring(0, 16);

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i % 4 == 0 && i != 0) formatted += ' ';
      formatted += digits[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Custom input formatter for expiry date
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll('/', '');
    if (digits.length > 4) digits = digits.substring(0, 4);

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) formatted += '/';
      formatted += digits[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Custom input formatter for CVC
class CvcInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text;
    if (digits.length > 3) digits = digits.substring(0, 3);

    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

class PaymentViewBody extends StatefulWidget {
  final Function(Map<String, dynamic>)
      onBillingDataSubmitted; // Add callback parameter

  const PaymentViewBody({super.key, required this.onBillingDataSubmitted});

  @override
  State<PaymentViewBody> createState() => _PaymentViewBodyState();
}

class _PaymentViewBodyState extends State<PaymentViewBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardHolderName = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  List<String> _regions = [];

  @override
  void initState() {
    super.initState();
    _fetchRegions();
  }

  Future<void> _fetchRegions() async {
    try {
      Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8082'));
      final response = await dio.get('/api/regions');
      setState(() {
        _regions = List<String>.from(
            response.data.map((item) => item['country'] as String));
      });
    } catch (e) {
      print("Failed to load regions: $e");
    }
  }

  bool _validateEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  bool _validateCardNumber(String value) {
    final cardNumberRegex = RegExp(r'^[0-9]{16}$');
    return cardNumberRegex.hasMatch(value.replaceAll(' ', ''));
  }

  bool _validateExpiryDate(String value) {
    final dateRegex = RegExp(
        r'^(0[1-9]|1[0-2])\/([0-9]{2})$'); // Enforces strict MM/YY format
    if (!dateRegex.hasMatch(value)) return false;

    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;

    // Add 2000 to year to convert YY to YYYY format (e.g., 26 to 2026)
    final fullYear = 2000 + year;

    final now = DateTime.now();
    // Expiry date is considered valid if it's after the current month and year
    return DateTime(fullYear, month).isAfter(DateTime(now.year, now.month));
  }

  bool _validateCVC(String value) {
    final cvcRegex = RegExp(r'^[0-9]{3,4}$');
    return cvcRegex.hasMatch(value);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final billingData = {
        "creditCardNumber": _cardNumberController.text.replaceAll(' ', ''),
        "expiryDate": _expiryDateController.text,
        "cvv": _cvcController.text,
        "cardholderName": _cardHolderName.text, // Cardholder's name
        "postalCode": _postalCodeController.text,
      };

      widget.onBillingDataSubmitted(
          billingData); // Pass billing data back to ProductDetailPage
      Navigator.of(context).pop(); // Close the payment form
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 600
        ? desktopPaymentCard(context)
        : mobilePaymentCard(context);
  }

  Form desktopPaymentCard(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 6,
            child: Card(
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CardTitle(),
                  // CustomTextField(
                  //   controller: _emailController,
                  //   label: 'Email',
                  //   validator: (value) =>
                  //       _validateEmail(value!) ? null : 'Invalid email',
                  // ),
                  const SizedBox(height: 12),
                  buildCenteredRow(
                    CustomTextField(
                      controller: _cardNumberController,
                      hint: '1234 1234 1234 1234',
                      label: 'Card information',
                      validator: (value) => _validateCardNumber(value!)
                          ? null
                          : 'Invalid card number',
                      inputFormatters: [CardNumberInputFormatter()],
                      suffixIcons: const [
                        Icon(FontAwesomeIcons.paypal),
                        SizedBox(width: 5),
                        Icon(FontAwesomeIcons.googlePay),
                        SizedBox(width: 10),
                        Icon(FontAwesomeIcons.applePay),
                        SizedBox(width: 10),
                        Icon(FontAwesomeIcons.ccVisa),
                        SizedBox(width: 10),
                        Icon(FontAwesomeIcons.ccMastercard),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(flex: 2, child: SizedBox()),
                          Expanded(
                            flex: 9,
                            child: CustomTextField(
                              controller: _expiryDateController,
                              hint: 'MM / YY',
                              validator: (value) => _validateExpiryDate(value!)
                                  ? null
                                  : 'Invalid date',
                              inputFormatters: [ExpiryDateInputFormatter()],
                            ),
                          ),
                          Expanded(
                            flex: 9,
                            child: CustomTextField(
                              controller: _cvcController,
                              hint: 'CVC',
                              validator: (value) =>
                                  _validateCVC(value!) ? null : 'Invalid CVC',
                              inputFormatters: [CvcInputFormatter()],
                            ),
                          ),
                          const Expanded(flex: 2, child: SizedBox()),
                        ],
                      )),

                  buildCenteredRow(
                    CustomTextField(
                      controller: _cardHolderName,
                      label: 'Name On Card',
                    ),
                  ),
                  buildCenteredRow(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _buildRegionDropdown(),
                    ),
                  ),
                  buildCenteredRow(
                    CustomTextField(
                      controller: _postalCodeController,
                      label: 'Postal code',
                    ),
                  ),
                  buildCenteredRow(
                    buildAnimatedButton(
                      label: 'Pay',
                      onPressed: _submitForm,
                    ),
                  )
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Form mobilePaymentCard(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CardTitle(),
            // CustomTextField(
            //   controller: _emailController,
            //   label: 'Email',
            //   validator: (value) =>
            //       _validateEmail(value!) ? null : 'Invalid email',
            // ),
            const SizedBox(height: 12),
            buildCenteredRow(
              CustomTextField(
                controller: _cardNumberController,
                hint: '1234 1234 1234 1234',
                label: 'Card information',
                validator: (value) =>
                    _validateCardNumber(value!) ? null : 'Invalid card number',
                inputFormatters: [CardNumberInputFormatter()],
                suffixIcons: const [
                  Icon(FontAwesomeIcons.paypal),
                  SizedBox(width: 5),
                  Icon(FontAwesomeIcons.googlePay),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.applePay),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.ccVisa),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.ccMastercard),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox()),
                    Expanded(
                      flex: 5,
                      child: CustomTextField(
                        controller: _expiryDateController,
                        hint: 'MM / YY',
                        validator: (value) =>
                            _validateExpiryDate(value!) ? null : 'Invalid date',
                        inputFormatters: [ExpiryDateInputFormatter()],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomTextField(
                        controller: _cvcController,
                        hint: 'CVC',
                        validator: (value) =>
                            _validateCVC(value!) ? null : 'Invalid CVC',
                        inputFormatters: [CvcInputFormatter()],
                      ),
                    ),
                    const Expanded(child: SizedBox())
                  ],
                )),

            buildCenteredRow(
              CustomTextField(
                controller: _cardHolderName,
                label: 'Name On Card',
              ),
            ),
            buildCenteredRow(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _buildRegionDropdown(),
              ),
            ),
            buildCenteredRow(
              CustomTextField(
                controller: _postalCodeController,
                label: 'Postal code',
              ),
            ),
            buildCenteredRow(
              buildAnimatedButton(
                label: 'Pay',
                onPressed: _submitForm,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRegionDropdown() {
    return DropdownButtonFormField<String>(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const InputDecoration(
        labelText: 'Country or region',
        border: OutlineInputBorder(),
      ),
      items: _regions
          .map((region) => DropdownMenuItem(
                value: region,
                child: Text(region),
              ))
          .toList(),
      onChanged: (value) {},
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a region' : null,
    );
  }
}

Row buildCenteredRow(Widget child) {
  return Row(
    children: [
      const Expanded(child: SizedBox()), // First Expanded with SizedBox
      Expanded(flex: 7, child: child), // Middle Expanded with provided child
      const Expanded(child: SizedBox()), // Last Expanded with SizedBox
    ],
  );
}

class CardTitle extends StatelessWidget {
  const CardTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 22),
        Text(
          'Pay with card',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
