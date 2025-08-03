import 'package:flutter/widgets.dart';
import 'package:flutter_status_up/application/cubits/app_open_ad_cubit.dart';

class AppLifecycleHandler extends WidgetsBindingObserver {
  final AppOpenAdCubit cubit;

  AppLifecycleHandler(this.cubit);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      cubit.showIfReady();
    }
  }
}
