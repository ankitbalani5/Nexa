import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../Api.dart';
import '../../Model/CancelOrderModel.dart';
import '../../NavBar.dart';

part 'cancel_order_event.dart';
part 'cancel_order_state.dart';

class CancelOrderBloc extends Bloc<CancelOrderEvent, CancelOrderState> {
  CancelOrderBloc() : super(CancelOrderInitial()) {
    on<CancelOrderRefreshEvent>(_reOrder);
  }
  Future<void> _reOrder(CancelOrderRefreshEvent event, Emitter<CancelOrderState> emit) async {
    emit(CancelOrderLoading());
    try{
      final response = await Api.cancelOrderApi(event.order_id);
      if(response != null){
        emit(CancelOrderSuccess(response));

        Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(builder: (context) => NavBar(i: 4,)), (route) => false,);
      }
    }on SocketException{
      emit(CancelOrderError('Please check your internet connection'));
    }catch(e){
      emit(CancelOrderError(e.toString()));

    }
  }
}
