import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/data_source/products_remote_data_source.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/domain/repos/product_repository.dart';

class ProductRepositoryImpl extends RegionProductRepository {
  final ProductsRemoteDataSource productsRemoteDataSource;

  ProductRepositoryImpl({
    required this.productsRemoteDataSource,
  });

  @override
  Future<Either<Failure, Unit>> deleteProduct({required int productId}) async {
    try {
      await productsRemoteDataSource.deleteProduct(productId: productId);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in deleting product: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RegionProductModel>>> getAllProducts() async {
    try {
      List<RegionProductModel> products =
          await productsRemoteDataSource.getAllProducts();
      return right(products); // Return Unit from dartz
    } catch (e) {
      print("Error in getting all products: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegionProductModel>> getProduct(
      {required int productId}) async {
    try {
      RegionProductModel product =
          await productsRemoteDataSource.getProduct(productId: productId);
      return right(product); // Return Unit from dartz
    } catch (e) {
      print("Error in getting product: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RegionProductModel>>> getRegionProducts(
      {required int regionId}) async {
    try {
      List<RegionProductModel> regionProducts =
          await productsRemoteDataSource.getRegionProducts(regionId: regionId);
      return right(regionProducts); // Return Unit from dartz
    } catch (e) {
      print("Error in getting region products: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addProduct(
      {required List<RegionProductModel> products}) async {
    try {
      await productsRemoteDataSource.addProduct(products: products);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in adding  product: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(
      {required RegionProductModel product}) async {
    try {
      await productsRemoteDataSource.updateProduct(product: product);
      return right(unit); // Return Unit from dartz
    } catch (e) {
      print("Error in updating  product: $e"); // Logging the error
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
