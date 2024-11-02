// lib/domain/use_cases/checkout.dart

import '../entities/cart_item.dart';

class Checkout {
  double call(List<CartItem> cartItems) {
    return cartItems.fold(
        0.0, (total, item) => total + item.product.price * item.quantity);
  }
}
