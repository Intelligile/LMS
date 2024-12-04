// // lib/application/providers/product_provider.dart

// import 'package:flutter/material.dart';
// import 'package:lms/features/purchase_product/data/repository/product_repository.dart';
// import 'package:lms/features/purchase_product/domain/entities/product.dart';

// class ProductProvider with ChangeNotifier {
//   final ProductRepository _repository = ProductRepository();
//   List<Product> _products = [];

//   List<Product> get products => _products;

//   void loadProducts() {
//     _products = _repository.getProducts();
//     notifyListeners();
//   }
// }
