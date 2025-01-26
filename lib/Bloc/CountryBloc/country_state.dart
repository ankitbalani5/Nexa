part of 'country_bloc.dart';

@immutable
sealed class CountryState {}

final class CountryInitial extends CountryState {}
final class CountryLoading extends CountryState {}
final class CountrySuccess extends CountryState {
  CountryModel countryModel;
  CountrySuccess(this.countryModel);
}
final class CountryError extends CountryState {
  String error;
  CountryError(this.error);
}
