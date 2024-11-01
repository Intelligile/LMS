import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/domain/repos/region_repository.dart';

class GetRegionUseCase {
  final RegionRepository regionRepository;
  GetRegionUseCase({
    required this.regionRepository,
  });

  Future<Either<Failure, RegionModel>> call({required int regionId}) async {
    return await regionRepository.getRegion(regionId: regionId);
  }
}
