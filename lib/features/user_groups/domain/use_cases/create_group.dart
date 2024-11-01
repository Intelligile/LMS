import '../repositories/group_repository.dart';
import '../entities/group.dart';

class CreateGroup {
  final GroupRepository repository;

  CreateGroup(this.repository);

  Future<void> execute(Group group) async {
    await repository.createGroup(group);
  }
}
