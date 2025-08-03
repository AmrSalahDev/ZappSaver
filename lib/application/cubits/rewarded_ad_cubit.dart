import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_status_up/core/ads/ad_manager.dart';
import 'package:flutter/material.dart';

enum RewardedAdStatus { initial, loading, loaded, failed, completed }

class RewardedAdCubit extends Cubit<RewardedAdStatus> {
  RewardedAd? _rewardedAd;

  RewardedAdCubit() : super(RewardedAdStatus.initial);

  void loadRewardedAd() {
    return;
    emit(RewardedAdStatus.loading);

    RewardedAd.load(
      adUnitId: AdManager.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          emit(RewardedAdStatus.loaded);
          debugPrint('RewardedAd loaded');
        },
        onAdFailedToLoad: (error) {
          emit(RewardedAdStatus.failed);
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void showIfReady({
    required VoidCallback onRewardEarned,
    required VoidCallback elseDoThis,
  }) {
    if (state == RewardedAdStatus.loaded) {
      showRewardedAd(onRewardEarned);
    } else {
      debugPrint('Ad not ready yet');
      elseDoThis();
    }
  }

  void showRewardedAd(VoidCallback onRewardEarned) {
    if (_rewardedAd == null) {
      debugPrint('RewardedAd not ready');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        emit(RewardedAdStatus.initial);
        loadRewardedAd(); // Optionally reload
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        emit(RewardedAdStatus.failed);
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        onRewardEarned();
        emit(RewardedAdStatus.completed);
      },
    );
  }

  @override
  Future<void> close() {
    _rewardedAd?.dispose();
    return super.close();
  }
}
