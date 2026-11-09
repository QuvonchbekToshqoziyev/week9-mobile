import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'setstate/cart_page_setstate.dart';
import 'riverpod/cart_page_riverpod.dart';
import 'cubit/cart_page_cubit.dart';
import 'bloc/cart_page_bloc.dart';

void main() => runApp(const ProviderScope(child: CartApp()));

class CartApp extends StatelessWidget {
  const CartApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'One Cart, Four Ways',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const HomePage(),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('One Cart, Four Ways')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            FilledButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SetStateCartPage())),
              child: const Text('setState cart'),
            ),
            FilledButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RiverpodCartPage())),
              child: const Text('Riverpod cart'),
            ),
            FilledButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CubitCartPage())),
              child: const Text('Cubit cart'),
            ),
            FilledButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BlocCartPage())),
              child: const Text('Bloc cart'),
            ),
          ],
        ),
      );
}
