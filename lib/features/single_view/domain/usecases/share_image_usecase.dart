import 'package:flutter_status_up/features/single_view/domain/repositories/single_view_repo.dart';

class ShareImageUseCase {
  final SingleViewRepository singleViewRepository;

  ShareImageUseCase(this.singleViewRepository);

  void call(String path) => singleViewRepository.shareImage(path);
}
