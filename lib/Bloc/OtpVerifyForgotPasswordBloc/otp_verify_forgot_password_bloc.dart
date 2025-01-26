import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Api.dart';
import '../../Model/OtpVerifyModel.dart';

part 'otp_verify_forgot_password_event.dart';
part 'otp_verify_forgot_password_state.dart';

class OtpVerifyForgotPasswordBloc extends Bloc<OtpVerifyForgotPasswordEvent, OtpVerifyForgotPasswordState> {
  OtpVerifyForgotPasswordBloc() : super(OtpVerifyForgotPasswordInitial()) {
    on<OtpVerifyForgotPasswordRefreshEvent>(_otpVerifyForgotPassword);
  }

  Future<void> _otpVerifyForgotPassword(OtpVerifyForgotPasswordRefreshEvent event, Emitter<OtpVerifyForgotPasswordState> emit) async {
    emit(OtpVerifyForgotPasswordLoading());
    try{
      final response = await Api.otpVerifyForgotPasswordApi(event.credentials, event.otp);
      if(response!.status == 'success'){
        emit(OtpVerifyForgotPasswordSuccess(response));
      }else{
        emit(OtpVerifyForgotPasswordError(response.message.toString()));
      }
    }on SocketException{
      emit(OtpVerifyForgotPasswordError('Please check your internet connection'));
    }catch(e){
      emit(OtpVerifyForgotPasswordError(e.toString()));
    }
  }
}
