import 'package:flutter/material.dart';

class CustomAddUpdateButton extends StatelessWidget {
  final bool isAdd;
  final VoidCallback onPressed;

  const CustomAddUpdateButton({
    super.key,
    required this.isAdd,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        isAdd ? Icons.add : Icons.edit,
        color: Colors.white,
        size: 14,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      label: Text(
        isAdd ? 'Add' : 'Update',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
