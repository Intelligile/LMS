// lib/domain/repositories/cart_repository.dart

import 'package:lms/features/purchase_product/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<void> addToCart(CartItem cartItem);
  Future<void> checkout();
}
