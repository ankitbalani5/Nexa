import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';

import '../../Model/EmailOtpVerifyModel.dart';


part 'otp_verify_email_event.dart';
part 'otp_verify_email_state.dart';

class OtpVerifyEmailBloc extends Bloc<OtpVerifyEmailEvent, OtpVerifyEmailState> {
  OtpVerifyEmailBloc() : super(OtpVerifyEmailInitial()) {
    on<OtpVerifyNewEvent>(_otpVerifyPassword);
  }

  Future<void> _otpVerifyPassword(OtpVerifyNewEvent event, Emitter<OtpVerifyEmailState> emit) async {
    emit(OtpVerifyEmailLoading());
    try{
      final response = await Api.emailOtpVerifyApi(event.credentials, event.otp);
      if(response!.status == 'success'){
        emit(OtpVerifyEmailSuccess(response));
      }else{
        emit(OtpVerifyEmailError(response.message.toString()));
      }
    }on SocketException{
      emit(OtpVerifyEmailError('Please check your internet connection'));
    }catch(e){
      emit(OtpVerifyEmailError(e.toString()));
    }
  }
}
