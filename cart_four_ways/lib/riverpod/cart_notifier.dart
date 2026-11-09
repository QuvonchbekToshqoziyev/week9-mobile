import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';

class CartNotifier extends Notifier<CartState> {
  final _history = <CartState>[];
  @override
  CartState build() => const CartState();
  void _set(CartState next) {
    _history.add(state);
    state = next;
  }
  void add(Product product) => _set(state.copyWith(lines: state.lines.withProduct(product)));
  void remove(String id) => _set(state.copyWith(lines: state.lines.without(id)));
  void changeQty(String id, int delta) => _set(state.copyWith(lines: state.lines.changeQty(id, delta)));
  void applyCoupon(String code) => _set(state.copyWith(
        coupon: code,
        couponError: code == 'SAVE10' ? null : 'Invalid coupon',
      ));
  void undo() {
    if (_history.isNotEmpty) state = _history.removeLast();
  }
  bool get canUndo => _history.isNotEmpty;
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);
final canUndoProvider = Provider((ref) => ref.watch(cartProvider.notifier).canUndo);
