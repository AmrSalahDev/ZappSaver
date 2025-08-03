import 'package:flutter_status_up/core/constants/app_images.dart';
import 'package:flutter_status_up/generated/l10n.dart';

class ItemModel {
  final String title;
  final String iconPath;

  ItemModel({required this.title, required this.iconPath});

  static List<ItemModel> get items => [
    ItemModel(title: S.current.message, iconPath: AppImages.messages),
    ItemModel(title: S.current.photo, iconPath: AppImages.photo),
    ItemModel(title: S.current.video, iconPath: AppImages.video),
    ItemModel(title: S.current.audio, iconPath: AppImages.audio),
    ItemModel(title: S.current.sticker, iconPath: AppImages.sticker),
    ItemModel(title: S.current.recording, iconPath: AppImages.voice),
    ItemModel(title: S.current.documents, iconPath: AppImages.document),
    ItemModel(title: S.current.gif, iconPath: AppImages.gif),
  ];
}
