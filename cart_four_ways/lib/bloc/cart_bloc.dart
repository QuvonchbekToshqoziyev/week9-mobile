import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, List<CartLine>> {
  CartBloc() : super(const []) {
    on<CartProductAdded>((event, emit) => emit(state.withProduct(event.product)));
    on<CartProductRemoved>((event, emit) => emit(state.without(event.productId)));
  }
}
