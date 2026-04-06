import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maya_e_wallet/features/auth/presentation/widgets/app_drawer.dart';
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
  static const double _balance = 500.00;

  late TextEditingController _recipientController;
  late TextEditingController _amountController;

  bool _isLoading = false;
  bool get _isFormValid =>
      _recipientController.text.isNotEmpty &&
      _amountController.text.isNotEmpty &&
      WalletValidators.validateRecipient(_recipientController.text) == null &&
      WalletValidators.validateAmount(_amountController.text, _balance) == null;

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

    showDialog(
      context: context,
      builder: (context) => SendMoneyConfirmationDialog(
        recipient: recipient,
        amount: amount,
        onConfirm: _submitForm,
      ),
    );
  }

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _showSuccessDialog();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                RecipientInputField(
                  controller: _recipientController,
                  validator: WalletValidators.validateRecipient,
                ),
                const SizedBox(height: 24.0),
                AmountInputField(
                  controller: _amountController,
                  maxAmount: _balance,
                  helperText: 'Available balance: ₱${_balance.toStringAsFixed(2)}',
                  validator: (value) =>
                      WalletValidators.validateAmount(value, _balance),
                ),
                const SizedBox(height: 24.0),
                SendMoneyActionButton(
                  enabled: _isFormValid,
                  isLoading: _isLoading,
                  onPressed: _showConfirmationDialog,
                ),
                const SizedBox(height: 16.0),
                CancelButton(
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
