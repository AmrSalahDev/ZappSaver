import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:toastification/toastification.dart';

abstract class IToastService {
  void showSuccessToast({
    required BuildContext context,
    required String message,
  });
  void showErrorToast(String message);
  void showInfoToast(String message);
}

class ToastService extends IToastService {
  @override
  void showErrorToast(String message) {}

  @override
  void showInfoToast(String message) {}

  @override
  void showSuccessToast({
    required BuildContext context,
    required String message,
  }) {
    toastification.show(
      context: context,
      title: Text(
        message,
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: context.textScaler.scale(16),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.normal,
        ),
      ),
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      icon: Icon(Icons.check_circle_rounded, color: AppColors.primaryColor),
      alignment: Alignment.bottomCenter,

      autoCloseDuration: const Duration(seconds: 3),
    );
  }
}
