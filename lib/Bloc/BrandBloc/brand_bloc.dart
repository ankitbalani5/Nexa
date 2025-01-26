import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/BrandModel.dart';

import '../../Api.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  BrandBloc() : super(BrandInitial()) {
    on<BrandFetchEvent>(_fetchBrand);
  }

  Future<void> _fetchBrand(BrandFetchEvent event, Emitter<BrandState> emit) async {
    emit(BrandLoading());
    try{
      final response = await Api.brandApi();
      if(response!.status == 'success'){
        emit(BrandSuccess(response));
      }/*else{
        emit(BrandError(response.message.toString()));
      }*/
    }on SocketException{
      emit(BrandError('Please check your internet connection'));
    }catch(e){
      emit(BrandError(e.toString()));
    }
  }
}
