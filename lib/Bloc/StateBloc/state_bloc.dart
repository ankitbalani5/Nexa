import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/StateModel.dart';

import '../../Api.dart';

part 'state_event.dart';
part 'state_state.dart';

class StateBloc extends Bloc<StateEvent, StateState> {
  StateBloc() : super(StateInitial()) {
    on<SelectStateEvent>(_fetchState);
  }

Future<void> _fetchState(SelectStateEvent event, Emitter<StateState> emit) async {
  emit(StateLoading());
  try{
    final response = await Api.stateApi(event.country_id);
    if(response != null){
      print('state Bloc');
      emit(StateSuccess(response));
    }
  }on SocketException{
    emit(StateError('Please check your internet connection'));
  }catch(e){
    emit(StateError(e.toString()));
  }
}
}
