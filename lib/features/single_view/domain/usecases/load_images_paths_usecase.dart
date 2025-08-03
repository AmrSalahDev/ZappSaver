import 'package:flutter_status_up/features/single_view/domain/repositories/single_view_repo.dart';

class LoadImagesPathsUsecase {
  final SingleViewRepository singleViewRepository;

  const LoadImagesPathsUsecase(this.singleViewRepository);

  List<String> call(String path) => singleViewRepository.loadImagePaths(path);
}
