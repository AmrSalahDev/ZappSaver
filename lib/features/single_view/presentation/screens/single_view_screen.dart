import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/services/di/di.dart';
import 'package:flutter_status_up/core/services/toast_service.dart';
import 'package:flutter_status_up/features/single_view/presentation/cubit/single_view_cubit.dart';
import 'package:flutter_status_up/features/widgets/custom_app_bar.dart';
import 'package:flutter_status_up/features/widgets/system_ui_wrapper.dart';
import 'package:flutter_status_up/generated/l10n.dart';
import 'package:video_player/video_player.dart';

class SingleViewScreen extends StatefulWidget {
  final String path;
  final int initialIndex;
  final bool isImage;

  const SingleViewScreen({
    super.key,
    required this.path,
    required this.initialIndex,
    required this.isImage,
  });

  @override
  State<SingleViewScreen> createState() => _SingleViewScreenState();
}

class _SingleViewScreenState extends State<SingleViewScreen> {
  List<String> imagePaths = [];
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    imagePaths = context.read<SingleViewCubit>().loadImagePaths(
      File(widget.path).parent.path,
    );
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemUiWrapper(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      navigationBarColor: Colors.white,
      navigationBarIconBrightness: Brightness.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                CustomAppBar(title: S.of(context).view),
                SizedBox(height: context.screenHeight * 0.04),
                widget.isImage
                    ? ViewImage(
                        imagePaths: imagePaths,
                        pageController: _pageController,
                      )
                    : ViewVideo(path: widget.path),
                SizedBox(height: context.screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<SingleViewCubit>().saveImage(
                          imagePaths[_pageController.page!.toInt()],
                        );
                        getIt<ToastService>().showSuccessToast(
                          context: context,
                          message: S.of(context).statusSavedSuccessfully,
                        );
                      },
                      icon: const Icon(
                        Icons.save,
                        color: AppColors.primaryColor,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryColor.withAlpha(50),
                        padding: const EdgeInsets.all(15),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<SingleViewCubit>().shareImage(
                          imagePaths[_pageController.page!.toInt()],
                        );
                      },
                      icon: const Icon(
                        Icons.share,
                        color: AppColors.primaryColor,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryColor.withAlpha(50),
                        padding: const EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewVideo extends StatefulWidget {
  final String path;
  const ViewVideo({super.key, required this.path});

  @override
  State<ViewVideo> createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late Chewie playerWidget;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget.path));
    videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      allowMuting: true,
      zoomAndPan: true,
      aspectRatio: videoPlayerController.value.aspectRatio,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primaryColor,
        handleColor: AppColors.primaryColor,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.grey,
      ),
    );

    playerWidget = Chewie(controller: chewieController);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(videoPlayerController.value.aspectRatio.toString());
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: playerWidget,
          ),
        ),
      ),
    );
  }
}

class ViewImage extends StatelessWidget {
  const ViewImage({
    super.key,
    required this.imagePaths,
    required this.pageController,
  });

  final List<String> imagePaths;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        itemCount: imagePaths.length,
        controller: pageController,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(File(imagePaths[index]), fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
