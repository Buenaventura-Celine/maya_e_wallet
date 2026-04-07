import 'package:maya_e_wallet/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.recipient,
    required super.dateTime,
    required super.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      recipient: json['recipient'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      status: json['status'] as String? ?? 'completed',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'recipient': recipient,
        'dateTime': dateTime.toIso8601String(),
        'status': status,
      };

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type,
      amount: entity.amount,
      recipient: entity.recipient,
      dateTime: entity.dateTime,
      status: entity.status,
    );
  }
}
