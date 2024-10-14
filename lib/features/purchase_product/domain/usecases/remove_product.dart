// lib/domain/use_cases/remove_product_from_cart.dart

import '../entities/cart_item.dart';

class RemoveProductFromCart {
  void call(List<CartItem> cartItems, int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }
}
