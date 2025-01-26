part of 'countdown_bloc.dart';

@immutable
abstract class CountdownEvent {}
class StartCountDown extends CountdownEvent{
  final hour;
  final min;
  final sec;
  StartCountDown({this.hour, this.min, this.sec});
}
