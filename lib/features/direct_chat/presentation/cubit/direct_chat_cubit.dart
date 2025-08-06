import 'package:flutter_bloc/flutter_bloc.dart';

enum DirectChatStatus { initial, foucusd, unfoucusd }

class DirectChatCubit extends Cubit<DirectChatStatus> {
  DirectChatCubit() : super(DirectChatStatus.initial);

  void focusStatus(bool isFoucusd) {
    if (isFoucusd) {
      emit(DirectChatStatus.foucusd);
    } else {
      emit(DirectChatStatus.unfoucusd);
    }
  }
}
