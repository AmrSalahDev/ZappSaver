import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/constants/app_images.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/routes/app_router.dart';
import 'package:flutter_status_up/features/widgets/custom_button.dart';
import 'package:flutter_status_up/features/widgets/system_ui_wrapper.dart';
import 'package:flutter_status_up/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemUiWrapper(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      navigationBarColor: Colors.transparent,
      navigationBarIconBrightness: Brightness.light,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              AppImages.startScreenBg,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.textScaler.scale(30),
                      letterSpacing: !context.isArabic ? 1.5 : 0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '- ',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: context.textScaler.scale(25),
                          ),
                        ),
                        TextSpan(
                          text: S.of(context).shortAppName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: context.textScaler.scale(16),
                          ),
                        ),
                        TextSpan(
                          text: ' -',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: context.textScaler.scale(25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    title: S.of(context).getStarted,
                    onPressed: () =>
                        context.push(AppRouter.selectLang, extra: false),
                  ),
                  SizedBox(height: context.screenHeight * 0.07),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
