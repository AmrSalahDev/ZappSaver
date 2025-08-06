import 'package:flutter_status_up/application/cubits/app_open_ad_cubit.dart';
import 'package:flutter_status_up/application/cubits/banner_ad_cubit.dart';
import 'package:flutter_status_up/application/cubits/rewarded_ad_cubit.dart';
import 'package:flutter_status_up/core/services/toast_service.dart';
import 'package:flutter_status_up/features/select_lang/data/repositories/language_repository_impl.dart';
import 'package:flutter_status_up/features/select_lang/domain/repositories/language_repository.dart';
import 'package:flutter_status_up/features/select_lang/domain/usecases/chanage_language_usecase.dart';
import 'package:flutter_status_up/features/select_lang/domain/usecases/get_saved_lang_usecase.dart';
import 'package:flutter_status_up/application/cubits/language_cubit.dart';
import 'package:flutter_status_up/features/single_view/data/repositories/single_view_repo_impl.dart';
import 'package:flutter_status_up/features/single_view/domain/repositories/single_view_repo.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/load_images_paths_usecase.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/save_image_usecase.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/share_image_usecase.dart';
import 'package:flutter_status_up/features/single_view/presentation/cubit/single_view_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton(() => ToastService());

  // Repositories
  getIt.registerLazySingleton<LanguageRepository>(
    () => LanguageRepositoryImpl(),
  );
  getIt.registerLazySingleton<SingleViewRepository>(() => SingleViewRepoImpl());

  // UseCases
  getIt.registerLazySingleton(() => GetSavedLangUsecase(getIt.get()));
  getIt.registerLazySingleton(() => ChangeLanguageUseCase(getIt.get()));
  getIt.registerLazySingleton(() => LoadImagesPathsUsecase(getIt.get()));
  getIt.registerLazySingleton(() => SaveImageUsecase(getIt.get()));
  getIt.registerLazySingleton(() => ShareImageUseCase(getIt.get()));

  // Cubit
  getIt.registerLazySingleton(() => LanguageCubit(getIt.get(), getIt.get()));
  getIt.registerLazySingleton(
    () => SingleViewCubit(getIt.get(), getIt.get(), getIt.get()),
  );
  getIt.registerLazySingleton(() => AppOpenAdCubit());
  getIt.registerFactory(() => RewardedAdCubit());
  getIt.registerFactory(() => BannerAdCubit());
}
