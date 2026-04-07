import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_e_wallet/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionCubit({required this.getTransactionsUseCase})
      : super(const TransactionInitial());

  Future<void> loadTransactions() async {
    emit(const TransactionLoading());
    try {
      final transactions = await getTransactionsUseCase();
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
