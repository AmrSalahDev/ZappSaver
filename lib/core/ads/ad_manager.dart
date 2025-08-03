import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static const String bannerAdUnitTestId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String openAdTestUnitId =
      'ca-app-pub-3940256099942544/9257395921';

  static String realOpenAdUnitId = 'ca-app-pub-3923222511885441/2692050788';
  static String realRewardedAdUnitId = 'ca-app-pub-3923222511885441/3982734117';
  static String realBannerAdUnitId = 'ca-app-pub-3923222511885441/8520744923';
  static String realWithRewardedAdUnitId =
      'ca-app-pub-3923222511885441/9869469702';

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }
}
