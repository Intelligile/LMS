import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms/core/utils/api.dart';
import 'package:lms/features/dmz_management/data/data_sources/dmz_remote_data_source.dart';
import 'package:lms/features/dmz_management/data/models/dmz_model.dart';

import 'dmz_card.dart';

class DMZListPage extends StatefulWidget {
  final Function(DMZModel) onEditDMZ;

  const DMZListPage({super.key, required this.onEditDMZ});

  @override
  _DMZListPageState createState() => _DMZListPageState();
}

class _DMZListPageState extends State<DMZListPage> {
  late Dio dio;
  late Api api;
  late DMZManagementRemoteDataSource _dmzRemoteDataSource;
  List<DMZModel> _dmzAccounts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'));
    api = Api(dio);
    _dmzRemoteDataSource = DMZManagementRemoteDataSource(api);
    _fetchDMZAccounts();
  }

  Future<void> _fetchDMZAccounts() async {
    try {
      final dmzAccounts = await _dmzRemoteDataSource.getDMZAccounts();
      setState(() {
        _dmzAccounts = dmzAccounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Failed to fetch DMZ accounts: $e");
    }
  }

  void _onDeleteDMZ(DMZModel dmz) async {
    try {
      await _dmzRemoteDataSource.removeDMZAccount(dmz.dmzId);
      _fetchDMZAccounts(); // Refresh the list after deletion
    } catch (e) {
      print("Failed to delete DMZ account: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _dmzAccounts.length,
            itemBuilder: (context, index) {
              final dmz = _dmzAccounts[index];
              return DMZCard(
                dmz: dmz,
                onEdit: () => widget.onEditDMZ(dmz),
                onDelete: () => _onDeleteDMZ(dmz),
              );
            },
          );
  }
}
