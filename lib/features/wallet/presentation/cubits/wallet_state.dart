import 'package:equatable/equatable.dart';
import 'package:maya_e_wallet/features/wallet/domain/entities/wallet_entity.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final WalletEntity wallet;

  const WalletLoaded({required this.wallet});

  @override
  List<Object?> get props => [wallet];
}

class ActionInProgress extends WalletState {
  const ActionInProgress();
}

class ActionSuccess extends WalletState {
  final String message;

  const ActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ActionFailure extends WalletState {
  final String message;

  const ActionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
