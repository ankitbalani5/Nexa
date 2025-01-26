import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/CityModel.dart';

import '../../Api.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc() : super(CityInitial()) {
    on<SelectCityEvent>(_fetchCity);
  }

Future<void> _fetchCity(SelectCityEvent event, Emitter<CityState> emit) async {
  emit(CityLoading());
  try{
    final response = await Api.cityApi(event.state_id);
    if(response != null){
      print('city Bloc');
      emit(CitySuccess(response));
    }
  }on SocketException{
    emit(CityError('Please check your internet connection'));
  }catch(e){
    emit(CityError(e.toString()));
  }
}
}
