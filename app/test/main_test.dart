import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('displays ParKing branding', (tester) async {
      await tester.pumpWidget(const ParKingApp());

      expect(find.text('ParKing POC'), findsOneWidget);
      expect(find.text('Peer-to-Peer Parking Marketplace'), findsOneWidget);
      expect(find.byIcon(Icons.local_parking), findsOneWidget);
    });

    testWidgets('uses Material Design 3', (tester) async {
      await tester.pumpWidget(const ParKingApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
    });
  });
}
