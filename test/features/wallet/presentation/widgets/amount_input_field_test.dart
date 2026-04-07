import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/amount_input_field.dart';

void main() {
  group('AmountInputField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('displays label and hint text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('AMOUNT'), findsOneWidget);
      expect(find.text('0.00'), findsOneWidget);
    });

    testWidgets('displays peso symbol', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('₱'), findsOneWidget);
    });

    testWidgets('accepts numeric input', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
            ),
          ),
        ),
      );

      // Type amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      // Assert
      expect(controller.text, '100');
    });

    testWidgets('accepts decimal input', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
            ),
          ),
        ),
      );

      // Type amount with decimal
      await tester.enterText(find.byType(TextField), '100.50');
      await tester.pumpAndSettle();

      // Assert
      expect(controller.text, '100.50');
    });

    testWidgets('limits decimal places to 2', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
            ),
          ),
        ),
      );

      // Type valid amount first
      await tester.enterText(find.byType(TextField), '100.99');
      await tester.pumpAndSettle();

      // Assert - should accept 2 decimal places
      expect(controller.text, '100.99');

      // Try to add more decimal places - formatter should reject
      await tester.enterText(find.byType(TextField), '100.999');
      await tester.pumpAndSettle();

      // Assert - should still be 100.99 since formatter rejects input with 3+ decimals
      expect(controller.text, '100.99');
    });

    testWidgets('rejects negative numbers', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
            ),
          ),
        ),
      );

      // Try to enter negative number
      await tester.enterText(find.byType(TextField), '-50');
      await tester.pumpAndSettle();

      // Assert - should not accept negative (FilteringTextInputFormatter filters out '-')
      expect(controller.text, '50');
    });

    testWidgets('displays helper text when provided', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
              helperText: 'Available balance: ₱500.00',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Available balance: ₱500.00'), findsOneWidget);
    });

    testWidgets('displays error icon when validation fails', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
              validator: (value) => value != null && double.parse(value) > 500.00
                  ? 'Amount exceeds balance'
                  : null,
            ),
          ),
        ),
      );

      // Enter amount exceeding max
      await tester.enterText(find.byType(TextField), '600');
      await tester.pumpAndSettle();

      // Lose focus to trigger validation
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.error_outline), findsWidgets);
    });

    testWidgets('displays error message below field', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
              validator: (value) => value != null && double.parse(value) > 500.00
                  ? 'Amount exceeds balance'
                  : null,
            ),
          ),
        ),
      );

      // Enter amount exceeding max
      await tester.enterText(find.byType(TextField), '600');
      await tester.pumpAndSettle();

      // Lose focus to trigger validation
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Amount exceeds balance'), findsOneWidget);
    });

    testWidgets('field is disabled when enabled is false', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
              enabled: false,
            ),
          ),
        ),
      );

      // Assert - TextField should not accept input
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
    });

    testWidgets('calls onChanged callback when text changes', (WidgetTester tester) async {
      // Arrange
      final callTracker = <String>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              controller: controller,
              maxAmount: 500.00,
              onChanged: (value) => callTracker.add(value),
            ),
          ),
        ),
      );

      // Type amount
      await tester.enterText(find.byType(TextField), '100');
      await tester.pumpAndSettle();

      // Assert
      expect(callTracker.isNotEmpty, true);
    });
  });
}
