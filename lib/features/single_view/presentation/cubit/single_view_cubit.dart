import 'package:bloc/bloc.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/load_images_paths_usecase.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/save_image_usecase.dart';
import 'package:flutter_status_up/features/single_view/domain/usecases/share_image_usecase.dart';
import 'package:meta/meta.dart';

part 'single_view_state.dart';

class SingleViewCubit extends Cubit<SingleViewState> {
  final LoadImagesPathsUsecase loadImagesPathsUsecase;
  final SaveImageUsecase saveImageUsecase;
  final ShareImageUseCase shareImageUseCase;

  SingleViewCubit(
    this.loadImagesPathsUsecase,
    this.saveImageUsecase,
    this.shareImageUseCase,
  ) : super(SingleViewInitial());

  List<String> loadImagePaths(String path) {
    return loadImagesPathsUsecase(path);
  }

  void saveImage(String path) {
    saveImageUsecase(path);
  }

  void shareImage(String path) {
    shareImageUseCase(path);
  }
}
