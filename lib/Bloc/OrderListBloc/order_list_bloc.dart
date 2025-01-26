import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';

import '../../Constant.dart';
import '../../Model/OrderListModel.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListModel? _productData;
  OrderListBloc() : super(OrderListInitial()) {
    on<OrderListLoadEvent>(_loadOrder);
    on<CancelOrderEvent>(_cancelOrder);
    on<ClearDataEvent>(_clearData);
  }

  Future<void> _loadOrder(OrderListLoadEvent event, Emitter<OrderListState> emit) async {
    emit(OrderListLoading());
    try{
      final response = await Api.orderListApi(event.status);
      final reviewResponse = await Api.orderListApi('to_review');
      _productData = response;
      if(response != null){
        emit(OrderListSuccess(response, reviewResponse!));
      }
    }on SocketException{
      emit(OrderListError('Please check your internet connection'));
    }catch(e){
      emit(OrderListError(e.toString()));

    }
  }

  Future<void> _cancelOrder(CancelOrderEvent event, Emitter<OrderListState> emit) async {
    // emit(CancelOrderLoading());
    Constant.showDialogProgress(event.context);
    try{
      final response = await Api.cancelOrderApi(event.order_id);
      if(response != null){
        Navigator.pop(event.context);
        final response = await Api.orderListApi('all');
        final reviewResponse = await Api.orderListApi('to_review');
        emit(OrderListSuccess(response!, reviewResponse!));
      }
    }on SocketException{
      emit(OrderListError('Please check your internet connection'));
    }catch(e){
      emit(OrderListError(e.toString()));

    }
  }

  void _clearData(ClearDataEvent event, Emitter<OrderListState> emit){
    _productData = null;
    emit(OrderListInitial());
  }
}
