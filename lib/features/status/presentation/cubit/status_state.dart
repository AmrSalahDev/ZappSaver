part of 'status_cubit.dart';

abstract class StatusState {}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final List<File> files;
  StatusLoaded(this.files);
}

class StatusError extends StatusState {
  final String message;
  StatusError(this.message);
}
