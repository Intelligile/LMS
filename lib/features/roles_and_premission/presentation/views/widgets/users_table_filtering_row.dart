import 'package:flutter/material.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/custom_filtering_drop_down_options.dart';
import 'package:lms/features/roles_and_premission/presentation/views/widgets/custom_search_bar.dart';

class UsersTableFilteringRow extends StatelessWidget {
  const UsersTableFilteringRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomDropDownButton(label: 'Show', value: 'All')),
                FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomDropDownButton(label: 'Role', value: 'All')),
                Expanded(child: CustomSearchBar()),
              ],
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
