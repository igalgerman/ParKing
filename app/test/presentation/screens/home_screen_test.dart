import 'package:app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen shows provider and seeker buttons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.byKey(const Key('provider_btn')), findsOneWidget);
    expect(find.byKey(const Key('seeker_btn')), findsOneWidget);
    expect(find.text("I'm a Provider"), findsOneWidget);
    expect(find.text("I'm a Seeker"), findsOneWidget);
  });
}
