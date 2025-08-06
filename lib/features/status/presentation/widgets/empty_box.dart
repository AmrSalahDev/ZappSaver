import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/constants/app_images.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_svg/svg.dart';

class EmptyBox extends StatelessWidget {
  final String message;
  const EmptyBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppImages.emptyBox,
          width: context.screenWidth * 0.6,
          height: context.screenWidth * 0.6,
          colorFilter: const ColorFilter.mode(
            AppColors.primaryColor,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(height: context.screenHeight * 0.02),
        Text(
          message,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: context.textScaler.scale(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.screenHeight * 0.05),
      ],
    );
  }
}
