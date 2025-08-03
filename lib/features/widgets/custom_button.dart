import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: context.textScaler.scale(16),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
