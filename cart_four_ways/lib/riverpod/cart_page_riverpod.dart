 ads
 simport 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cart_body.dart';
import '../models/cart.dart';
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
    ref.listen(cartProvider, (previous, next) {
      debugPrint(
          'Riverpod state changed: ${previous?.coupon} -> ${next.coupon}');
    });
    ref.listen(cartProvider.select((state) => state.status), (previous, next) {
      final current = ref.read(cartProvider);
      if (next == CheckoutStatus.success && current.orderId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order ${current.orderId} placed')),
        );
      } else if (next == CheckoutStatus.failure) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(current.checkoutError ?? 'Checkout failed'),
            actions: [
              TextButton(
                  onPressed:
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner,
                  child: const Text('Dismiss'))
            ],
          ),
        );
      }
    });
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
              onCheckout: cart.checkout,
              checkoutStatus: state.status,
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
    debugPrint('Riverpod summary rebuilt: total=$total');
    return CartSummary(state: state, total: total);
  }
}
