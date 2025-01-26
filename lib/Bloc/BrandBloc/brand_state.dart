part of 'brand_bloc.dart';

@immutable
sealed class BrandState {}

final class BrandInitial extends BrandState {}
final class BrandLoading extends BrandState {}
final class BrandSuccess extends BrandState {
  BrandModel brandModel;
  BrandSuccess(this.brandModel);
}
final class BrandError extends BrandState {
  final String error;
  BrandError(this.error);
}
