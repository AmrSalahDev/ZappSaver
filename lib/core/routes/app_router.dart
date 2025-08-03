import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/application/cubits/banner_ad_cubit.dart';
import 'package:flutter_status_up/core/routes/args/single_view_screen_args.dart';
import 'package:flutter_status_up/core/services/di/di.dart';
import 'package:flutter_status_up/features/home/presentation/screens/home_screen.dart';
import 'package:flutter_status_up/features/recovery_messages/presentation/screens/recovery_chat_screen.dart';
import 'package:flutter_status_up/features/recovery_messages/presentation/screens/recovery_messages_screen.dart';
import 'package:flutter_status_up/features/select_lang/presentation/screens/select_lang_screen.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/load_images_paths_usecase.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/save_image_usecase.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/share_image_usecase.dart';
import 'package:flutter_status_up/features/single_view/presentation/cubit/single_view_cubit.dart';
import 'package:flutter_status_up/features/single_view/presentation/screens/single_view_screen.dart';
import 'package:flutter_status_up/features/start/presentation/screens/start_screen.dart';
import 'package:flutter_status_up/features/status/presentation/screens/status_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/home';
  static const String start = '/start';
  static const String selectLang = '/selectLang';
  static const String directChat = '/directChat';
  static const String singleView = '/singleView';
  static const String status = '/status';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String privacyPolicy = '/privacyPolicy';
  static const String recoveryMessages = '/recoveryMessages';
  static const String recoveryChat = '/recoveryChat';
}

final router = GoRouter(
  initialLocation: AppRouter.home,
  routes: [
    GoRoute(
      path: AppRouter.start,
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: AppRouter.home,
      builder: (context, state) => MultiBlocProvider(
        providers: [BlocProvider(create: (context) => getIt<BannerAdCubit>())],
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: AppRouter.singleView,
      builder: (context, state) {
        final args = state.extra as SingleViewScreenArgs;
        return BlocProvider(
          create: (context) => SingleViewCubit(
            getIt<LoadImagesPathsUsecase>(),
            getIt<SaveImageUsecase>(),
            getIt<ShareImageUseCase>(),
          ),
          child: SingleViewScreen(
            path: args.path,
            initialIndex: args.initialIndex,
            isImage: args.isImage,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRouter.status,
      builder: (context, state) {
        final isFromWhatsapp = state.extra as bool? ?? false;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<BannerAdCubit>()),
          ],
          child: StatusScreen(isFromWhatsapp: isFromWhatsapp),
        );
      },
    ),
    GoRoute(
      path: AppRouter.selectLang,
      builder: (context, state) {
        final isFromHome = state.extra as bool;
        return LanguageScreen(isFromHome: isFromHome);
      },
    ),
    GoRoute(
      path: AppRouter.directChat,
      builder: (context, state) => const StatusScreen(isFromWhatsapp: true),
    ),
    GoRoute(
      path: AppRouter.recoveryMessages,
      builder: (context, state) => const RecoveryMessages(),
    ),
    GoRoute(
      path: AppRouter.recoveryChat,
      builder: (context, state) => const RecoveryChatScreen(),
    ),
  ],
);
