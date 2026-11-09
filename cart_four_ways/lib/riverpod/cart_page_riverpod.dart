import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cart_body.dart';
import 'cart_notifier.dart';

class RiverpodCartPage extends ConsumerStatefulWidget {
  const RiverpodCartPage({super.key});
  @override
  ConsumerState<RiverpodCartPage> createState() => _RiverpodCartPageState();
}

class _RiverpodCartPageState extends ConsumerState<RiverpodCartPage> {
  final _coupon = TextEditingController();
  @override
  void dispose() {
    _coupon.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart · Riverpod')),
      body: Column(
        children: [
          Expanded(
            child: CartBody(
              state: state,
              couponController: _coupon,
              onAdd: cart.add,
              onRemove: cart.remove,
              onQtyChanged: cart.changeQty,
              onApplyCoupon: cart.applyCoupon,
            ),
          ),
          _RiverpodSummary(),
        ],
      ),
    );
  }
}

class _RiverpodSummary extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(cartProvider.select((state) => state.total));
    final state = ref.read(cartProvider);
    return CartSummary(state: state, total: total);
  }
}
