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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              CustomDropDownButton(label: 'Show', value: 'All'),
              SizedBox(width: 16),
              CustomDropDownButton(label: 'Role', value: 'All'),
              SizedBox(width: 16),
              CustomSearchBar(),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }
}
