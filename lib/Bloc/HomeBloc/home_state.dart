part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
final class HomeLoading extends HomeState {}
final class HomeSuccess extends HomeState {
  HomeModel homeModel;
  HomeSuccess(this.homeModel);
}
final class HomeError extends HomeState {
  String error;
  HomeError(this.error);
}
