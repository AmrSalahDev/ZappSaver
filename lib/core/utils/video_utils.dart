import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class VideoUtils {
  static Future<Uint8List?> getVideoThumbnail(String path) async {
    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128, // or any suitable width
        quality: 75,
      );
      return bytes;
    } catch (e) {
      print('Thumbnail error: $e');
      return null;
    }
  }
}
