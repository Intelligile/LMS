import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/domain/repos/region_repository.dart';

class GetAllRegionsUseCase {
  final RegionRepository regionRepository;
  GetAllRegionsUseCase({
    required this.regionRepository,
  });

  Future<Either<Failure, List<RegionModel>>> call() async {
    return await regionRepository.getAllRegions();
  }
}
