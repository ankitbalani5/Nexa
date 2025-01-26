import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Api.dart';
import '../../Model/ForgotPasswordModel.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordRefreshEvent>(_forgotPassword);
  }

  Future<void> _forgotPassword(ForgotPasswordRefreshEvent event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());
    try{
      final response = await Api.forgotPasswordApi(event.credentials);
      if(response!.status == 'success'){
        emit(ForgotPasswordSuccess(response));
      }else{
        emit(ForgotPasswordError(response.message.toString()));
      }
    }on SocketException{
      emit(ForgotPasswordError('Please check your internet connection'));
    }catch(e){
      emit(ForgotPasswordError(e.toString()));
    }
  }
}
