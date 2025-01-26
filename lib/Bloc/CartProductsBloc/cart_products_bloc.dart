import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Model/CartProductsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Constant.dart';

part 'cart_products_event.dart';
part 'cart_products_state.dart';

class CartProductsBloc extends Bloc<CartProductsEvent, CartProductsState> {
  CartProductsModel? _productData;
  bool _cartDeleted = false;
  bool _cartDecrease = false;
  bool _cartIncrease = false;
  CartProductsBloc() : super(CartProductsInitial()) {
    on<CartProductsRefreshEvent>(_fetchCartProduct);
    on<IncreaseCartEvent>(_increaseCart);
    on<DecreaseCartEvent>(_decreaseCart);
    on<DeleteCartEvent>(_deleteCart);
    on<CartLogoutEvent>(_handleLogout);


  }
    bool get cartDeleted => _cartDeleted;

  Future<void> _fetchCartProduct(CartProductsRefreshEvent event, Emitter<CartProductsState> emit) async {
    /*if(_productData != null){
      final res = await Api.cartProductsApi(event.address_id);
      _productData = res;
      emit(CartProductsSuccess(_productData!));
    }else{*/
      emit(CartProductsLoading());
      SharedPreferences pref = await SharedPreferences.getInstance();
      Constant.token = pref.getString('token').toString();
      try{
        final response = await Api.cartProductsApi(event.address_id);
        _productData = response;
        if(response != null){
          emit(CartProductsSuccess(response));
        }
      }on SocketException{
        emit(CartProductsError('Please check your internet connection'));
      }catch(e, stacktrace){
        emit(CartProductsError(e.toString()));
        print('Caught error: $e');
        print('Stacktrace: $stacktrace');
      }
    // }
  }

  _increaseCart(IncreaseCartEvent event, Emitter<CartProductsState> emit) async {
    _cartIncrease = true;

    final index = _productData!.viewCart!.indexWhere((e) =>
    e.id == event.item.id);

    int availableQuantity = (int.parse(_productData!.viewCart![index].availableQuantity.toString()) + 1);
    if(availableQuantity == 0){
      Fluttertoast.showToast(msg: 'Out of Stock', backgroundColor: Constant.bgOrangeLite, textColor: Constant.bgWhite);
    }else{
      if(index != -1){
        final updatedData = _productData!.viewCart![index].copyWith(
          loadinglike: _productData!.viewCart![index].loadinglike == true ? false : true,
        );
        try{
          final allUpdateData = _productData?.viewCart;
          allUpdateData![index] = updatedData;

          final updateCartModel = _productData?.copyWith(
              viewCart: allUpdateData,
              loading: _productData!.loading = true
          );

          _productData = updateCartModel;
          emit(CartProductsSuccess(_productData!, cartIncrease: _cartIncrease));
        }catch(e){
          print(e.toString());
        }
        await Api.increaseCartApi(event.item.id.toString()).then((value) async {
          if(value!.status == 'success'){
            _cartIncrease = false;
          }
          double salePrice = _productData?.viewCart![index].salePrice != null
              ? double.parse(_productData!.viewCart![index].salePrice.toString())
              : double.parse(_productData!.viewCart![index].regularPrice.toString());
          var regular = double.parse(_productData!.viewCart![index].regularPrice.toString());
          var discountProduct = double.parse(_productData!.viewCart![index].discount.toString());

          final updatedData = _productData!.viewCart![index].copyWith(
              quantity: (_productData!.viewCart![index].quantity!)+1,
              totalPrice: (double.parse(_productData!.viewCart![index].totalPrice.toString()) + salePrice).toString(),
              loadinglike: _productData!.viewCart![index].loadinglike = false,
              availableQuantity: (int.parse(_productData!.viewCart![index].availableQuantity.toString()) - 1).toString()
          );
          try{
            final allUpdateData = _productData?.viewCart;
            allUpdateData![index] = updatedData;

            final updateCartModel = _productData?.copyWith(
                viewCart: allUpdateData,
                totalPrice: (double.parse(_productData!.totalPrice!) + salePrice).toString(),
                discount: (double.parse(_productData!.discount!) + discountProduct!).toString(),
                subTotalPrice: ((_productData!.subTotalPrice! ?? 0).toDouble() + regular).toInt(),
                loading: _productData!.loading = false
            );

            _productData = updateCartModel;
            emit(CartProductsSuccess(_productData!, cartIncrease: _cartIncrease));
          }catch(e){
            print(e.toString());
          }
        });
      }
    }

  }

