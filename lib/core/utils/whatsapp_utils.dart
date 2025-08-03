import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_status_up/core/utils/permission_utils.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class WhatsappUtils {
  static const String statusDir =
      '/storage/emulated/0/WhatsApp/Media/.Statuses';
  static const String businessStatusDir =
      '/storage/emulated/0/WhatsApp Business/Media/.Statuses';
  static const String statusSaverDir =
      '/storage/emulated/0/Download/WhatsappStatusSaver';

  static Future<List<File>> getWhatsappStatusesVideos() async {
    final dir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

    if (await dir.exists()) {
      return dir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.mp4'))
          .toList();
    } else {
      throw Exception("Status directory not found");
    }
  }

  static bool isStatusAlreadySaved(File statusFile) {
    final savedFile = File(
      '$statusSaverDir/${statusFile.uri.pathSegments.last}',
    );
    return savedFile.existsSync();
  }

  static void deleteStatus(File statusFile) {
    final savedFile = File(
      '$statusSaverDir/${statusFile.uri.pathSegments.last}',
    );
    debugPrint("Deleted: ${savedFile.path}");
    return savedFile.deleteSync(recursive: true);
  }

  static Future<List<File>> getWhatsappBusinessStatusesVideos() async {
    final dir = Directory(
      '/storage/emulated/0/WhatsApp Business/Media/.Statuses',
    );

    if (await dir.exists()) {
      return dir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.mp4'))
          .toList();
    } else {
      throw Exception("Status directory not found");
    }
  }

  static Future<List<File>> getWhatsappStatusesImages() async {
    final dir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

    if (await dir.exists()) {
      return dir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.jpg'))
          .toList();
    } else {
      throw Exception("Status directory not found");
    }
  }

  static Future<List<File>> getWhatsappBusinessStatusesImages() async {
    final dir = Directory(
      '/storage/emulated/0/WhatsApp Business/Media/.Statuses',
    );

    if (await dir.exists()) {
      return dir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.jpg'))
          .toList();
    } else {
      throw Exception("Status directory not found");
    }
  }

  static Future<bool> saveStatus(File sourceFile) async {
    final hasPermission = await PermissionUtils.requestStoragePermission();
    if (!hasPermission) {
      debugPrint("Permission not granted");
      return false;
    }

    // Define destination folder (e.g., Downloads/WhatsappStatusSaver)
    final String newDirPath = statusSaverDir;

    final Directory newDir = Directory(newDirPath);
    if (!await newDir.exists()) {
      await newDir.create(recursive: true);
    }

    // Create a new file name
    final String fileName = path.basename(sourceFile.path);
    final String newFilePath = path.join(newDir.path, fileName);

    // Copy file
    final File newFile = await sourceFile.copy(newFilePath);
    debugPrint("Saved to: ${newFile.path}");

    return true;
  }

  static Future<void> shareStatus(File statusFile) async {
    final params = ShareParams(files: [XFile(statusFile.path)]);

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      debugPrint('Status shared successfully');
    }
  }
}
