part of 'state_bloc.dart';

@immutable
sealed class StateEvent {}
class SelectStateEvent extends StateEvent {
  String country_id;
  SelectStateEvent(this.country_id);
}
