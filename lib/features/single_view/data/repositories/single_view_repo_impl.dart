import 'dart:io';

import 'package:flutter_status_up/core/utils/whatsapp_utils.dart';
import 'package:flutter_status_up/features/single_view/domain/repositories/single_view_repo.dart';
import 'package:path/path.dart' as p;

class SingleViewRepoImpl extends SingleViewRepository {
  @override
  List<String> loadImagePaths(String foldrPath) {
    final dir = Directory(foldrPath);
    final files = dir.listSync().whereType<File>().where((file) {
      final ext = p.extension(file.path).toLowerCase();
      return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(ext);
    }).toList();

    //files.sort((a, b) => a.path.compareTo(b.path));

    return files.map((f) => f.path).toList();
  }

  @override
  Future<void> saveImage(String path) async {
    await WhatsappUtils.saveStatus(File(path));
  }

  @override
  Future<void> shareImage(String path) async {
    await WhatsappUtils.shareStatus(File(path));
  }
}
