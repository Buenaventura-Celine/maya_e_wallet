import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/wallet/balance_card.dart';

void main() {
  group('BalanceCard', () {
    testWidgets('displays balance correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 500.00),
          ),
        ),
      );

      // Assert
      expect(find.text('Account Balance'), findsOneWidget);
      expect(find.text('₱500.00'), findsOneWidget);
    });

    testWidgets('displays balance with two decimal places', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 1250.50),
          ),
        ),
      );

      // Assert
      expect(find.text('₱1250.50'), findsOneWidget);
    });

    testWidgets('toggles balance visibility when eye icon is tapped',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 500.00),
          ),
        ),
      );

      // Initially balance should be visible
      expect(find.text('₱500.00'), findsOneWidget);

      // Tap eye icon
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Balance should now be hidden (7 asterisks for "₱500.00")
      expect(find.text('*' * 7), findsOneWidget);
      expect(find.text('₱500.00'), findsNothing);

      // Tap again to show balance
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Balance should be visible again
      expect(find.text('₱500.00'), findsOneWidget);
    });

    testWidgets('displays correct number of asterisks when hidden',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 500.00),
          ),
        ),
      );

      // Tap eye icon to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Assert - should have asterisks equal to the formatted balance length
      // "₱500.00" = 7 characters
      expect(find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == '*' * 7,
        skipOffstage: false,
      ), findsOneWidget);
    });

    testWidgets('displays visibility toggle icon', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 500.00),
          ),
        ),
      );

      // Assert - initially should show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap to hide
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Should now show visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('displays Card widget', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 500.00),
          ),
        ),
      );

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('handles zero balance correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 0.00),
          ),
        ),
      );

      // Assert
      expect(find.text('₱0.00'), findsOneWidget);
    });

    testWidgets('handles large balance correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(balance: 999999.99),
          ),
        ),
      );

      // Assert
      expect(find.text('₱999999.99'), findsOneWidget);
    });
  });
}
