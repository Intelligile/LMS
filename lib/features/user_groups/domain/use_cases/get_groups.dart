import 'package:dartz/dartz.dart';
import 'package:lms/features/user_groups/data/models/group_model.dart';
import '../../data/repositories/group_repository.dart'; // Adjust the import according to your setup
// Adjust according to your entity location
// Adjust according to your error handling location

class GetGroups {
  final GroupRepository groupRepository;

  GetGroups({required this.groupRepository});

  Future<List<GroupModel>> execute() async {
    return await groupRepository.getGroups();
  }
}
