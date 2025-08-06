import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/services/di/di.dart';
import 'package:flutter_status_up/core/services/toast_service.dart';
import 'package:flutter_status_up/core/utils/whatsapp_utils.dart';
import 'package:flutter_status_up/generated/l10n.dart';

class DownloadPart extends StatelessWidget {
  final Widget thumbnail;
  final bool isVideo;
  final File file;

  const DownloadPart({
    super.key,
    required this.file,
    required this.thumbnail,
    required this.isVideo,
  });

  @override
  Widget build(BuildContext context) {
    final isSavedNotifier = ValueNotifier<bool>(
      WhatsappUtils.isStatusAlreadySaved(file),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        thumbnail,
        isVideo
            ? Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
              )
            : Container(),
        GestureDetector(
          onTap: () async {
            final currentValue = isSavedNotifier.value;

            if (currentValue) {
              WhatsappUtils.deleteStatus(file);
              getIt<ToastService>().showSuccessToast(
                context: context,
                message: S.of(context).statusDeleted,
              );
            } else {
              await WhatsappUtils.saveStatus(file);
              if (context.mounted) {
                getIt<ToastService>().showSuccessToast(
                  context: context,
                  message: S.of(context).statusSavedSuccessfully,
                );
              }
            }

            isSavedNotifier.value = !currentValue;
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(80),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),

              child: ValueListenableBuilder<bool>(
                valueListenable: isSavedNotifier,
                builder: (context, isSaved, _) {
                  return Center(
                    child: isSaved
                        ? Icon(Icons.check_circle_rounded, color: Colors.white)
                        : Text(
                            S.of(context).donwload,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: context.textScaler.scale(14),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
