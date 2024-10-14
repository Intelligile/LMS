// lib/data/repositories/product_repository.dart

import '../../domain/entities/product.dart';

class ProductRepository {
  // Mock data source
  List<Product> getProducts() {
    return [
      Product(id: 1, name: 'Product 1', price: 29.99),
      Product(id: 2, name: 'Product 2', price: 49.99),
      Product(id: 3, name: 'Product 3', price: 19.99),
    ];
  }
}
