import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/domain/repos/region_repository.dart';

class AddRegionUseCase {
  final RegionRepository regionRepository;
  AddRegionUseCase({
    required this.regionRepository,
  });

  Future<Either<Failure, Unit>> call(
      {required List<RegionModel> regions}) async {
    return await regionRepository.addRegion(regions: regions);
  }
}
