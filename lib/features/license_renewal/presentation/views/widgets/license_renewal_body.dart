import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/features/license_renewal/presentation/model/license_model.dart';

class LicenseRenewalBody extends StatelessWidget {
  const LicenseRenewalBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock list of LicenseModel objects
    final List<LicenseModel> licenses = [
      LicenseModel(
        licenseName: 'License 1',
        licenseKey: 'ABC123',
        purchaseDate: DateTime(2023, 1, 1),
        expirationDate: DateTime(2024, 1, 1),
        status: 'Active',
        productName: 'Product 1',
        userName: 'User 1',
        usageLimit: 10,
        renewalDate: DateTime(2024, 1, 1),
        licenseType: 'Subscription',
        licenseTerms: 'Terms 1',
        supportLevel: 'Standard',
        cost: 99.99,
        renewalCost: 49.99,
        activationDate: DateTime(2023, 1, 1),
        notes: 'Note 1',
        autoRenewalStatus: true,
      ),
      LicenseModel(
        licenseName: 'License 2',
        licenseKey: 'ABC123',
        purchaseDate: DateTime(2023, 1, 1),
        expirationDate: DateTime(2024, 1, 1),
        status: 'Expired',
        productName: 'Product 1',
        userName: 'User 1',
        usageLimit: 10,
        renewalDate: DateTime(2024, 1, 1),
        licenseType: 'Subscription',
        licenseTerms: 'Terms 1',
        supportLevel: 'Standard',
        cost: 99.99,
        renewalCost: 49.99,
        activationDate: DateTime(2023, 1, 1),
        notes: 'Note 1',
        autoRenewalStatus: false,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double tableWidth = constraints.maxWidth;
        double columnWidth = tableWidth / 17.7;

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: columnWidth / 2.4,
            columns: const [
              DataColumn(label: Text('License Name')),
              DataColumn(label: Text('License Key')),
              DataColumn(label: Text('Purchase Date')),
              DataColumn(label: Text('Expiration Date')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('License Type')),
              DataColumn(label: Text('Cost')),
              DataColumn(label: Text('Renewal Cost')),
              DataColumn(label: Text('Activation Date')),
              DataColumn(label: Text('Auto-Renewal Status')),
              DataColumn(label: Text('Renew')),
            ],
            rows: licenses.map((license) {
              return DataRow(cells: [
                DataCell(SizedBox(
                    width: columnWidth, child: Text(license.licenseName))),
                DataCell(SizedBox(
                    width: columnWidth, child: Text(license.licenseKey))),
                DataCell(SizedBox(
                    width: columnWidth + 15,
                    child: Text(license.purchaseDate.toLocal().toString()))),
                DataCell(SizedBox(
                    width: columnWidth + 15,
                    child: Text(license.expirationDate.toLocal().toString()))),
                DataCell(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: license.status == 'Active'
                          ? Colors.green
                          : Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(license.status),
                    ),
                  ),
                ),
                DataCell(SizedBox(
                    width: columnWidth + 10, child: Text(license.licenseType))),
                DataCell(SizedBox(
                    width: columnWidth - 20,
                    child: Text('\$${license.cost.toStringAsFixed(2)}'))),
                DataCell(SizedBox(
                    width: columnWidth,
                    child:
                        Text('\$${license.renewalCost.toStringAsFixed(2)}'))),
                DataCell(SizedBox(
                    width: columnWidth + 15,
                    child: Text(license.activationDate?.toLocal().toString() ??
                        'N/A'))),
                DataCell(
                  Container(
                    width: columnWidth + 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          license.autoRenewalStatus ? Colors.green : Colors.red,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          license.autoRenewalStatus ? 'Enabled' : 'Disabled'),
                    ),
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kPaymentView);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Renew'),
                      ),
                    ),
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
