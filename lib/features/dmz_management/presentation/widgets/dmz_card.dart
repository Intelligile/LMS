import 'package:flutter/material.dart';
import 'package:lms/features/dmz_management/data/models/dmz_model.dart';

class DMZCard extends StatelessWidget {
  final DMZModel dmz;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DMZCard({
    super.key,
    required this.dmz,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dmz.dmzOrganization,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                      tooltip: 'Edit DMZ Account',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                      tooltip: 'Delete DMZ Account',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Unique ID: ${dmz.uniqueId}"),
            Text("Organization: ${dmz.dmzOrganization}"),
            Text("Country: ${dmz.dmzCountry}"),
          ],
        ),
      ),
    );
  }
}
