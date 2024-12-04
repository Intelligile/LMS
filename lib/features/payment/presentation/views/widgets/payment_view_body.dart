import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/styles.dart';
import 'package:lms/core/widgets/custom_button.dart';
import 'package:lms/core/widgets/custom_text_field.dart';
import 'package:lms/features/home/presentation/views/widgets/custom_app_bar.dart';

class PaymentViewBody extends StatelessWidget {
  const PaymentViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomAppBar(
            username: '',
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Center(
                  child: SizedBox(
                    width: 450,
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Card(
                      elevation: 15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const CardTitle(),
                          CustomTextField(label: 'Email'),
                          CustomTextField(
                            hint: '1234 1234 1234 1234',
                            label: 'Card information',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextField(
                                textFieldSize: 190,
                                hint: 'MM / YY',
                              ),
                              CustomTextField(
                                textFieldSize: 190,
                                hint: 'CVC',
                              ),
                            ],
                          ),
                          CustomTextField(
                            label: 'Name on card',
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 400,
                                child: DropDownMenu(),
                              ),
                            ],
                          ),
                          CustomTextField(
                            label: 'Postal code',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: CustomButton(
                              buttonName: 'Pay',
                              color: const Color(0xff0175d3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container()), // Empty container to balance the layout
            ],
          ),
        ],
      ),
    );
  }
}

class CardTitle extends StatelessWidget {
  const CardTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 22),
        Text(
          'Pay with card',
          style: Styles.textStyle20,
        ),
      ],
    );
  }
}

class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        style: Styles.textStyle16,
        underline: const Text(''),
        focusColor: Colors.transparent,
        hint: const Text('Country or region'),
        isExpanded: true,
        items: const [
          DropdownMenuItem(
            alignment: Alignment.bottomCenter,
            value: 'item1',
            child: Text('item1'),
          ),
          DropdownMenuItem(
            alignment: Alignment.bottomCenter,
            value: 'item2',
            child: Text('item2'),
          ),
          DropdownMenuItem(
            alignment: Alignment.bottomCenter,
            value: 'item3',
            child: Text('item3'),
          ),
        ],
        onChanged: (value) {},
        menuMaxHeight: 300,
      ),
    );
  }
}
