import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maya_e_wallet/features/transaction/data/models/transaction_model.dart';

class RemoteTransactionDataSource {
  final http.Client httpClient;
  static const String _baseUrl =
      'https://69d498dcd396bd74235d3af9.mockapi.io/api/v1/transactions';

  RemoteTransactionDataSource({required this.httpClient});

  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await httpClient
          .get(
            Uri.parse(_baseUrl),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  Future<TransactionModel> recordTransaction({
    required String type,
    required double amount,
    required String recipient,
  }) async {
    try {
      final body = {
        'type': type,
        'amount': amount,
        'recipient': recipient,
        'dateTime': DateTime.now().toIso8601String(),
        'status': 'completed',
      };

      final response = await httpClient
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return TransactionModel.fromJson(json as Map<String, dynamic>);
      } else {
        throw Exception('Failed to record transaction');
      }
    } catch (e) {
      throw Exception('Error recording transaction: $e');
    }
  }
}
