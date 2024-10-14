import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/functions/show_snack_bar.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/presentation/manager/authoriy_cubit/authority_cubit.dart';

class AddNewRoleViewBody extends StatefulWidget {
  const AddNewRoleViewBody({super.key});

  @override
  _AddNewRoleViewBodyState createState() => _AddNewRoleViewBodyState();
}

class _AddNewRoleViewBodyState extends State<AddNewRoleViewBody> {
  final TextEditingController _roleController = TextEditingController();
  final List<Authority> _roles = [];

  void _addRole() {
    final roleName = _roleController.text.trim();
    if (roleName.isNotEmpty) {
      setState(() {
        _roles.add(Authority(
            authority: roleName,
            description: '',
            id: 1,
            permissionIds: [],
            userIds: []));
      });
      _roleController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Bulk Roles',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _roleController,
            decoration: InputDecoration(
              labelText: 'Role Name',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addRole,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _roles.length,
              itemBuilder: (context, index) {
                final role = _roles[index];
                return ListTile(
                  title: Text(role.authority!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _roles.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          BlocConsumer<AuthorityCubit, AuthorityState>(
            listener: (context, state) {
              if (state is AuthorityStateFailure) {
                showSnackBar(context, state.errorMessage, Colors.red);
              } else if (state is AddAuthorityStateSuccess) {
                showSnackBar(
                    context,
                    '${_roles.length} authorities added successfully',
                    Colors.green);
              }
            },
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () async {
                  for (Authority role in _roles) {
                    print(role.authority);
                  }
                  await context.read<AuthorityCubit>().addAuthorities(_roles);
                },
                child: const Text('Add Roles'),
              );
            },
          ),
        ],
      ),
    );
  }
}
