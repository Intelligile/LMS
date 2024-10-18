import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';

abstract class RegionRepository {
  Future<Either<Failure, List<RegionModel>>> getAllRegions();
  Future<Either<Failure, RegionModel>> getRegion({required int regionId});
  Future<Either<Failure, Unit>> deleteRegion({required int regionId});
  Future<Either<Failure, Unit>> addRegion({required List<RegionModel> regions});
  Future<Either<Failure, Unit>> updateRegion({required RegionModel region});
}
