import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/ReOrderModel.dart';

part 're_order_event.dart';
part 're_order_state.dart';

class ReOrderBloc extends Bloc<ReOrderEvent, ReOrderState> {
  ReOrderBloc() : super(ReOrderInitial()) {
    on<ReOrderRefreshEvent>(_reOrder);
  }

  Future<void> _reOrder(ReOrderRefreshEvent event, Emitter<ReOrderState> emit) async {
    emit(ReOrderLoading());
    try{
      final response = await Api.reOrderApi(event.order_id);
      if(response != null){
        emit(ReOrderSuccess(response));
      }
    }on SocketException{
      emit(ReOrderError('Please check your internet connection'));
    }catch(e){
      emit(ReOrderError(e.toString()));

    }
  }
}
