import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColors.primaryColor.withAlpha(50),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: context.textScaler.scale(25),
          ),
        ),
      ],
    );
  }
}
