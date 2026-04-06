import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final double balance;
  final bool isBalanceHidden;

  const WalletEntity({
    required this.balance,
    required this.isBalanceHidden,
  });

  @override
  List<Object?> get props => [balance, isBalanceHidden];
}
