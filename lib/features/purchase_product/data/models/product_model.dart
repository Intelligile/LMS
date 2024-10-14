// lib/data/models/product_model.dart

import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({required super.id, required super.name, required super.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