  _decreaseCart(DecreaseCartEvent event, Emitter<CartProductsState> emit) async {
    _cartDecrease = true;
    final index = _productData!.viewCart!.indexWhere((e) => e.id == event.item.id);
    if(index != -1){
      final updatedData = _productData!.viewCart![index].copyWith(
        loadinglike: _productData!.viewCart![index].loadinglike == true ? false : true,
      );
      try{
        final allUpdateData = _productData?.viewCart;
        allUpdateData![index] = updatedData;

        final updateCartModel = _productData?.copyWith(
            viewCart: allUpdateData,
            loading: _productData!.loading = true
        );

        _productData = updateCartModel;
        emit(CartProductsSuccess(_productData!, cartDecrease: _cartDecrease));
      }catch(e){
        print(e.toString());
      }
      await Api.decreaseCartApi(event.item.id.toString()).then((value) async {
        if(value!.status == 'success'){
          _cartDecrease = false;
        }
        double salePrice = _productData?.viewCart![index].salePrice != null
            ? double.parse(_productData!.viewCart![index].salePrice.toString())
            : double.parse(_productData!.viewCart![index].regularPrice.toString());
        var regular = double.parse(_productData!.viewCart![index].regularPrice.toString());
        double discountProduct = double.parse(_productData!.viewCart![index].discount.toString());

        final updatedData = _productData!.viewCart![index].copyWith(
            quantity: _productData!.viewCart![index].quantity!-1,
            totalPrice: (double.parse(_productData!.viewCart![index].totalPrice.toString()) - salePrice).toString(),
            loadinglike: _productData!.viewCart![index].loadinglike = false,
          availableQuantity: (int.parse(_productData!.viewCart![index].availableQuantity.toString()) + 1).toString()
        );
        try{
          final allUpdateData = _productData?.viewCart;
          allUpdateData![index] = updatedData;

          final updateCartModel = _productData?.copyWith(
              viewCart: allUpdateData,
              totalPrice: (double.parse(_productData!.totalPrice!) - salePrice).toString(),
              discount: (double.parse(_productData!.discount!) - discountProduct!).toString(),
              subTotalPrice: ((_productData!.subTotalPrice! ?? 0).toDouble() - regular).toInt(),
              loading: _productData!.loading = false
          );

          _productData = updateCartModel;
          // _updateTotalPrice(); // Update total price after modifying cart data
          emit(CartProductsSuccess(_productData!, cartDecrease: _cartDecrease));
        }catch(e){
          print(e.toString());
        }
      });
    }
  }

  // _deleteCart(DeleteCartEvent event, Emitter<CartProductsState> emit) async {
  //   try {
  //     List<String> cartIds = [];
  //
  //     // Check if the event.item is a list or a single item
  //     if (event.item is List) {
  //       // If it's a list, collect the IDs from the items in the list
  //       cartIds = (event.item as List).map((item) => item.id.toString()).toList();
  //     } else {
  //       // If it's a single item, just add its ID to the list
  //       cartIds.add(event.item.id.toString());
  //     }
  //
  //     // Remove the cart items locally
  //     for (String id in cartIds) {
  //       final index = _productData!.viewCart!.indexWhere((e) => e.id.toString() == id);
  //       if (index != -1) {
  //         _productData?.viewCart?.removeAt(index);
  //       }
  //     }
  //
  //     emit(CartProductsSuccess(_productData!));
  //
  //     // Make the API call to delete the cart item(s)
  //     await Api.deleteCartApi(cartIds.join(',')).then((value) async {
  //       if (value!.status == 'success') {
  //         Fluttertoast.cancel();
  //         Fluttertoast.showToast(
  //             msg: value.message.toString(),
  //             backgroundColor: Constant.bgOrangeLite
  //         );
  //
  //         // Refresh the cart after deletion
  //         final response = await Api.cartProductsApi('');
  //         _productData = response;
  //         emit(CartProductsSuccess(_productData!));
  //       }
  //     }).catchError((error) {
  //       print(error);
  //     });
  //   } catch (e) {
  //     emit(CartProductsError(e.toString()));
  //   }
  // }


  _deleteCart(DeleteCartEvent event, Emitter<CartProductsState> emit) async {
    try {
      _cartDeleted = true;
      List<String> cartIds = [];

      // Check if the event.item is a list or a single integer
      if (event.item is List) {
        // If it's a list, treat it as a list of cart IDs (integers)
        cartIds = (event.item as List).map((id) => id.toString()).toList();
      } else if (event.item.id is int) {
        // If it's a single integer, it's the cart ID
        cartIds.add(event.item.id.toString());
      }

      // Remove the cart items locally by their IDs
      for (String id in cartIds) {
        final index = _productData!.viewCart!.indexWhere((e) => e.id.toString() == id);
        if (index != -1) {
          _productData?.viewCart?.removeAt(index);
        }
      }

      emit(CartProductsSuccess(_productData!, cartDeleted: _cartDeleted));

      // Make the API call to delete the cart item(s)
      await Api.deleteCartApi(cartIds.join(',')).then((value) async {
        if (value!.status == 'success') {
          _cartDeleted = false;
          Fluttertoast.cancel();
          Fluttertoast.showToast(
              msg: value.message.toString(),
              backgroundColor: Constant.bgOrangeLite
          );

          // Refresh the cart after deletion
          final response = await Api.cartProductsApi('');
          _productData = response;
          emit(CartProductsSuccess(_productData!, cartDeleted : _cartDeleted));
        }
      }).catchError((error) {
        print(error);
      });
    } catch (e) {
      emit(CartProductsError(e.toString()));
    }
  }


  // _deleteCart(DeleteCartEvent event, Emitter<CartProductsState> emit) async {
  //   final index = _productData!.viewCart!.indexWhere((e) => e.id == event.item.id);
  //   if(index != null && index != -1){
  //     try {
  //       _productData?.viewCart?.removeAt(index);
  //       // _updateTotalPrice(); // Update total price after modifying cart data
  //       emit(CartProductsSuccess(_productData!));
  //       await Api.deleteCartApi(event.item.id.toString()).then((value) async {
  //         if(value!.status == 'success'){
  //
  //           Fluttertoast.cancel();
  //           Fluttertoast.showToast(msg: value.message.toString(), backgroundColor: Constant.bgOrangeLite);
  //           final response = await Api.cartProductsApi('');
  //           _productData = response;
  //           emit(CartProductsSuccess(_productData!));
  //         }
  //       }); // Example API call to delete item
  //     } catch (e) {
  //       emit(CartProductsError(e.toString()));
  //     }
  //   }
  // }

  void _handleLogout(CartLogoutEvent event, Emitter<CartProductsState> emit) {
    _productData = null; // Reset the product data
    emit(CartProductsInitial()); // Optionally reset to initial state or any other state you prefer
  }

}
