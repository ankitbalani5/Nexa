import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/PlaceOrderModel.dart';

import '../../Api.dart';

part 'place_order_event.dart';
part 'place_order_state.dart';

class PlaceOrderBloc extends Bloc<PlaceOrderEvent, PlaceOrderState> {
  PlaceOrderBloc() : super(PlaceOrderInitial()) {
    on<PlaceOrderRefreshEvent>(_placeOrder);
  }

  Future<void> _placeOrder(PlaceOrderRefreshEvent event, Emitter<PlaceOrderState> emit) async {
    emit(PlaceOrderLoading());
    try {
      final response = await Api.placeOrderApi(cart_id: event.cart_id, sub_total_amount: event.sub_total_amount,
          item_discount_amount: event.item_discount_amount, total_amount: event.total_amount,
          payment_mode: event.payment_mode, delivery_option: event.delivery_option, warehouse_id: event.warehouse_id, address_id: event.address_id,
          coupon_id: event.coupon_id, message: event.message);
      if (response != null) {
        print('response :: $response');
        emit(PlaceOrderSuccess(response));
      }else{
        emit(PlaceOrderError(response!.message.toString()));
      }
    } catch (e) {
      emit(PlaceOrderError(e.toString()));
    }
  }
}
