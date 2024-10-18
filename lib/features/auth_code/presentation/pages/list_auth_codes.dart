import 'package:flutter/material.dart';
import 'package:lms/features/auth_code/data/repositories/authorization_code_repository_impl.dart';
import 'package:lms/features/auth_code/presentation/view_model/authorization_code_view_model.dart';
import 'package:provider/provider.dart';

class AuthorizationCodePage extends StatelessWidget {
  final repository = AuthorizationCodeRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    // Wrap the entire page with the ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) => AuthorizationCodeViewModel(repository)
        ..fetchAllAuthorizationCodes(), // Initial fetch
      child: Scaffold(
        appBar: AppBar(
          title: Text('Authorization Codes'),
          backgroundColor: Color(0xFF017278),
        ),
        body: _AuthorizationCodeContent(),
      ),
    );
  }
}

class _AuthorizationCodeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController licenseeIdController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: licenseeIdController,
            decoration: const InputDecoration(
              labelText: 'Search by Licensee ID',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              final id = int.tryParse(value);
              if (id != null) {
                // Trigger the search
                Provider.of<AuthorizationCodeViewModel>(context, listen: false)
                    .searchByLicenseeId(id);
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              licenseeIdController.clear();
              Provider.of<AuthorizationCodeViewModel>(context, listen: false)
                  .resetSearch(); // Reset search and show all codes
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(
                  0xFF017278), // Set text color to white for contrast
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 20), // Add padding
              elevation: 5, // Add a slight shadow
            ),
            child: const Text(
              'Show All Codes',
              style: TextStyle(
                fontSize: 16, // Increase font size for better readability
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<AuthorizationCodeViewModel>(
              builder: (context, viewModel, child) {
                debugPrint(
                    'Rebuilding UI, loading: ${viewModel.isLoading}, count: ${viewModel.authorizationCodes.length}');
                // Show loading indicator while data is being fetched
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Show message if no authorization codes are found
                if (viewModel.authorizationCodes.isEmpty) {
                  return const Center(
                      child: Text('No authorization codes found'));
                }

                // Build the list of authorization codes
                return ListView.builder(
                  itemCount: viewModel.authorizationCodes.length,
                  itemBuilder: (context, index) {
                    final code = viewModel.authorizationCodes[index];
                    return ListTile(
                      title: Text('Code: ${code.code}'),
                      subtitle: Text('Licensee ID: ${code.licenseeId}'),
                      trailing: Text('Expires: ${code.periodEndDate}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
