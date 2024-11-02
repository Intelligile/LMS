import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/data_source/region_remote_data_source.dart';
import 'package:lms/features/product_region_management/data/models/region_model.dart';
import 'package:lms/features/product_region_management/domain/repos/region_repository.dart';

class RegionRepositoryImpl extends RegionRepository {
  final RegionRemoteDataSource regionRemoteDataSource;

  RegionRepositoryImpl({required this.regionRemoteDataSource});
  @override
  Future<Either<Failure, Unit>> addRegion(
      {required List<RegionModel> regions}) async {
    try {
      await regionRemoteDataSource.addRegion(regions: regions);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in adding  region: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRegion({required int regionId}) async {
    try {
      await regionRemoteDataSource.deleteRegion(regionId: regionId);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in adding  region: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RegionModel>>> getAllRegions() async {
    try {
      List<RegionModel> regions = await regionRemoteDataSource.getAllRegions();
      return right(regions);
    } catch (e) {
      print("Error in getting all  regions: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegionModel>> getRegion(
      {required int regionId}) async {
    try {
      RegionModel region =
          await regionRemoteDataSource.getRegion(regionId: regionId);
      return right(region); // Return Unit from dartz
    } catch (e) {
      print("Error in getting region: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRegion(
      {required RegionModel region}) async {
    try {
      await regionRemoteDataSource.updateRegion(region: region);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in updating  region: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
