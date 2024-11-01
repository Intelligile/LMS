import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/domain/repos/product_repository.dart';

class AddProductUseCase {
  final RegionProductRepository productRepository;
  AddProductUseCase({
    required this.productRepository,
  });

  Future<Either<Failure, Unit>> call(
      {required List<RegionProductModel> products}) async {
    return await productRepository.addProduct(products: products);
  }
}
