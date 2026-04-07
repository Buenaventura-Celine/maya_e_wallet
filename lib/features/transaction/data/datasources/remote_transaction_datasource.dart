import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maya_e_wallet/features/transaction/data/models/transaction_model.dart';

class RemoteTransactionDataSource {
  final http.Client httpClient;
  static const String _baseUrl =
      'https://my-json-server.typicode.com/Buenaventura-Celine/maya-fake-api';

  RemoteTransactionDataSource({required this.httpClient});

  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await httpClient
          .get(Uri.parse('$_baseUrl/transactions'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch transactions. Status code: ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error while fetching transactions: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid JSON response: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }
}
