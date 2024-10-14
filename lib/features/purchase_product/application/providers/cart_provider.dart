import 'package:flutter/material.dart';
import 'package:lms/features/purchase_product/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get cartItems => _items;

  double get totalAmount {
    return _items.fold(
        0.0, (sum, item) => sum + item.product.price * item.quantity);
  }

  void addProduct(Product product, int quantity) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  // Single updateProductQuantity method
  void updateProductQuantity(Product product, int quantity) {
    final existingIndex =
        _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0 && quantity > 0) {
      _items[existingIndex].quantity = quantity;
    } else if (quantity == 0) {
      removeProduct(product);
    }

    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
