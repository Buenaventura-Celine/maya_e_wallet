import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String type; // 'send' or 'cashIn'
  final double amount;
  final String recipient; // recipient name for send, transaction method for cash in
  final DateTime dateTime;
  final String status; // 'completed' or 'pending'

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    required this.recipient,
    required this.dateTime,
    required this.status,
  });

  @override
  List<Object?> get props => [id, type, amount, recipient, dateTime, status];
}
