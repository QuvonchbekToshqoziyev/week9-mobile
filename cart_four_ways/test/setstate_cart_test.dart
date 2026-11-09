import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cart_four_ways/setstate/cart_page_setstate.dart';

void main() {
  testWidgets('applies SAVE10 to two keyboards', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SetStateCartPage()));

    await tester.tap(find.text('Keyboard · 49'));
    await tester.tap(find.text('Keyboard · 49'));
    await tester.enterText(find.byKey(const Key('coupon-field')), 'SAVE10');
    await tester.tap(find.byKey(const Key('apply-coupon')));
    await tester.pump();

    expect(find.text('88.20'), findsOneWidget);
  });
}
