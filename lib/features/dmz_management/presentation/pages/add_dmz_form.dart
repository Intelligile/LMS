import 'package:flutter/material.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/dmz_management/data/models/dmz_model.dart';
import 'package:lms/features/dmz_management/domain/use_cases/add_dmz.dart';

class AddDMZForm extends StatefulWidget {
  final AddDMZAccount addDMZUseCase; // Inject the use case

  const AddDMZForm({super.key, required this.addDMZUseCase});

  @override
  _AddDMZFormState createState() => _AddDMZFormState();
}

class _AddDMZFormState extends State<AddDMZForm> {
  final _formKey = GlobalKey<FormState>();
  final List<DMZModel> _dmzAccounts = [];

  @override
  void initState() {
    super.initState();
    _addNewDMZAccount();
  }

  void _addNewDMZAccount() {
    _dmzAccounts.add(DMZModel(
      dmzId: 0,
      uniqueId: _generateUniqueId(),
      dmzOrganization: '',
      dmzCountry: '',
      password: '', // Initialize password field
    ));
  }

  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String result = await widget.addDMZUseCase.call(_dmzAccounts);
        showSnackBar(context, result,
            result.contains('successfully') ? Colors.green : Colors.red);
      } catch (e) {
        showSnackBar(context, "Failed to add DMZ accounts: $e", Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF017278), // LMS color
        title: const Text('Add DMZ Accounts',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: _dmzAccounts.length,
            itemBuilder: (context, index) {
              return _buildDMZForm(index);
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFF017278), // LMS color
            onPressed: () {
              setState(_addNewDMZAccount);
            },
            tooltip: 'Add Another DMZ Account',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: const Color(0xFF017278), // LMS color
            onPressed: _submitForm,
            tooltip: 'Submit DMZ Accounts',
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  Widget _buildDMZForm(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(
              label: 'DMZ Organization',
              initialValue: _dmzAccounts[index].dmzOrganization,
              onSaved: (value) => _dmzAccounts[index].dmzOrganization = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an organization' : null,
            ),
            _buildInputField(
              label: 'DMZ Country',
              initialValue: _dmzAccounts[index].dmzCountry,
              onSaved: (value) => _dmzAccounts[index].dmzCountry = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a country' : null,
            ),
            _buildInputField(
              label: 'Password',
              initialValue: _dmzAccounts[index].password,
              onSaved: (value) => _dmzAccounts[index].password = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a password' : null,
              obscureText: true,
            ),
            Text(
              'Unique ID: ${_dmzAccounts[index].uniqueId}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF017278)), // LMS color
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF017278)), // LMS color
          ),
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
