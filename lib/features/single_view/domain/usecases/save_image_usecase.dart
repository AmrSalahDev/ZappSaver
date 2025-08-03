import 'package:flutter_status_up/features/single_view/domain/repositories/single_view_repo.dart';

class SaveImageUsecase {
  final SingleViewRepository singleViewRepository;
  SaveImageUsecase(this.singleViewRepository);

  void call(String path) => singleViewRepository.saveImage(path);
}
