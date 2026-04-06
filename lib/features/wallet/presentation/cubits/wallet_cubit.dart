import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/cash_in_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/get_balance_usecase.dart';
import 'package:maya_e_wallet/features/wallet/domain/usecases/send_money_usecase.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final GetBalanceUseCase getBalanceUseCase;
  final SendMoneyUseCase sendMoneyUseCase;
  final CashInUseCase cashInUseCase;

  WalletCubit({
    required this.getBalanceUseCase,
    required this.sendMoneyUseCase,
    required this.cashInUseCase,
  }) : super(const WalletInitial());

  Future<void> loadBalance() async {
    try {
      emit(const WalletLoading());
      final wallet = await getBalanceUseCase();
      emit(WalletLoaded(wallet: wallet));
    } catch (e) {
      emit(ActionFailure(message: 'Failed to load balance: ${e.toString()}'));
    }
  }

  void toggleBalanceVisibility() {
    if (state is WalletLoaded) {
      final currentWallet = (state as WalletLoaded).wallet;
      final updatedWallet = WalletEntity(
        balance: currentWallet.balance,
        isBalanceHidden: !currentWallet.isBalanceHidden,
      );
      emit(WalletLoaded(wallet: updatedWallet));
    }
  }

  Future<void> sendMoney(String recipient, double amount) async {
    try {
      emit(const ActionInProgress());
      await sendMoneyUseCase(recipient, amount);

      emit(ActionSuccess(message: 'Money sent successfully to $recipient'));
    } catch (e) {
      emit(ActionFailure(message: 'Failed to send money: ${e.toString()}'));
    }
  }

  // Cash in funds
  Future<void> cashIn(double amount) async {
    try {
      emit(const ActionInProgress());
      await cashInUseCase(amount);

      emit(ActionSuccess(
          message:
              'Cash in of ₱${amount.toStringAsFixed(2)} completed successfully'));
    } catch (e) {
      emit(ActionFailure(message: 'Failed to cash in: ${e.toString()}'));
    }
  }
}
