import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/domain/repos/region_repository.dart';

class UpdateRegionUseCase {
  final RegionRepository regionRepository;
  UpdateRegionUseCase({
    required this.regionRepository,
  });

  Future<Either<Failure, Unit>> call({required RegionModel region}) async {
    return await regionRepository.updateRegion(region: region);
  }
}
