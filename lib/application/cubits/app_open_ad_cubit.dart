import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_status_up/core/ads/ad_manager.dart';
import 'package:flutter/material.dart';

enum AppOpenAdStatus { initial, loading, loaded, failed, shown }

class AppOpenAdCubit extends Cubit<AppOpenAdStatus> {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;

  AppOpenAdCubit() : super(AppOpenAdStatus.initial);

  void loadAppOpenAd() {
    return;
    emit(AppOpenAdStatus.loading);

    AppOpenAd.load(
      adUnitId: AdManager.openAdTestUnitId, // Replace with actual/test ID
      request: const AdRequest(),

      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          emit(AppOpenAdStatus.loaded);
          debugPrint('AppOpenAd loaded');
        },
        onAdFailedToLoad: (error) {
          emit(AppOpenAdStatus.failed);
          debugPrint('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  void showIfReady() {
    if (_appOpenAd != null && !_isShowingAd) {
      _isShowingAd = true;

      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint('AppOpenAd showing');
        },
        onAdDismissedFullScreenContent: (ad) {
          debugPrint('AppOpenAd dismissed');
          ad.dispose();
          _appOpenAd = null;
          _isShowingAd = false;
          emit(AppOpenAdStatus.initial);
          loadAppOpenAd(); // Reload after dismissal
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint('AppOpenAd failed to show: $error');
          ad.dispose();
          _appOpenAd = null;
          _isShowingAd = false;
          emit(AppOpenAdStatus.failed);
        },
      );

      _appOpenAd!.show();
      emit(AppOpenAdStatus.shown);
    } else {
      debugPrint('AppOpenAd not ready or already showing');
    }
  }

  @override
  Future<void> close() {
    _appOpenAd?.dispose();
    return super.close();
  }
}
