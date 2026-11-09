import '../models/cart.dart';

sealed class CartEvent {
  const CartEvent();
}

final class CartProductAdded extends CartEvent {
  const CartProductAdded(this.product);
  final Product product;
}

final class CartProductRemoved extends CartEvent {
  const CartProductRemoved(this.productId);
  final String productId;
}
