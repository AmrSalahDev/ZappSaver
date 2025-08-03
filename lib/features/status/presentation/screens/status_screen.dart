import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/application/cubits/banner_ad_cubit.dart';
import 'package:flutter_status_up/application/cubits/rewarded_ad_cubit.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/extensions/context_extensions.dart';
import 'package:flutter_status_up/core/routes/app_router.dart';
import 'package:flutter_status_up/core/routes/args/single_view_screen_args.dart';
import 'package:flutter_status_up/core/services/di/di.dart';
import 'package:flutter_status_up/core/services/toast_service.dart';
import 'package:flutter_status_up/core/utils/permission_utils.dart';
import 'package:flutter_status_up/core/utils/video_utils.dart';
import 'package:flutter_status_up/core/utils/whatsapp_utils.dart';
import 'package:flutter_status_up/features/status/presentation/cubit/status_cubit.dart';
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
    PermissionUtils.requestStoragePermission();
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
                  child: CustomTabBarView(rewardedAdCubit: _rewardedAdCubit),
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
  const CustomTabBarView({super.key, required this.rewardedAdCubit});

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
                WhatsappImagesTab(rewardedAdCubit: rewardedAdCubit),
                WhatsappVideosTab(rewardedAdCubit: rewardedAdCubit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsappImagesTab extends StatelessWidget {
  final RewardedAdCubit rewardedAdCubit;
  const WhatsappImagesTab({super.key, required this.rewardedAdCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusCubit(),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: WhatsappUtils.getWhatsappStatusesImages(),
              builder: (context, snapshot) => snapshot.hasData
                  ? GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        final file = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            rewardedAdCubit.showIfReady(
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
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                child: Image.file(file, fit: BoxFit.cover),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (WhatsappUtils.isStatusAlreadySaved(
                                    file,
                                  )) {
                                    WhatsappUtils.deleteStatus(file);
                                    context
                                        .read<StatusCubit>()
                                        .notifyStatusChanged();
                                    getIt<ToastService>().showSuccessToast(
                                      context: context,
                                      message: S.of(context).statusDeleted,
                                    );

                                    return;
                                  } else {
                                    await WhatsappUtils.saveStatus(file);
                                    if (context.mounted) {
                                      context
                                          .read<StatusCubit>()
                                          .notifyStatusChanged();

                                      getIt<ToastService>().showSuccessToast(
                                        context: context,
                                        message: S
                                            .of(context)
                                            .statusSavedSuccessfully,
                                      );
                                    }
                                  }
                                },
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 30,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withAlpha(
                                        80,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),

                                    child: BlocBuilder<StatusCubit, StatusState>(
                                      builder: (context, state) {
                                        final isSaved =
                                            WhatsappUtils.isStatusAlreadySaved(
                                              file,
                                            );

                                        return Center(
                                          child: isSaved
                                              ? Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.white,
                                                )
                                              : Text(
                                                  S.of(context).donwload,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: context.textScaler
                                                        .scale(14),
                                                  ),
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsappVideosTab extends StatelessWidget {
  final RewardedAdCubit rewardedAdCubit;
  const WhatsappVideosTab({super.key, required this.rewardedAdCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusCubit(),
      child: FutureBuilder<List<File>>(
        future: WhatsappUtils.getWhatsappStatusesVideos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data!;
          return GridView.builder(
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
                  rewardedAdCubit.showIfReady(
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
                child: Stack(
                  children: [
                    FutureBuilder<Uint8List?>(
                      future: VideoUtils.getVideoThumbnail(file.path),
                      builder: (context, thumbnailSnapshot) {
                        if (thumbnailSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                              strokeWidth: 2,
                            ),
                          );
                        }
                        final bytes = thumbnailSnapshot.data;
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: bytes != null
                                ? DecorationImage(
                                    image: MemoryImage(bytes),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            color: Colors.black12,
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white.withOpacity(0.8),
                        size: 32,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (WhatsappUtils.isStatusAlreadySaved(file)) {
                          WhatsappUtils.deleteStatus(file);
                          context.read<StatusCubit>().notifyStatusChanged();
                          getIt<ToastService>().showSuccessToast(
                            context: context,
                            message: S.of(context).statusDeleted,
                          );

                          return;
                        } else {
                          await WhatsappUtils.saveStatus(file);
                          if (context.mounted) {
                            context.read<StatusCubit>().notifyStatusChanged();

                            getIt<ToastService>().showSuccessToast(
                              context: context,
                              message: S.of(context).statusSavedSuccessfully,
                            );
                          }
                        }
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

                          child: BlocBuilder<StatusCubit, StatusState>(
                            builder: (context, state) {
                              final isSaved =
                                  WhatsappUtils.isStatusAlreadySaved(file);

                              return Center(
                                child: isSaved
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        S.of(context).donwload,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: context.textScaler.scale(
                                            14,
                                          ),
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
