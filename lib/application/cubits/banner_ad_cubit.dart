// banner_ad_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/core/ads/ad_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class BannerAdCubit extends Cubit<BannerAd?> {
  BannerAdCubit() : super(null);

  Future<void> loadBannerAd(BuildContext context) async {
    return;
    final width = MediaQuery.of(context).size.width.truncate();
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );

    if (size == null) return;

    final ad = BannerAd(
      adUnitId: AdManager.bannerAdUnitTestId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => emit(ad as BannerAd),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed: $error');
        },
      ),
    );

    await ad.load();
  }

  void dispose() {
    state?.dispose();
    emit(null);
  }
}
