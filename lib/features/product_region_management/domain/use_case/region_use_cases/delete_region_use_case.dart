import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/domain/repos/region_repository.dart';

class DeleteRegionUseCase {
  final RegionRepository regionRepository;
  DeleteRegionUseCase({
    required this.regionRepository,
  });

  Future<Either<Failure, Unit>> call({required int regionId}) async {
    return await regionRepository.deleteRegion(regionId: regionId);
  }
}
