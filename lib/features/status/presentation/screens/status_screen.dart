import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/application/cubits/banner_ad_cubit.dart';
import 'package:flutter_status_up/application/cubits/rewarded_ad_cubit.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/routes/app_router.dart';
import 'package:flutter_status_up/core/routes/args/single_view_screen_args.dart';
import 'package:flutter_status_up/core/services/di/di.dart';
import 'package:flutter_status_up/core/utils/permission_utils.dart';
import 'package:flutter_status_up/features/status/presentation/cubit/status_cubit.dart';
import 'package:flutter_status_up/features/status/presentation/cubit/video_thumbnail_cubit.dart';
import 'package:flutter_status_up/features/status/presentation/widgets/download_part.dart';
import 'package:flutter_status_up/features/status/presentation/widgets/empty_box.dart';
import 'package:flutter_status_up/features/status/presentation/widgets/video_thumbnail_widget.dart';
import 'package:flutter_status_up/features/widgets/custom_app_bar.dart';
import 'package:flutter_status_up/features/widgets/system_ui_wrapper.dart';
import 'package:flutter_status_up/generated/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StatusScreen extends StatefulWidget {
  final bool isFromWhatsapp;
  const StatusScreen({super.key, required this.isFromWhatsapp});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late final BannerAdCubit _bannerAdCubit;
  late final RewardedAdCubit _rewardedAdCubit;

  @override
  void initState() {
    super.initState();
    _bannerAdCubit = getIt<BannerAdCubit>();
    _rewardedAdCubit = getIt<RewardedAdCubit>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerAdCubit.loadBannerAd(context);
    _rewardedAdCubit.loadRewardedAd();
  }

  @override
  void dispose() {
    _bannerAdCubit.dispose();
    _rewardedAdCubit.close();
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
        bottomNavigationBar: BlocBuilder<BannerAdCubit, BannerAd?>(
          bloc: _bannerAdCubit,
          builder: (context, ad) {
            if (ad == null) return const SizedBox.shrink();
            return SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            );
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Column(
              children: [
                CustomAppBar(title: S.of(context).statuses),
                SizedBox(height: context.screenHeight * 0.04),
                Expanded(
                  child: CustomTabBarView(
                    rewardedAdCubit: _rewardedAdCubit,
                    isFromWhatsapp: widget.isFromWhatsapp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTabBarView extends StatelessWidget {
  final RewardedAdCubit rewardedAdCubit;
  final bool isFromWhatsapp;

  const CustomTabBarView({
    super.key,
    required this.rewardedAdCubit,
    required this.isFromWhatsapp,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            unselectedLabelColor: Colors.black54,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            tabs: [
              Tab(
                child: Text(
                  S.of(context).photos,
                  style: TextStyle(fontSize: context.textScaler.scale(16)),
                ),
              ),
              Tab(
                child: Text(
                  S.of(context).videos,
                  style: TextStyle(fontSize: context.textScaler.scale(16)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              children: [
                WhatsappImagesTab(
                  rewardedAdCubit: rewardedAdCubit,
                  isFromWhatsapp: isFromWhatsapp,
                ),
                WhatsappVideosTab(
                  rewardedAdCubit: rewardedAdCubit,
                  isFromWhatsapp: isFromWhatsapp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsappImagesTab extends StatefulWidget {
  final RewardedAdCubit rewardedAdCubit;
  final bool isFromWhatsapp;

  const WhatsappImagesTab({
    super.key,
    required this.rewardedAdCubit,
    required this.isFromWhatsapp,
  });

  @override
  State<WhatsappImagesTab> createState() => _WhatsappImagesTabState();
}

class _WhatsappImagesTabState extends State<WhatsappImagesTab> {
  late final StatusCubit _statusCubit;

  @override
  void initState() {
    super.initState();
    _statusCubit = StatusCubit();

    PermissionUtils.requestStoragePermissions(
      onGranted: () {
        _statusCubit.loadImages(isFromWhatsapp: widget.isFromWhatsapp);
      },
      onDenied: () {
        debugPrint('Denied');
      },
      onPermanentlyDenied: () {
        debugPrint('Permanently denied');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _statusCubit,
      child: BlocBuilder<StatusCubit, StatusState>(
        builder: (context, state) {
          if (state is StatusLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatusError) {
            return Center(child: Text(state.message));
          }

          if (state is StatusLoaded) {
            final images = state.files;

            if (images.isEmpty) {
              return EmptyBox(message: S.of(context).noPhotosFound);
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                _statusCubit.loadImages(isFromWhatsapp: widget.isFromWhatsapp);
              },
              child: GridView.builder(
                itemCount: images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final file = images[index];
                  return GestureDetector(
                    onTap: () {
                      widget.rewardedAdCubit.showIfReady(
                        onRewardEarned: () {
                          context.push(
                            AppRouter.singleView,
                            extra: SingleViewScreenArgs(
                              path: file.path,
                              initialIndex: index,
                              isImage: true,
                            ),
                          );
                        },
                        elseDoThis: () {
                          context.push(
                            AppRouter.singleView,
                            extra: SingleViewScreenArgs(
                              path: file.path,
                              initialIndex: index,
                              isImage: true,
                            ),
                          );
                        },
                      );
                    },
                    child: DownloadPart(
                      file: file,
                      thumbnail: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.file(file, fit: BoxFit.cover),
                      ),
                      isVideo: false,
                    ),
                  );
                },
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class WhatsappVideosTab extends StatefulWidget {
  final RewardedAdCubit rewardedAdCubit;
  final bool isFromWhatsapp;

  const WhatsappVideosTab({
    super.key,
    required this.rewardedAdCubit,
    required this.isFromWhatsapp,
  });

  @override
  State<WhatsappVideosTab> createState() => _WhatsappVideosTabState();
}

class _WhatsappVideosTabState extends State<WhatsappVideosTab> {
  late final StatusCubit _statusCubit;
  late final VideoThumbnailCubit _thumbnailCubit;

  @override
  void initState() {
    super.initState();
    _statusCubit = StatusCubit();
    _thumbnailCubit = VideoThumbnailCubit();

    PermissionUtils.requestStoragePermissions(
      onGranted: () {
        _statusCubit.loadVideos(isFromWhatsapp: widget.isFromWhatsapp);
      },
      onDenied: () {
        debugPrint('Denied');
      },
      onPermanentlyDenied: () {
        debugPrint('Permanently denied');
      },
    );
  }

  @override
  void dispose() {
    _statusCubit.close();
    _thumbnailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StatusCubit>.value(value: _statusCubit),
        BlocProvider<VideoThumbnailCubit>.value(value: _thumbnailCubit),
      ],
      child: BlocBuilder<StatusCubit, StatusState>(
        builder: (context, state) {
          if (state is StatusLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StatusError) {
            return Center(child: Text(state.message));
          }

          if (state is StatusLoaded) {
            final videos = state.files;
            if (videos.isEmpty) {
              return EmptyBox(message: S.of(context).noVideosFound);
            }
            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                _statusCubit.loadVideos(isFromWhatsapp: widget.isFromWhatsapp);
              },
              child: GridView.builder(
                itemCount: videos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final file = videos[index];

                  return GestureDetector(
                    onTap: () {
                      widget.rewardedAdCubit.showIfReady(
                        onRewardEarned: () {
                          context.push(
                            AppRouter.singleView,
                            extra: SingleViewScreenArgs(
                              path: file.path,
                              initialIndex: index,
                              isImage: false,
                            ),
                          );
                        },
                        elseDoThis: () {
                          context.push(
                            AppRouter.singleView,
                            extra: SingleViewScreenArgs(
                              path: file.path,
                              initialIndex: index,
                              isImage: false,
                            ),
                          );
                        },
                      );
                    },
                    child: DownloadPart(
                      file: file,
                      thumbnail: VideoThumbnailWidget(videoPath: file.path),
                      isVideo: true,
                    ),
                  );
                },
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
