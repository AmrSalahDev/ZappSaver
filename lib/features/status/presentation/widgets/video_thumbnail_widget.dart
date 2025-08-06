import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/features/status/presentation/cubit/video_thumbnail_cubit.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoPath;

  const VideoThumbnailWidget({super.key, required this.videoPath});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<VideoThumbnailCubit>().loadThumbnail(widget.videoPath);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<VideoThumbnailCubit, Map<String, Uint8List?>>(
      buildWhen: (prev, curr) =>
          prev[widget.videoPath] != curr[widget.videoPath],
      builder: (context, state) {
        final bytes = state[widget.videoPath];

        if (bytes == null) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
            color: Colors.black12,
          ),
        );
      },
    );
  }
}
