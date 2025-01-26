part of 'city_bloc.dart';

@immutable
sealed class CityState {}

final class CityInitial extends CityState {}
final class CityLoading extends CityState {}
final class CitySuccess extends CityState {
  CityModel cityModel;
  CitySuccess(this.cityModel);
}
final class CityError extends CityState {
  String error;
  CityError(this.error);
}
