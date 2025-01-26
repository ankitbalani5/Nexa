import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Constant.dart';
import '../../Model/CustomerSupportModel.dart';

part 'customer_support_event.dart';
part 'customer_support_state.dart';

class CustomerSupportBloc extends Bloc<CustomerSupportEvent, CustomerSupportState> {
  CustomerSupportModel? _productData;
  CustomerSupportBloc() : super(CustomerSupportInitial()) {
    on<CustomerSupportRefreshEvent>(_fetchCustomerSupport);
  }

  Future<void> _fetchCustomerSupport(CustomerSupportRefreshEvent event, Emitter<CustomerSupportState> emit) async {
    if(_productData != null){
      final res = await Api.customerSupportApi();
      _productData = res;
      emit(CustomerSupportSuccess(_productData!));
    }else{
      emit(CustomerSupportLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
      try{
        final response = await Api.customerSupportApi();
        _productData = response;
        if(response != null){
          emit(CustomerSupportSuccess(response));
        }
      }on SocketException{
        emit(CustomerSupportError('Please check your internet connection'));
      }catch(e){
        emit(CustomerSupportError(e.toString()));
      }
    }
  }
}
