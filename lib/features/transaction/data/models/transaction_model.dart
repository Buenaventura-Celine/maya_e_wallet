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
    final dateTimeValue = json['dateTime'];
    final DateTime parsedDateTime;

    try {
      if (dateTimeValue is String) {
        // Handle ISO 8601 string format
        parsedDateTime = DateTime.parse(dateTimeValue);
      } else if (dateTimeValue is num) {
        // Handle Unix timestamp (seconds since epoch)
        final timestampInSeconds = dateTimeValue.toInt();
        parsedDateTime = DateTime.fromMillisecondsSinceEpoch(
          timestampInSeconds * 1000,
        );
      } else if (dateTimeValue == null) {
        // Default to current time if missing
        parsedDateTime = DateTime.now();
      } else {
        throw FormatException(
          'Invalid dateTime format. Expected String, num, or null, got: ${dateTimeValue.runtimeType} with value: $dateTimeValue',
        );
      }
    } catch (e) {
      throw FormatException(
        'Error parsing dateTime: $e\nValue: $dateTimeValue\nFull JSON: $json',
      );
    }

    return TransactionModel(
      id: json['id'].toString(),
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      recipient: json['recipient'] as String,
      dateTime: parsedDateTime,
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
