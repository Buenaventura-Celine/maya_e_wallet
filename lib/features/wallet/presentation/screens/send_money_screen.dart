import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/features/auth/presentation/widgets/app_drawer.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';
import 'package:maya_e_wallet/features/wallet/presentation/utils/wallet_validators.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/amount_input_field.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/send_money/recipient_input_field.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/send_money/send_money_action_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/send_money/cancel_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/send_money/send_money_confirmation_dialog.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/send_money/send_money_success_dialog.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  late TextEditingController _recipientController;
  late TextEditingController _amountController;

  double _currentBalance = 500.00; // Default value

  bool get _isFormValid {
    if (_recipientController.text.isEmpty || _amountController.text.isEmpty) {
      return false;
    }
    return WalletValidators.validateRecipient(_recipientController.text) == null &&
        WalletValidators.validateAmount(_amountController.text, _currentBalance) ==
            null;
  }

  @override
  void initState() {
    super.initState();
    _recipientController = TextEditingController();
    _amountController = TextEditingController();

    _recipientController.addListener(() {
      setState(() {});
    });
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog() {
    final recipient = _recipientController.text;
    final amount = double.parse(_amountController.text);

    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (context) => SendMoneyConfirmationDialog(
        recipient: recipient,
        amount: amount,
        onConfirm: () => _submitForm(recipient, amount),
      ),
    );
  }

  void _submitForm(String recipient, double amount) {
    context.read<WalletCubit>().sendMoney(recipient, amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: SafeArea(
        child: BlocListener<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is ActionSuccess) {
              _showSuccessDialog();
            } else if (state is ActionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) {
              if (state is WalletLoaded) {
                _currentBalance = state.wallet.balance;
              }

              final isLoading = state is ActionInProgress;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      RecipientInputField(
                        controller: _recipientController,
                        validator: WalletValidators.validateRecipient,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 24.0),
                      AmountInputField(
                        controller: _amountController,
                        maxAmount: _currentBalance,
                        helperText:
                            'Available balance: ₱${_currentBalance.toStringAsFixed(2)}',
                        validator: (value) =>
                            WalletValidators.validateAmount(value, _currentBalance),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 24.0),
                      SendMoneyActionButton(
                        enabled: _isFormValid && !isLoading,
                        isLoading: isLoading,
                        onPressed: _showConfirmationDialog,
                      ),
                      const SizedBox(height: 16.0),
                      CancelButton(
                        onPressed: isLoading ? () {} : () => context.pop(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    final amount = double.parse(_amountController.text);
    final recipient = _recipientController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SendMoneySuccessDialog(
        amount: amount,
        recipient: recipient,
      ),
    );
  }
}
