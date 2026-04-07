import 'package:flutter/material.dart';
import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';
import 'package:maya_e_wallet/features/transaction/presentation/utils/transaction_utils.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionListItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isOutgoing = transaction.type == 'send';
    final amountColor =
        isOutgoing ? Theme.of(context).colorScheme.error : Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOutgoing
              ? Theme.of(context).colorScheme.error.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
          child: Icon(
            isOutgoing ? Icons.arrow_upward : Icons.arrow_downward,
            color: amountColor,
          ),
        ),
        title: Text(transaction.recipient),
        subtitle: Text(
          TransactionUtils.formatDateTime(transaction.dateTime),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          '${isOutgoing ? '-' : '+'}₱${transaction.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
