import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/presentation/widgets/transaction_list_item.dart';

void main() {
  group('TransactionListItem', () {
    Widget createWidgetUnderTest(TransactionEntity transaction) {
      return MaterialApp(
        home: Scaffold(
          body: TransactionListItem(transaction: transaction),
        ),
      );
    }

    testWidgets('displays recipient name as title', (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('displays send transaction with upward arrow icon',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('displays cashIn transaction with downward arrow icon',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'cashIn',
        amount: 1000.0,
        recipient: 'bank',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('displays send amount with minus sign', (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('-₱500.00'), findsOneWidget);
    });

    testWidgets('displays cashIn amount with plus sign',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'cashIn',
        amount: 1000.0,
        recipient: 'bank',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('+₱1000.00'), findsOneWidget);
    });

    testWidgets('displays formatted date time in subtitle',
        (WidgetTester tester) async {
      // Arrange
      final today = DateTime.now();
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(today.year, today.month, today.day, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      // Verify that formatted time text is displayed (Today at HH:MM AM/PM)
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data != null &&
              widget.data!.contains('Today at'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays card widget', (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays list tile with all components',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('displays correct amount formatting for different amounts',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 1234.56,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('-₱1234.56'), findsOneWidget);
    });

    testWidgets('displays correct amount with single decimal',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'cashIn',
        amount: 100.5,
        recipient: 'bank',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('+₱100.50'), findsOneWidget);
    });

    testWidgets('displays send transaction with red/error color icon',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      final circleAvatar = find.byType(CircleAvatar);
      expect(circleAvatar, findsOneWidget);
      // Icon should be present in the CircleAvatar
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('displays cashIn transaction with green color icon',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'cashIn',
        amount: 1000.0,
        recipient: 'bank',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      final circleAvatar = find.byType(CircleAvatar);
      expect(circleAvatar, findsOneWidget);
      // Icon should be present in the CircleAvatar
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('handles long recipient names properly',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 500.0,
        recipient: 'John David Michael Johnson Smith',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('John David Michael Johnson Smith'), findsOneWidget);
    });

    testWidgets('displays zero amount with correct formatting',
        (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'send',
        amount: 0.0,
        recipient: 'John Doe',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('-₱0.00'), findsOneWidget);
    });

    testWidgets('displays large amounts correctly', (WidgetTester tester) async {
      // Arrange
      final transaction = TransactionEntity(
        id: '1',
        type: 'cashIn',
        amount: 99999.99,
        recipient: 'bank',
        dateTime: DateTime(2024, 12, 20, 10, 30, 0),
        status: 'completed',
      );

      // Act
      await tester.pumpWidget(createWidgetUnderTest(transaction));

      // Assert
      expect(find.text('+₱99999.99'), findsOneWidget);
    });
  });
}
