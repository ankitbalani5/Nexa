part of 'city_bloc.dart';

@immutable
sealed class CityEvent {}
class SelectCityEvent extends CityEvent {
  String state_id;
  SelectCityEvent(this.state_id);
}
