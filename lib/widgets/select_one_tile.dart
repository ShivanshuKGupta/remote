import 'package:flutter/material.dart';

class SelectOneTile extends StatelessWidget {
  final bool isSelected;
  final void Function() onPressed;
  final String label;
  final bool enabled;
  const SelectOneTile({
    super.key,
    required this.isSelected,
    required this.onPressed,
    required this.label,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      icon: isSelected ? const Icon(Icons.done_rounded) : Container(),
      style: isSelected
          ? OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.onPrimary,
              backgroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
            )
          : null,
      onPressed: enabled ? onPressed : null,
      label: Text(label),
    );
  }
}
