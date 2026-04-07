import 'package:maya_e_wallet/features/transaction/data/models/transaction_model.dart';

class LocalTransactionDataSource {
  static const List<Map<String, dynamic>> _mockTransactions = [
    {
      'id': 'txn_001',
      'type': 'send',
      'amount': 150.00,
      'recipient': 'John Doe',
      'dateTime': '2024-03-15T14:30:00Z',
      'status': 'completed',
    },
    {
      'id': 'txn_002',
      'type': 'cashIn',
      'amount': 500.00,
      'recipient': 'Bank Transfer',
      'dateTime': '2024-03-14T10:15:00Z',
      'status': 'completed',
    },
    {
      'id': 'txn_003',
      'type': 'send',
      'amount': 75.50,
      'recipient': 'Maria Santos',
      'dateTime': '2024-03-13T16:45:00Z',
      'status': 'completed',
    },
    {
      'id': 'txn_004',
      'type': 'cashIn',
      'amount': 1000.00,
      'recipient': 'Credit Card',
      'dateTime': '2024-03-12T09:20:00Z',
      'status': 'completed',
    },
    {
      'id': 'txn_005',
      'type': 'send',
      'amount': 250.00,
      'recipient': 'Juan Dela Cruz',
      'dateTime': '2024-03-11T11:00:00Z',
      'status': 'completed',
    },
    {
      'id': 'txn_006',
      'type': 'cashIn',
      'amount': 2000.00,
      'recipient': 'Bank Transfer',
      'dateTime': '2024-03-10T13:30:00Z',
      'status': 'completed',
    },
    {
      'id': 'txn_007',
      'type': 'send',
      'amount': 300.00,
      'recipient': 'Ana Garcia',
      'dateTime': '2024-03-09T15:45:00Z',
      'status': 'completed',
    },
    {
      'id': 'txn_008',
      'type': 'cashIn',
      'amount': 1500.00,
      'recipient': 'Debit Card',
      'dateTime': '2024-03-08T10:10:00Z',
      'status': 'completed',
    },
  ];

  Future<List<TransactionModel>> getTransactions() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _mockTransactions
        .map((json) => TransactionModel.fromJson(json))
        .toList();
  }
}
