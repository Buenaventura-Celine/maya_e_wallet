import 'package:flutter/material.dart';

class RecipientInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? helperText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  const RecipientInputField({
    super.key,
    required this.controller,
    this.label = 'Recipient',
    this.hintText = 'Name',
    this.helperText = 'Enter name of the recipient',
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  @override
  State<RecipientInputField> createState() => _RecipientInputFieldState();
}

class _RecipientInputFieldState extends State<RecipientInputField> {
  late FocusNode _focusNode;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onValueChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    widget.controller.removeListener(_onValueChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validateInput();
      setState(() {});
    }
  }

  void _onValueChange() {
    // Real-time validation after 3 characters
    if (widget.controller.text.length >= 3) {
      _validateInput();
    }
  }

  void _validateInput() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      setState(() {
        _errorMessage = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12.0),

        // Input Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: _errorMessage != null
                  ? Theme.of(context).colorScheme.error
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              _onValueChange();
              widget.onChanged?.call(value);
            },
            onSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),

        // Helper Text
        if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              widget.helperText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

        // Error Message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
