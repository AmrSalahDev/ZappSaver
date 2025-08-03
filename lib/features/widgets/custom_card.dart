import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_svg/svg.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.screenWidth * 0.4,
        height: context.screenHeight * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                iconPath,
                height: context.screenHeight * 0.05,
                width: context.screenHeight * 0.05,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: context.textScaler.scale(16),

                fontFamily: 'Poppins',
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
