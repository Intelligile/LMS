import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';

abstract class RegionProductRepository {
  Future<Either<Failure, List<RegionProductModel>>> getAllProducts();
  Future<Either<Failure, List<RegionProductModel>>> getRegionProducts(
      {required int regionId});
  Future<Either<Failure, RegionProductModel>> getProduct(
      {required int productId});
  Future<Either<Failure, Unit>> deleteProduct({required int productId});
  Future<Either<Failure, Unit>> addProduct(
      {required List<RegionProductModel> products});
  Future<Either<Failure, Unit>> updateProduct(
      {required RegionProductModel product});
}
