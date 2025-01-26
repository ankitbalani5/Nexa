import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Api.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordRefreshEvent>(_resetPassword);
  }

  Future<void> _resetPassword(ResetPasswordRefreshEvent event, Emitter<ResetPasswordState> emit) async {
    try{
      final response = await Api.resetPasswordApi(event.credentials, event.password);
      if(response['status'] == 'success'){
        emit(ResetPasswordSuccess(response['message'].toString()));
      }else{
        emit(ResetPasswordError(response['message'].toString()));
      }
    }on SocketException{
      emit(ResetPasswordError('Please check your internet connection'));
    }catch(e){
      emit(ResetPasswordError(e.toString()));
    }
  }
}
