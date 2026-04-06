import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.balance,
    required super.isBalanceHidden,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num).toDouble(),
      isBalanceHidden: json['isBalanceHidden'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'isBalanceHidden': isBalanceHidden,
    };
  }

  factory WalletModel.fromEntity(WalletEntity entity) {
    return WalletModel(
      balance: entity.balance,
      isBalanceHidden: entity.isBalanceHidden,
    );
  }
}
