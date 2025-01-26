import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/SuggestionModel.dart';

import '../../Api.dart';

part 'suggestion_event.dart';
part 'suggestion_state.dart';

class SuggestionBloc extends Bloc<SuggestionEvent, SuggestionState> {
  SuggestionModel? _productData;
  SuggestionBloc() : super(SuggestionInitial()) {
    on<SuggestionLoadEvent>(_suggestionLoad);
  }

  void _suggestionLoad(SuggestionLoadEvent event, Emitter<SuggestionState> emit)async {
    emit(SuggestionLoading());
    try{
      final response = await Api.suggestionApi(event.keyword);
      _productData = response;
      if(response != null){
        emit(SuggestionSuccess(response));
      }
    }on SocketException{
      emit(SuggestionError('Please check your internet connection'));
    }catch(e){
      emit(SuggestionError(e.toString()));

    }
  }
}
