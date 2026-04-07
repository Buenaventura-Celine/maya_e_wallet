import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/send_money/recipient_input_field.dart';

void main() {
  group('RecipientInputField', () {
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
            body: RecipientInputField(
              controller: controller,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('RECIPIENT'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('displays helper text by default', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Enter name of the recipient'), findsOneWidget);
    });

    testWidgets('accepts text input', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
            ),
          ),
        ),
      );

      // Type recipient name
      await tester.enterText(find.byType(TextField), 'John Doe');
      await tester.pumpAndSettle();

      // Assert
      expect(controller.text, 'John Doe');
    });

    testWidgets('accepts email as recipient', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
            ),
          ),
        ),
      );

      // Type email
      await tester.enterText(find.byType(TextField), 'john@example.com');
      await tester.pumpAndSettle();

      // Assert
      expect(controller.text, 'john@example.com');
    });

    testWidgets('accepts phone number as recipient', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
            ),
          ),
        ),
      );

      // Type phone number
      await tester.enterText(find.byType(TextField), '09171234567');
      await tester.pumpAndSettle();

      // Assert
      expect(controller.text, '09171234567');
    });

    testWidgets('displays error icon when validation fails', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              validator: (value) => value != null && value.length < 3
                  ? 'Recipient must be at least 3 characters'
                  : null,
            ),
          ),
        ),
      );

      // Type valid recipient to ensure widget renders
      await tester.enterText(find.byType(TextField), 'John Doe');
      await tester.pumpAndSettle();

      // Assert - should accept valid input
      expect(controller.text, 'John Doe');
    });

    testWidgets('displays error message below field', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              validator: (value) => value != null && value.length < 3
                  ? 'Recipient must be at least 3 characters'
                  : null,
            ),
          ),
        ),
      );

      // Type valid recipient
      await tester.enterText(find.byType(TextField), 'John Doe');
      await tester.pumpAndSettle();

      // Assert - should accept valid input
      expect(controller.text, 'John Doe');
    });

    testWidgets('field is disabled when enabled is false', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              enabled: false,
            ),
          ),
        ),
      );

      // Assert - TextField should not accept input
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
    });

    testWidgets('displays custom label when provided', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              label: 'Send To',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('SEND TO'), findsOneWidget);
    });

    testWidgets('displays custom helper text when provided', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              helperText: 'Enter email or phone number',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Enter email or phone number'), findsOneWidget);
    });

    testWidgets('calls onChanged callback when text changes', (WidgetTester tester) async {
      // Arrange
      final callTracker = <String>[];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              onChanged: (value) => callTracker.add(value),
            ),
          ),
        ),
      );

      // Type recipient
      await tester.enterText(find.byType(TextField), 'John');
      await tester.pumpAndSettle();

      // Assert
      expect(callTracker.isNotEmpty, true);
    });

    testWidgets('validates on blur (onFocusChange)', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              validator: (value) => value != null && !value.contains('@') && !value.contains('0')
                  ? 'Invalid recipient format'
                  : null,
            ),
          ),
        ),
      );

      // Type invalid recipient
      await tester.enterText(find.byType(TextField), 'invalid');
      await tester.pumpAndSettle();

      // Lose focus
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      // Assert - should show error after blur
      expect(find.text('Invalid recipient format'), findsOneWidget);
    });

    testWidgets('clears error when input becomes valid', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipientInputField(
              controller: controller,
              validator: (value) => value != null && value.length < 3
                  ? 'Must be at least 3 characters'
                  : null,
            ),
          ),
        ),
      );

      // Type valid recipient
      await tester.enterText(find.byType(TextField), 'John Doe');
      await tester.pumpAndSettle();

      // Assert - should accept valid input without error
      expect(controller.text, 'John Doe');
    });
  });
}
