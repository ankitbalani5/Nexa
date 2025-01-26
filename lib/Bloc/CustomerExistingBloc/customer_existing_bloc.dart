import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/CustomerExistingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Constant.dart';

part 'customer_existing_event.dart';
part 'customer_existing_state.dart';

class CustomerExistingBloc extends Bloc<CustomerExistingEvent, CustomerExistingState> {
  CustomerExistingModel? _productData;
  CustomerExistingBloc() : super(CustomerExistingInitial()) {
    on<CustomerExistingRefreshEvent>(_checkCustomerExisting);
  }

  Future<void> _checkCustomerExisting(CustomerExistingRefreshEvent event, Emitter<CustomerExistingState> emit) async {
    /*if(_productData != null){
      final res = await Api.CustomerExistingApi(event.credentials);
      _productData = res;
      emit(CustomerExistingSuccess(_productData!));
    }else{*/
      emit(CustomerExistingLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
      try{
        final response = await Api.customerExistingApi(event.credentials, event.country_code);
        _productData = response;
        if(response != null){
          emit(CustomerExistingSuccess(response));
        }
      }on SocketException{
        emit(CustomerExistingError('Please check your internet connection'));
      }catch(e){
        emit(CustomerExistingError(e.toString()));
      }
    // }
  }
}
