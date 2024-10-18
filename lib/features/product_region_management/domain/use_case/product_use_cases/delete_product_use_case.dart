import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/domain/repos/product_repository.dart';

class DeleteRegionProductUseCase {
  final RegionProductRepository productRepository;
  DeleteRegionProductUseCase({
    required this.productRepository,
  });

  Future<Either<Failure, Unit>> call({required int productId}) async {
    return await productRepository.deleteProduct(productId: productId);
  }
}
