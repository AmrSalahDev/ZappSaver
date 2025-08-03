import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  StatusCubit() : super(StatusInitial());

  void notifyStatusChanged() {
    emit(StatusUpdated());
  }
}
