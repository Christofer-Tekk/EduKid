// lib/core/widgets/practice_success_dialog.dart

import 'package:flutter/material.dart';

import '../constants/colores_app.dart';

class PracticeSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const PracticeSuccessDialog({
    super.key,
    this.title = '¡Excelente! ⭐',
    required this.message,
    this.primaryText = 'Practicar otra vez',
    this.secondaryText = 'Volver',
    required this.onPrimary,
    required this.onSecondary,
  });

  static Future<void> show({
    required BuildContext context,
    String title = '¡Excelente! ⭐',
    required String message,
    String primaryText = 'Practicar otra vez',
    String secondaryText = 'Volver',
    required VoidCallback onPrimary,
    required VoidCallback onSecondary,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PracticeSuccessDialog(
          title: title,
          message: message,
          primaryText: primaryText,
          secondaryText: secondaryText,
          onPrimary: () {
            Navigator.pop(dialogContext);
            onPrimary();
          },
          onSecondary: () {
            Navigator.pop(dialogContext);
            onSecondary();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFFF8FF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(
          color: ColoresApp.completado,
          width: 3,
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF202020),
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF303030),
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w700,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            _DialogButton(
              text: primaryText,
              color: ColoresApp.naranjaVibrante,
              onTap: onPrimary,
            ),
            _DialogButton(
              text: secondaryText,
              color: ColoresApp.completado,
              onTap: onSecondary,
            ),
          ],
        ),
      ],
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _DialogButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
