import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';

final checkoutApiProvider = Provider<CheckoutApi>((ref) => CheckoutApi());

class CartNotifier extends Notifier<CartState> {
  final _history = <CartState>[];
  @override
  CartState build() => const CartState();
  void _set(CartState next) {
    _history.add(state);
    state = next.copyWith(canUndo: true);
  }

  void add(Product product) =>
      _set(state.copyWith(lines: state.lines.withProduct(product)));
  void remove(String id) =>
      _set(state.copyWith(lines: state.lines.without(id)));
  void changeQty(String id, int delta) =>
      _set(state.copyWith(lines: state.lines.changeQty(id, delta)));
  void applyCoupon(String code) => _set(state.copyWith(
        coupon: code,
        couponError: code == 'SAVE10' ? null : 'Invalid coupon',
      ));
  void undo() {
    if (_history.isNotEmpty) {
      state = _history.removeLast().copyWith(canUndo: _history.isNotEmpty);
    }
  }

  Future<void> checkout() async {
    state = state.copyWith(status: CheckoutStatus.submitting);
    try {
      final orderId = await ref.read(checkoutApiProvider).submit(state.total);
      state = CartState(status: CheckoutStatus.success, orderId: orderId);
    } on CheckoutException catch (error) {
      state = state.copyWith(
        status: CheckoutStatus.failure,
        checkoutError: error.message,
      );
    }
  }
}

final cartProvider =
    NotifierProvider.autoDispose<CartNotifier, CartState>(CartNotifier.new);
final canUndoProvider =
    Provider((ref) => ref.watch(cartProvider.select((state) => state.canUndo)));
