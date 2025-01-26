import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/AllShippingAddressModel.dart';
import 'package:nexa/Model/WareHouseModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant.dart';

part 'all_shipping_address_event.dart';
part 'all_shipping_address_state.dart';

class AllShippingAddressBloc extends Bloc<AllShippingAddressEvent, AllShippingAddressState> {
  AllShippingAddressModel? _productData;
  WareHouseModel? _wareHouseData;
  AllShippingAddressBloc() : super(AllShippingAddressInitial()) {
    on<FetchShippingAddressEvent>(_fetchShippingAddress);
    on<DeleteShippingAddressEvent>(_deleteShippingAddress);
    on<ClearShippingAddressEvent>(_clearShippingAddress);
  }

  Future<void> _fetchShippingAddress(FetchShippingAddressEvent event, Emitter<AllShippingAddressState> emit) async {
    if(_productData != null){
      final res = await Api.allShippingAddressApi();
      final warehouseResponse = await Api.getWarehouseListApi();
      _productData = res;
      _wareHouseData = warehouseResponse;
      emit(AllShippingAddressSuccess(_productData!, warehouseResponse!));
    }else{
      emit(AllShippingAddressLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
      try{
        final response = await Api.allShippingAddressApi();
        final warehouseResponse = await Api.getWarehouseListApi();
        _productData = response;
        _wareHouseData = warehouseResponse;
        if(response != null && warehouseResponse != null){
          emit(AllShippingAddressSuccess(response, warehouseResponse));
        }
      }on SocketException{
        emit(AllShippingAddressError('Please check your internet connection'));
      }catch(e){
        emit(AllShippingAddressError(e.toString()));
      }
    }
  }

  Future<void> _deleteShippingAddress(DeleteShippingAddressEvent event, Emitter<AllShippingAddressState> emit) async {
    final index = _productData!.shippingAddress?.indexWhere((e) => e.id == event.item.id);
    if(index != null && index != -1){
      try {
        _productData?.shippingAddress?.removeAt(index);
        emit(AllShippingAddressSuccess(_productData!, _wareHouseData!));
        await Api.deleteShippingAddressApi(event.item.id.toString()); // Example API call to delete item
      } catch (e) {
        emit(AllShippingAddressError(e.toString()));
      }
    }
  }

  void _clearShippingAddress(ClearShippingAddressEvent event, Emitter<AllShippingAddressState> emit){
    _productData = null;
    emit(AllShippingAddressInitial());
  }
}
