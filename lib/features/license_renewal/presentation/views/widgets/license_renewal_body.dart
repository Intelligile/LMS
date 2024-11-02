import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms/core/functions/get_responsive_font_size.dart';
import 'package:lms/core/utils/app_router.dart';
import 'package:lms/core/widgets/custom_breadcrumb.dart';
import 'package:lms/features/license_renewal/presentation/model/license_model.dart';

class LicenseRenewalBody extends StatelessWidget {
  const LicenseRenewalBody({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CustomBreadcrumb(
            items: const ['Home', 'Manage purchased proudcts'],
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
        const SizedBox(height: 16), // Add spacing between breadcrumb and table
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: DataTable(
              columns: [
                buildDataColumn(context, columnName: 'License Name'),
                buildDataColumn(context, columnName: 'License Key'),
                buildDataColumn(context, columnName: 'Purchase Date'),
                buildDataColumn(context, columnName: 'Expiration Date'),
                buildDataColumn(context, columnName: 'Status'),
                buildDataColumn(context, columnName: 'License Type'),
                buildDataColumn(context, columnName: 'Cost'),
                buildDataColumn(context, columnName: 'Renewal Cost'),
                buildDataColumn(context, columnName: 'Activation Date'),
                buildDataColumn(context, columnName: 'Auto-Renewal Status'),
                buildDataColumn(context, columnName: 'Renew'),
              ],
              rows: licenses.map((license) {
                return DataRow(cells: [
                  buildDataCell(dataCell: license.licenseName),
                  buildDataCell(dataCell: license.licenseKey),
                  buildDataCell(
                      dataCell: license.purchaseDate.toLocal().toString()),
                  buildDataCell(
                      dataCell: license.expirationDate.toLocal().toString()),
                  buildContainerDataCell(license),
                  buildDataCell(dataCell: license.licenseType),
                  buildDataCell(
                      dataCell: '\$${license.cost.toStringAsFixed(2)}'),
                  buildDataCell(
                      dataCell: '\$${license.renewalCost.toStringAsFixed(2)}'),
                  buildDataCell(
                      dataCell: license.activationDate?.toLocal().toString() ??
                          'N/A'),
                  DataCell(
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: license.autoRenewalStatus
                            ? Colors.green
                            : Colors.red,
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
          ),
        ),
      ],
    );
  }

  DataCell buildContainerDataCell(LicenseModel license) {
    return DataCell(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: license.status == 'Active' ? Colors.green : Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(license.status),
        ),
      ),
    );
  }

  DataCell buildDataCell({required String dataCell}) {
    return DataCell(Text(dataCell));
  }

  DataColumn buildDataColumn(BuildContext context,
      {required String columnName}) {
    return DataColumn(
        label: Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          columnName,
          style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 16)),
        ),
      ),
    ));
  }
}
