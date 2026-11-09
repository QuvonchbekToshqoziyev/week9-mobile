import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';

class SetStateCartPage extends StatefulWidget {
  const SetStateCartPage({super.key});
  @override
  State<SetStateCartPage> createState() => _SetStateCartPageState();
}

class _SetStateCartPageState extends State<SetStateCartPage> {
  CartState _state = const CartState();
  final _coupon = TextEditingController();
  final _history = <CartState>[];
  final _api = CheckoutApi();

  void _mutate(CartState next) => setState(() {
        _history.add(_state);
        _state = next.copyWith(canUndo: true);
      });

  void _applyCoupon(String code) => _mutate(
        _state.copyWith(coupon: code, couponError: code == 'SAVE10' ? null : 'Invalid coupon'),
      );

  Future<void> _checkout() async {
    setState(() => _state = _state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await _api.submit(_state.total);
      if (!mounted) return;
      setState(() => _state = CartState(
            status: CheckoutStatus.success,
            orderId: orderId,
          ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order $orderId placed')));
    } on CheckoutException catch (error) {
      if (!mounted) return;
      setState(() => _state = _state.copyWith(
            status: CheckoutStatus.failure,
            checkoutError: error.message,
          ));
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(error.message),
          actions: [TextButton(onPressed: ScaffoldMessenger.of(context).hideCurrentMaterialBanner, child: const Text('Dismiss'))],
        ),
      );
    }
  }

  @override
  void dispose() {
    _coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Cart · setState'),
          actions: [
            IconButton(
              tooltip: 'Undo',
              onPressed: _history.isEmpty ? null : () => setState(() => _state = _history.removeLast()),
              icon: const Icon(Icons.undo),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: CartBody(
                state: _state,
                couponController: _coupon,
                onAdd: (p) => _mutate(_state.copyWith(lines: _state.lines.withProduct(p))),
                onRemove: (id) => _mutate(_state.copyWith(lines: _state.lines.without(id))),
                onQtyChanged: (id, delta) => _mutate(_state.copyWith(lines: _state.lines.changeQty(id, delta))),
                onApplyCoupon: _applyCoupon,
                onCheckout: _checkout,
                checkoutStatus: _state.status,
              ),
            ),
            CartSummary(state: _state),
          ],
        ),
      );
}
