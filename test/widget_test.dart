import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/slide_to_confirm.dart';

void main() {
  testWidgets('SlideToConfirm renders label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: SlideToConfirm(
            text: 'SLIDE TO PAY',
            baseColor: AppTheme.primaryColor,
            onConfirmAsync: () async => true,
          ),
        ),
      ),
    );

    expect(find.text('SLIDE TO PAY'), findsOneWidget);
  });
}
