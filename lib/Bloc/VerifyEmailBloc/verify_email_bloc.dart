import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Api.dart';
import '../../Model/VerifyEmailModel.dart';

part 'verify_email_event.dart';
part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc() : super(VerifyEmailInitial()) {
    on<VerifyEmailNewEvent>(_verifyEmail);
  }

  Future<void> _verifyEmail(VerifyEmailNewEvent event, Emitter<VerifyEmailState> emit) async {
    emit(VerifyEmailLoading());
    try{
      final response = await Api.verifyEmailApi(event.credentials);
      if(response!.status == 'success'){
        emit(VerifyEmailSuccess(response));
      }else{
        emit(VerifyEmailError(response.message.toString()));
      }
    }on SocketException{
      emit(VerifyEmailError('Please check your internet connection'));
    }catch(e){
      emit(VerifyEmailError(e.toString()));
    }
  }
}
