import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'countdown_event.dart';
part 'countdown_state.dart';

class CountdownBloc extends Bloc<CountdownEvent, CountdownState> {
  CountdownBloc() : super(CountdownInitial()) {
    on<StartCountDown>(_startCountdown);
  }

  void _startCountdown(StartCountDown event, Emitter<CountdownState> emit){
    emit(CountdownSuccess(hour: event.hour, min: event.min, sec: event.sec));
  }
}
