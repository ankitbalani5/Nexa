import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/LoginModel.dart';

import '../../Api.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRefreshEvent>(login);
  }
  Future<void> login(LoginRefreshEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try{
      final response = await Api.loginApi(event.credentials, event.password, event.device_token);
      if(response!.status == 'success'){
        emit(LoginSuccess(response));
      }else{
        emit(LoginError(response.message.toString()));
      }
    }on SocketException{
      emit(LoginError('Please check your internet connection'));
    }catch(e){
      emit(LoginError(e.toString()));
    }
  }
}
