import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Model/HomeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeModel? _productData;
  HomeBloc() : super(HomeInitial()) {
    on<HomeRefreshEvent>(_homeDataFetch);
    on<AddHomeWishlistEvent>(_addWishlist);
    on<HomeLogoutEvent>(_handleLogout);
  }
  Future<void> _homeDataFetch(HomeRefreshEvent event, Emitter<HomeState> emit) async {
    if(_productData != null){
      print('token: ${Constant.token}');
      final res = await Api.homeApi(event.category_name, event.product_name);
      _productData = res;
      emit(HomeSuccess(_productData!));
    }else{
      emit(HomeLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = await pref.getString('token').toString();
      print('token:::::::::::::::::::::::: ${pref.getString('token').toString()}');
      Constant.firstName = pref.getString('first_name').toString();
      Constant.lastName = pref.getString('last_name').toString();
      Constant.email = pref.getString('email').toString();
      Constant.country = pref.getString('country').toString();
      Constant.countryCode = pref.getString('country_code').toString();
      Constant.phone = pref.getString('phone').toString();
      Constant.image = pref.getString('image').toString();
      try{
        final response = await Api.homeApi(event.category_name, event.product_name);
        _productData = response;
        if(response != null){
          emit(HomeSuccess(response));
        }
      }on SocketException{
        emit(HomeError('Please check your internet connection'));
      }catch(e){
        emit(HomeError(e.toString()));
      }
    }

  }

  Future<void> _addWishlist(AddHomeWishlistEvent event, Emitter<HomeState> emit) async {
    int index = int.parse(_productData!.products!.indexWhere((e) => e.id == event.item.id).toString());

    if(index != -1) {
      final updatedData = _productData?.products![index].copyWith(
          // loading: _productData?.products![index].loading == true ? false : true,
        inWishlist: _productData?.products![index].inWishlist == true ? false : true,
      );
      try {
        final allUpdateData = List<Products>.from(
            _productData!.products!);
        allUpdateData[index] = updatedData!;

        final updateCartModel = _productData?.copyWith(
          products: allUpdateData,
        );

        _productData = updateCartModel;
        emit(HomeSuccess(_productData!));


      } catch (e) {
        print(e.toString());
      }

      await Api.addWishlistApi(event.item.id.toString()).then((value) {
        if(value?.status == 'success'){
          // if(index != -1){
          //   final updatedData = _productData?.products![index].copyWith(
          //       inWishlist: _productData?.products![index].inWishlist == true ? false : true,
          //       loading: _productData?.products![index].loading == true ? false : true
          //   );
          //   try{
          //     final allUpdateData = List<Products>.from(_productData!.products!);
          //     allUpdateData[index] = updatedData!;
          //
          //     final updateCartModel = _productData?.copyWith(
          //       products: allUpdateData,
          //     );
          //
          //     _productData = updateCartModel;
          //     emit(HomeSuccess(_productData!));
          //
          //   }catch(e){
          //     print(e.toString());
          //   }
          //   // });
          // }
        }else{
          Fluttertoast.showToast(msg: value!.message.toString());
          // if(index != -1){
          //   final updatedData = _productData?.products![index].copyWith(
          //       inWishlist: _productData?.products![index].inWishlist == true ? false : true,
          //       loading: _productData?.products![index].loading == true ? false : true
          //   );
          //   try{
          //     final allUpdateData = List<Products>.from(_productData!.products!);
          //     allUpdateData[index] = updatedData!;
          //
          //     final updateCartModel = _productData?.copyWith(
          //       products: allUpdateData,
          //     );
          //
          //     _productData = updateCartModel;
          //     emit(HomeSuccess(_productData!));
          //
          //   }catch(e){
          //     print(e.toString());
          //   }
          //   // });
          // }
        }
      });
    }
  }

  void _handleLogout(HomeLogoutEvent event, Emitter<HomeState> emit) {
    _productData = null; // Reset the product data
    emit(HomeInitial()); // Optionally reset to initial state or any other state you prefer
  }
}
