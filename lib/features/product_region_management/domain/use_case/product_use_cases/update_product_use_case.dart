import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/domain/repos/product_repository.dart';

class UpdateProductUseCase {
  final RegionProductRepository productRepository;
  UpdateProductUseCase({
    required this.productRepository,
  });

  Future<Either<Failure, Unit>> call(
      {required RegionProductModel product}) async {
    return await productRepository.updateProduct(product: product);
  }
}
