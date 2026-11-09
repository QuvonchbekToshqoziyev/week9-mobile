import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartBody extends StatelessWidget {
  const CartBody({
    super.key,
    required this.state,
    required this.onAdd,
    required this.onRemove,
    required this.onQtyChanged,
    required this.onApplyCoupon,
    required this.couponController,
    required this.onCheckout,
    required this.checkoutStatus,
  });
  final CartState state;
  final void Function(Product) onAdd;
  final void Function(String) onRemove;
  final void Function(String, int) onQtyChanged;
  final void Function(String) onApplyCoupon;
  final TextEditingController couponController;
  final VoidCallback onCheckout;
  final CheckoutStatus checkoutStatus;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                for (final product in catalog)
                  ActionChip(
                    label: Text('${product.name} · ${product.price.toStringAsFixed(0)}'),
                    onPressed: () => onAdd(product),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    key: const Key('checkout'),
                    onPressed: checkoutStatus == CheckoutStatus.submitting ? null : onCheckout,
                    child: checkoutStatus == CheckoutStatus.submitting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Checkout'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('coupon-field'),
                    controller: couponController,
                    decoration: InputDecoration(
                      labelText: 'Coupon',
                      errorText: state.couponError,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('apply-coupon'),
                  onPressed: () => onApplyCoupon(couponController.text),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.lines.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : ListView(
                    children: [
                      for (final line in state.lines)
                        ListTile(
                          key: ValueKey(line.product.id),
                          title: Text(line.product.name),
                          subtitle: Text('× ${line.qty}'),
                          leading: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => onQtyChanged(line.product.id, -1),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => onQtyChanged(line.product.id, 1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => onRemove(line.product.id),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      );
}

class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.state, this.total});
  final CartState state;
  final double? total;

  @override
  Widget build(BuildContext context) => Card(
        key: const Key('summary-card'),
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(title: const Text('Items'), trailing: Text('${state.itemCount}')),
            ListTile(title: const Text('Subtotal'), trailing: Text(state.subtotal.toStringAsFixed(2))),
            ListTile(title: const Text('Discount'), trailing: Text(state.discount.toStringAsFixed(2))),
            ListTile(key: const Key('total'), title: const Text('Total'), trailing: Text((total ?? state.total).toStringAsFixed(2))),
          ],
        ),
      );
}
