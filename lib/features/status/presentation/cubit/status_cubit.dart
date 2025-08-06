import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_status_up/core/utils/whatsapp_utils.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  StatusCubit() : super(StatusInitial());

  Future<void> loadImages({required bool isFromWhatsapp}) async {
    emit(StatusLoading());
    try {
      final images = isFromWhatsapp
          ? await WhatsappUtils.getWhatsappStatusesImages()
          : await WhatsappUtils.getWhatsappBusinessStatusesImages();
      emit(StatusLoaded(images));
    } catch (e) {
      emit(StatusError('Failed to load images'));
    }
  }

  Future<void> loadVideos({required bool isFromWhatsapp}) async {
    emit(StatusLoading());
    try {
      final images = isFromWhatsapp
          ? await WhatsappUtils.getWhatsappStatusesVideos()
          : await WhatsappUtils.getWhatsappBusinessStatusesVideos();
      emit(StatusLoaded(images));
    } catch (e) {
      emit(StatusError('Failed to load videos'));
    }
  }
}
