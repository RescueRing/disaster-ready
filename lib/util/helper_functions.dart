import 'package:flutter/material.dart';

void snack(text, BuildContext context, {Color? color, fontSize, duration}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration != null
          ? Duration(seconds: duration)
          : const Duration(seconds: 3),
      closeIconColor: color != null
          ? Colors.white
          : Theme.of(context).colorScheme.onPrimary,
      backgroundColor: color,
      showCloseIcon: true,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: TextStyle(
            color: color != null
                ? Colors.white
                : Theme.of(context).colorScheme.onPrimary,
            fontSize: fontSize ?? 16,
          ),
        ),
      ),
    ),
  );
}

// return icons using name as key
Map<String, IconData> helpIcons = {
  'Volunteer': Icons.volunteer_activism,
  'Donate': Icons.monetization_on,
  'Provide Shelter': Icons.house,
  'Offer Food': Icons.food_bank,
  'Medical': Icons.medical_services,
  'Shelter': Icons.house,
  'Food': Icons.fastfood,
  'Clothing': Icons.checkroom,
  'Other': Icons.help_outline,
};
