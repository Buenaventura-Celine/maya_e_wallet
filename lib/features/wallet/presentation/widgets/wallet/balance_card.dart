import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  final double balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  late bool _isBalanceHidden;

  @override
  void initState() {
    super.initState();
    _isBalanceHidden = false;
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceHidden = !_isBalanceHidden;
    });
  }

  String _formatBalance(double balance) {
    return '₱${balance.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Text(
              'Account Balance',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isBalanceHidden
                      ? '*' * _formatBalance(widget.balance).length
                      : _formatBalance(widget.balance),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: _toggleBalanceVisibility,
                  icon: Icon(
                    _isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
