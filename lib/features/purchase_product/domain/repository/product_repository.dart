// lib/domain/repositories/product_repository.dart

import 'package:lms/features/purchase_product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
