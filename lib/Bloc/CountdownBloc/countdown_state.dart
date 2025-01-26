part of 'countdown_bloc.dart';

@immutable
abstract class CountdownState {}

class CountdownInitial extends CountdownState {}
class CountdownSuccess extends CountdownState {
  final hour;
  final min;
  final sec;
  CountdownSuccess({this.hour = '', this.min = '', this.sec = ''});
}
