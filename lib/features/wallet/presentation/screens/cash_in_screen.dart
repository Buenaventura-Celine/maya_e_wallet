import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/features/auth/presentation/widgets/app_drawer.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_cubit.dart';
import 'package:maya_e_wallet/features/wallet/presentation/cubits/wallet_state.dart';
import 'package:maya_e_wallet/features/wallet/presentation/utils/wallet_validators.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/cash_in/cash_in_amount_input_field.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/cash_in/cash_in_action_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/send_money/cancel_button.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/cash_in/cash_in_confirmation_dialog.dart';
import 'package:maya_e_wallet/features/wallet/presentation/widgets/cash_in/cash_in_success_dialog.dart';

class CashInScreen extends StatefulWidget {
  const CashInScreen({super.key});

  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  static const double _maxCashIn = 100000.0;
  static const String _source = 'GCash Account';

  late TextEditingController _amountController;

  bool get _isFormValid {
    final text = _amountController.text;
    final isValid = text.isNotEmpty &&
        WalletValidators.validateCashInAmount(
              text,
              maxAmount: _maxCashIn,
            ) ==
            null;
    debugPrint('Cash In Form Valid: $isValid (text: "$text")');
    return isValid;
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();

    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog() {
    final amount = double.parse(_amountController.text);

    // Dismiss keyboard before showing dialog
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (context) => CashInConfirmationDialog(
        amount: amount,
        source: _source,
        onConfirm: () => _submitForm(amount),
      ),
    );
  }

  void _submitForm(double amount) {
    context.read<WalletCubit>().cashIn(amount);
  }

  void _showSuccessDialog() {
    final amount = double.parse(_amountController.text);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CashInSuccessDialog(
        amount: amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Cash In'),
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
              final isLoading = state is ActionInProgress;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CashInAmountInputField(
                        controller: _amountController,
                        maxAmount: _maxCashIn,
                        validator: (value) => WalletValidators.validateCashInAmount(
                          value,
                          maxAmount: _maxCashIn,
                        ),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16.0),
                      CashInActionButton(
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
}
