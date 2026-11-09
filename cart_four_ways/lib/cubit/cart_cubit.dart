import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';

class CartCubit extends Cubit<List<CartLine>> {
  CartCubit() : super(const []);
  void add(Product product) => emit(state.withProduct(product));
  void remove(String productId) => emit(state.without(productId));
}
