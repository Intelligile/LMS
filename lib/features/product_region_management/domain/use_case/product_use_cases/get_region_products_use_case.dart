import 'package:dartz/dartz.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/product_region_management/data/models/product_model.dart';
import 'package:lms/features/product_region_management/domain/repos/product_repository.dart';

class GetRegionProductsUseCase {
  final RegionProductRepository productRepository;
  GetRegionProductsUseCase({
    required this.productRepository,
  });

  Future<Either<Failure, List<RegionProductModel>>> call(
      {required int regionId}) async {
    return await productRepository.getRegionProducts(regionId: regionId);
  }
}
