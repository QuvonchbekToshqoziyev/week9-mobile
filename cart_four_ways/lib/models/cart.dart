enum CheckoutStatus { idle, submitting, success, failure }

class Product {
  const Product({required this.id, required this.name, required this.price});
  final String id;
  final String name;
  final double price;
}

const catalog = [
  Product(id: 'p1', name: 'Keyboard', price: 49),
  Product(id: 'p2', name: 'Mouse', price: 25),
  Product(id: 'p3', name: 'Monitor', price: 199),
];

class CartLine {
  const CartLine({required this.product, required this.qty});
  final Product product;
  final int qty;
  double get subtotal => product.price * qty;
  CartLine copyWith({int? qty}) =>
      CartLine(product: product, qty: qty ?? this.qty);
}

extension CartLines on List<CartLine> {
  List<CartLine> withProduct(Product product) {
    final index = indexWhere((line) => line.product.id == product.id);
    if (index == -1) return [...this, CartLine(product: product, qty: 1)];
    return [
      for (final line in this)
        line.product.id == product.id
            ? line.copyWith(qty: line.qty + 1)
            : line,
    ];
  }

  List<CartLine> without(String productId) =>
      [for (final line in this) if (line.product.id != productId) line];

  List<CartLine> changeQty(String productId, int delta) => [
        for (final line in this)
          if (line.product.id == productId && line.qty + delta > 0)
            line.copyWith(qty: line.qty + delta)
          else if (line.product.id != productId) line,
      ];

  double get subtotal => fold(0, (sum, line) => sum + line.subtotal);
  int get itemCount => fold(0, (sum, line) => sum + line.qty);
}

class CartState {
  const CartState({
    this.lines = const [],
    this.coupon = '',
    this.couponError,
    this.status = CheckoutStatus.idle,
    this.orderId,
    this.checkoutError,
  });

  final List<CartLine> lines;
  final String coupon;
  final String? couponError;
  final CheckoutStatus status;
  final String? orderId;
  final String? checkoutError;

  double get subtotal => lines.subtotal;
  int get itemCount => lines.itemCount;
  double get discount => coupon == 'SAVE10' ? subtotal * .1 : 0;
  double get total => subtotal - discount;

  CartState copyWith({
    List<CartLine>? lines,
    String? coupon,
    Object? couponError = _unset,
    CheckoutStatus? status,
    Object? orderId = _unset,
    Object? checkoutError = _unset,
  }) =>
      CartState(
        lines: lines ?? this.lines,
        coupon: coupon ?? this.coupon,
        couponError: identical(couponError, _unset) ? this.couponError : couponError as String?,
        status: status ?? this.status,
        orderId: identical(orderId, _unset) ? this.orderId : orderId as String?,
        checkoutError: identical(checkoutError, _unset)
            ? this.checkoutError
            : checkoutError as String?,
      );

  @override
  bool operator ==(Object other) =>
      other is CartState &&
      other.coupon == coupon &&
      other.couponError == couponError &&
      other.status == status &&
      other.orderId == orderId &&
      other.checkoutError == checkoutError &&
      other.lines.length == lines.length &&
      _sameLines(other.lines);

  bool _sameLines(List<CartLine> other) => [
        for (var i = 0; i < lines.length; i++)
          lines[i].product.id == other[i].product.id && lines[i].qty == other[i].qty,
      ].every((value) => value);

  @override
  int get hashCode => Object.hash(
        coupon,
        couponError,
        status,
        orderId,
        checkoutError,
        Object.hashAll(lines.map((line) => Object.hash(line.product.id, line.qty))),
      );
}

const _unset = Object();
