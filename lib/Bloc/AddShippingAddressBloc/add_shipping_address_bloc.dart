import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:page_transition/page_transition.dart';

import '../../Api.dart';
import '../../Model/AddShippingAddressModel.dart';
import '../../Screens/ProfileScreens/ShippingAddress/ShippingAddress.dart';

part 'add_shipping_address_event.dart';
part 'add_shipping_address_state.dart';

class AddShippingAddressBloc extends Bloc<AddShippingAddressEvent, AddShippingAddressState> {
  AddShippingAddressBloc() : super(AddShippingAddressInitial()) {
    on<AddShippingAddressRefreshEvent>(_addNewAddress);
  }

  Future<void> _addNewAddress(AddShippingAddressRefreshEvent event, Emitter<AddShippingAddressState> emit) async {
    emit(AddShippingAddressLoading());
    try{
      // final response = await Api.addShippingAddressApi(event.country_id);
      // Call the API to add a new address
      final response = await Api.addShippingAddressApi(
          event.address_id, event.name, event.address,
          event.country, event.state, event.city, event.zip_code, event.country_code,
          event.phone, event.primary_address).then((value) async{
        if(value!.status == 'success'){
          // If address addition is successful, call getAddressApi
          final addressResponse = await Api.allShippingAddressApi();

          if (addressResponse!.status == 'success') {
            // On successful retrieval of addresses, navigate to the new screen
            emit(AddShippingAddressSuccess(value));
            // Use the context to perform navigation
            // Navigator
            // Navigator.pushReplacement(event.context,
            //     PageTransition(child: ShippingAddress(), type: PageTransitionType.rightToLeft));
          } else {
            // Handle error from getAddressApi
            emit(AddShippingAddressError('Failed to retrieve addresses'));
          }
        }else {
          // Handle error from addShippingAddressApi
          emit(AddShippingAddressError('Failed to add address'));
        }
      });
    }on SocketException{
      emit(AddShippingAddressError('Please check your internet connection'));
    }catch(e){
      emit(AddShippingAddressError(e.toString()));
    }
  }
  }
