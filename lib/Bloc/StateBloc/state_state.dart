part of 'state_bloc.dart';

@immutable
sealed class StateState {}

final class StateInitial extends StateState {}
final class StateLoading extends StateState {}
final class StateSuccess extends StateState {
  StateModel stateModel;
  StateSuccess(this.stateModel);
}
final class StateError extends StateState {
  String error;
  StateError(this.error);
}
