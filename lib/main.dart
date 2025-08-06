import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/application/cubits/app_open_ad_cubit.dart';
import 'package:flutter_status_up/core/constants/app_colors.dart';
import 'package:flutter_status_up/core/routes/app_router.dart';
import 'package:flutter_status_up/core/services/di/di.dart';
import 'package:flutter_status_up/core/utils/system_utils.dart';
import 'package:flutter_status_up/application/cubits/language_cubit.dart';
import 'package:flutter_status_up/application/cubits/language_state.dart';
import 'package:flutter_status_up/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUtils.makePortraitOnly();
  //await AdManager.initialize();
  // MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(testDeviceIds: ['080D5E529767D4F043371956CF5C1C83']),
  // );

  setupDependencies();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<LanguageCubit>())],
      child: const StatusApp(),
    ),
  );
}

class StatusApp extends StatefulWidget {
  const StatusApp({super.key});

  @override
  State<StatusApp> createState() => _StatusAppState();
}

class _StatusAppState extends State<StatusApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getIt<AppOpenAdCubit>().loadAppOpenAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getIt<AppOpenAdCubit>().showIfReady();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      buildWhen: (prev, curr) => curr is LanguageChanged,
      builder: (context, state) {
        final locale = state is LanguageChanged
            ? Locale(state.locale.code)
            : const Locale('en');

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AppColors.primaryColor,
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: AppColors.primaryColor,
            ),

            brightness: Brightness.light,
            appBarTheme: AppBarTheme(backgroundColor: Colors.white),
            scaffoldBackgroundColor: Colors.white,
            drawerTheme: DrawerThemeData(
              backgroundColor: AppColors.primaryColor,
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.primaryColor,
              selectionColor: AppColors.primaryColor.withAlpha(50),
              selectionHandleColor: AppColors.primaryColor,
            ),
          ),
        );
      },
    );
  }
}
