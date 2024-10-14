import '../entities/cart_item.dart';
import '../entities/product.dart';

class AddProductToCart {
  void call(List<CartItem> cartItems, Product product, int quantity) {
    final existingItem = cartItems.firstWhere(
      (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: quantity),
    );

    if (existingItem.quantity == quantity) {
      cartItems.add(existingItem);
    } else {
      existingItem.quantity += quantity;
    }
  }
}
