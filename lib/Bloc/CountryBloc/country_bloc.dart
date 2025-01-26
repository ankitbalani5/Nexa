import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/CountryModel.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/ShippingAddress.dart';
import 'package:page_transition/page_transition.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryModel? countryData;

  CountryBloc() : super(CountryInitial()) {
    on<CountryRefreshEvent>(_fetchCountry);
    on<AddShippingAddEvent>(_addNewAddress);
  }

  Future<void> _fetchCountry(CountryRefreshEvent event, Emitter<CountryState> emit) async {
    // if(countryData != null){
    //   final response = await Api.countryApi();
    //   countryData = response;
    //   if(response != null){
    //     emit(CountrySuccess(response));
    //   }
    // }else{
      emit(CountryLoading());
      try{
        final response = await Api.countryApi();
        countryData = response;
        if(response != null){
          emit(CountrySuccess(response));
        }
      }on SocketException{
        emit(CountryError('Please check your internet connection'));
      }catch(e){
        emit(CountryError(e.toString()));
      }
    // }

  }

  Future<void> _addNewAddress(AddShippingAddEvent event, Emitter<CountryState> emit) async {
    emit(CountryLoading());
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
            // emit(AddShippingAddressSuccess(value));
            emit(CountrySuccess(countryData!));
            // Use the context to perform navigation
            // Navigator
            // Navigator.pushReplacement(event.context,
            //     PageTransition(child: ShippingAddress(), type: PageTransitionType.rightToLeft));
          } else {
            // Handle error from getAddressApi
            emit(CountryError('Failed to retrieve addresses'));
          }
        }else {
          // Handle error from addShippingAddressApi
          emit(CountryError('Failed to add address'));
        }
      });
    }on SocketException{
      emit(CountryError('Please check your internet connection'));
    }catch(e){
      emit(CountryError(e.toString()));
    }
  }

  // Future<void> _addNewAddress(AddShippingAddEvent event, Emitter<CountryState> emit) async {
  //   emit(CountryLoading());
  //   try{
  //     // final response = await Api.addShippingAddressApi(event.country_id);
  //     // Call the API to add a new address
  //     final response = await Api.addShippingAddressApi(
  //         event.address_id, event.name, event.address,
  //         event.country, event.state, event.city, event.zip_code, event.country_code,
  //         event.phone, event.primary_address).then((value) async{
  //           if(value!.status == 'success'){
  //             // If address addition is successful, call getAddressApi
  //             final addressResponse = await Api.allShippingAddressApi();
  //
  //             if (addressResponse!.status == 'success') {
  //               // On successful retrieval of addresses, navigate to the new screen
  //               emit(CountrySuccess(countryData!));
  //               // Use the context to perform navigation
  //               Navigator.pushReplacement(event.context,
  //                   PageTransition(child: ShippingAddress(), type: PageTransitionType.rightToLeft));
  //             } else {
  //               // Handle error from getAddressApi
  //               emit(CountryError('Failed to retrieve addresses'));
  //             }
  //           }else {
  //             // Handle error from addShippingAddressApi
  //             emit(CountryError('Failed to add address'));
  //           }
  //     });
  //   }on SocketException{
  //     emit(CountryError('Please check your internet connection'));
  //   }catch(e){
  //     emit(CountryError(e.toString()));
  //   }
  // }


}
