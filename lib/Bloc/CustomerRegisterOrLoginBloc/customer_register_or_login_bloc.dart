import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Constant.dart';
import '../../Model/CustomerRegisterOrLoginModel.dart';

part 'customer_register_or_login_event.dart';
part 'customer_register_or_login_state.dart';

class CustomerRegisterOrLoginBloc extends Bloc<CustomerRegisterOrLoginEvent, CustomerRegisterOrLoginState> {
  CustomerRegisterOrLoginModel? _productData;
  CustomerRegisterOrLoginBloc() : super(CustomerRegisterOrLoginInitial()) {
    on<CustomerRegisterOrLoginRefreshEvent>(_registerOrLogin);
  }

  Future<void> _registerOrLogin(CustomerRegisterOrLoginRefreshEvent event, Emitter<CustomerRegisterOrLoginState> emit) async {
    if(_productData != null){
      final res = await Api.customerRegisterOrLoginApi(event.credentials, event.country_code, event.device_token);
      _productData = res;
      emit(CustomerRegisterOrLoginSuccess(_productData!));
    }else{
      emit(CustomerRegisterOrLoginLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
      try{
        final response = await Api.customerRegisterOrLoginApi(event.credentials, event.country_code, event.device_token);
        _productData = response;
        if(response != null){
          emit(CustomerRegisterOrLoginSuccess(response));
        }
      }on SocketException{
        emit(CustomerRegisterOrLoginError('Please check your internet connection'));
      }catch(e){
        emit(CustomerRegisterOrLoginError(e.toString()));
      }
    }
  }
}
