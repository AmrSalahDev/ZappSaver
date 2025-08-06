import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/core/utils/video_utils.dart';

class VideoThumbnailCubit extends Cubit<Map<String, Uint8List?>> {
  VideoThumbnailCubit() : super({});

  Future<void> loadThumbnail(String path) async {
    if (state.containsKey(path)) return;

    try {
      final bytes = await VideoUtils.getVideoThumbnail(path);
      if (!isClosed) emit({...state, path: bytes});
    } catch (e) {
      if (!isClosed) emit({...state, path: null});
    }
  }
}
