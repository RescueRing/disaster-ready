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
  'volunteer': Icons.volunteer_activism,
  'donate': Icons.monetization_on,
  'provideShelter': Icons.house,
  'Offer Food': Icons.food_bank,
  'medical': Icons.medical_services,
  'shelter': Icons.house,
  'food': Icons.fastfood,
  'clothing': Icons.checkroom,
  'other': Icons.help_outline,
};
