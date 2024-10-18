import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/domain/repos/product_repository.dart';

class GetRegionProductUseCase {
  final RegionProductRepository productRepository;
  GetRegionProductUseCase({
    required this.productRepository,
  });

  Future<Either<Failure, RegionProductModel>> call(
      {required int productId}) async {
    return await productRepository.getProduct(productId: productId);
  }
}
