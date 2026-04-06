import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CancelButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.0,
      child: OutlinedButton(
        onPressed: onPressed,
        child: const Text('Cancel'),
      ),
    );
  }
}
