import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Model/CategoryWiseProductModel.dart';
import 'dart:async';

part 'category_wise_product_event.dart';
part 'category_wise_product_state.dart';

class CategoryWiseProductBloc extends Bloc<CategoryWiseProductEvent, CategoryWiseProductState> {
  CategoryWiseProductModel? _productData;
  var proData;
  // var search = false;
  CategoryWiseProductBloc() : super(CategoryWiseProductInitial()) {
    on<CategoryWiseProductLoadEvent>(_fetchCategory);
    on<CategoryWishlistEvent>(_addWishlist);
    on<ClearModelEvent>(_clearModelEvent);
    on<TabChangeEvent>(_tabChangeEvent);
  }

//   Future<void> _fetchCategory(CategoryWiseProductLoadEvent event, Emitter<CategoryWiseProductState> emit) async {
//     try {
//       // Show loading only for the first page load
//       if (event.page == 1 && _productData == null) {
//         emit(CategoryWiseProductLoading());
//         final response = await Api.categoryWiseProductApi(event.category_id, event.page, event.search_keyword);
//         _productData = response;
//         emit(CategoryWiseProductSuccess(response!));
//       }else{
//         final response = await Api.categoryWiseProductApi(event.category_id, event.page, event.search_keyword);
//
//         if (response != null && event.search_keyword.isEmpty) {
//           // Get the current state data if available
//           List<Categories> currentCategories = [];
//
//           if (state is CategoryWiseProductSuccess) {
//             currentCategories = (state as CategoryWiseProductSuccess).categoryWiseProductModel.categories!;
//           }
//
//           // Find the index of the category being paginated
//           var categoryIndex = currentCategories.indexWhere((e) => e.id == int.parse(event.category_id));
//
//           // Check if category exists before proceeding
//           if (categoryIndex == -1) {
//             // Handle the case where the category is not found
//             print('Category not found');
//             return;
//           }
//
//           var updatedProducts;
//           // If the category already exists in the current state, append the new products
//           if (categoryIndex != -1) {
// // when
//             if(search == true){
//               var newData = response.categories![categoryIndex].products;
//               // updatedProducts = [...newData];
//               // Update the paginated category's product list
//               currentCategories[categoryIndex] = currentCategories[categoryIndex].copyWith(
//                   products: newData
//               );
//
//               var newResponse = response.copyWith(categories: currentCategories);
//               _productData = newResponse;
//
//               // Emit the updated state with the updated category data
//               emit(CategoryWiseProductSuccess(
//                 response.copyWith(categories: currentCategories),
//               ));
//               // Constant.loading == true ? Navigator.pop(event.context) : (){Constant.loading = false;};
//
//               search = false;
//             }
//
//
//             else{
//               // Get the new data for the current category from the API response
//               var newData = response.categories![categoryIndex].products?.data ?? [];
//               var oldProducts = currentCategories[categoryIndex].products?.data ?? [];
//               updatedProducts = [...oldProducts, ...newData];
//               // Update the paginated category's product list
//               currentCategories[categoryIndex] = currentCategories[categoryIndex].copyWith(
//                 products: currentCategories[categoryIndex].products?.copyWith(
//                     data: updatedProducts,
//                     currentPage: currentCategories[categoryIndex].products!.currentPage!+1
//                 ),
//               );
//
//               var newResponse = response.copyWith(categories: currentCategories);
//               _productData = newResponse;
//
//               // Emit the updated state with the updated category data
//               emit(CategoryWiseProductSuccess(
//                 response.copyWith(categories: currentCategories),
//               ));
//             }
//
//
//           }
//
//         }
//
//
//         else if(response != null && event.search_keyword.isNotEmpty){
//
//           search = true;
//           // Get the current state data if available
//           List<Categories> currentCategories = [];
//
//           if (state is CategoryWiseProductSuccess) {
//             currentCategories = (state as CategoryWiseProductSuccess).categoryWiseProductModel.categories!;
//           }
//
//           // Find the index of the category being paginated
//           var categoryIndex = currentCategories.indexWhere((e) => e.id == int.parse(event.category_id));
//
//           // Check if category exists before proceeding
//           if (categoryIndex == -1) {
//             // Handle the case where the category is not found
//             print('Category not found');
//             return;
//           }
//
//           // Get the new data for the current category from the API response
//           var newData = response.categories![categoryIndex].products;
//
//           // If the category already exists in the current state, append the new products
//           if (categoryIndex != -1) {
//
//             // Update the paginated category's product list
//             currentCategories[categoryIndex] = currentCategories[categoryIndex].copyWith(
//                 products: newData
//             );
//           }
//           var newResponse = response.copyWith(categories: currentCategories);
//           _productData = newResponse;
//
//           // Emit the updated state with the updated category data
//           emit(CategoryWiseProductSuccess(
//             response.copyWith(categories: currentCategories),
//           ));
//           // Constant.loading == true
//           //     ? Navigator.pop(event.context) : (){Constant.loading = false;};
//         }
//       }
//
//
//     } on SocketException {
//       emit(CategoryWiseProductError('Please check your internet connection'));
//     } catch (e) {
//       emit(CategoryWiseProductError(e.toString()));
//     }
//   }

  Future<void> _fetchCategory(CategoryWiseProductLoadEvent event, Emitter<CategoryWiseProductState> emit) async {
    try {
      // Show loading only for the first page load
      if (event.page == 1 && _productData == null) {
        emit(CategoryWiseProductLoading());
        final response = await Api.categoryWiseProductApi(event.category_id, event.page, event.search_keyword);
        _productData = response;

        emit(CategoryWiseProductSuccess(response!));
      }else{
        final response = await Api.categoryWiseProductApi(event.category_id, event.page, event.search_keyword);

        if (response != null && event.search_keyword.isEmpty) {
          // Get the current state data if available
          List<Categories> currentCategories = [];

          if (state is CategoryWiseProductSuccess) {
            currentCategories = (state as CategoryWiseProductSuccess).categoryWiseProductModel.categories!;
          }

          // Find the index of the category being paginated
          var categoryIndex = currentCategories.indexWhere((e) => e.id == int.parse(event.category_id));

          // Check if category exists before proceeding
          if (categoryIndex == -1) {
            // Handle the case where the category is not found
            print('Category not found');
            return;
          }

          var updatedProducts;
          // If the category already exists in the current state, append the new products
          if (categoryIndex != -1) {
// when
            if(Constant.search == true){
              var newData = response.categories![categoryIndex].products;
              // updatedProducts = [...newData];
              // Update the paginated category's product list
              currentCategories[categoryIndex] = currentCategories[categoryIndex].copyWith(
                  products: newData
              );

              var newResponse = response.copyWith(categories: currentCategories);
              // _productData = newResponse;

              // Emit the updated state with the updated category data
              emit(CategoryWiseProductSuccess(
                response.copyWith(categories: currentCategories),
              ));
              // Constant.loading == true ? Navigator.pop(event.context) : (){Constant.loading = false;};

              Constant.search = false;
            }


            else{
              // Get the new data for the current category from the API response
              var newData = response.categories![categoryIndex].products?.data ?? [];
              var oldProducts = currentCategories[categoryIndex].products?.data ?? [];
              updatedProducts = [...oldProducts, ...newData];
              // Update the paginated category's product list
              currentCategories[categoryIndex] = response.categories![categoryIndex].copyWith(
                products: response.categories![categoryIndex].products?.copyWith(
                    data: updatedProducts,
                    currentPage: response.categories![categoryIndex].products!.currentPage!,
                    lastPage: response.categories![categoryIndex].products!.lastPage!,
                ),
              );

              var newResponse = response.copyWith(categories: currentCategories);
              // _productData = newResponse;

              // Emit the updated state with the updated category data
              emit(CategoryWiseProductSuccess(
                response.copyWith(categories: currentCategories),
              ));
            }


          }

        }


        else if(response != null && event.search_keyword.isNotEmpty){

          Constant.search = true;
          // Get the current state data if available
          List<Categories> currentCategories = [];

          if (state is CategoryWiseProductSuccess) {
            currentCategories = (state as CategoryWiseProductSuccess).categoryWiseProductModel.categories!;
          }

          // Find the index of the category being paginated
          var categoryIndex = currentCategories.indexWhere((e) => e.id == int.parse(event.category_id));

          // Check if category exists before proceeding
          if (categoryIndex == -1) {
            // Handle the case where the category is not found
            print('Category not found');
            return;
          }
          if(event.pagination == false){
            // Get the new data for the current category from the API response
            var newData = response.categories![categoryIndex].products;

            // If the category already exists in the current state, append the new products
            if (categoryIndex != -1) {
              // Update the paginated category's product list
              currentCategories[categoryIndex] =
                  currentCategories[categoryIndex].copyWith(
                products: newData,
              );
            }
            var newResponse = response.copyWith(categories: currentCategories);
            // _productData = newResponse;

            // Emit the updated state with the updated category data
            emit(CategoryWiseProductSuccess(
              response.copyWith(categories: currentCategories),
            ));
          }

          else{
            // Get the new data for the current category from the API response
            var newData = response.categories![categoryIndex].products!.data!;
            var oldData = currentCategories[categoryIndex].products!.data!;
            final updatedProducts = [...oldData, ...newData];
            // If the category already exists in the current state, append the new products
            if (categoryIndex != -1) {
              // Update the paginated category's product list
              currentCategories[categoryIndex] = response.categories![categoryIndex].copyWith(
                products: response.categories![categoryIndex].products?.copyWith(
                  data: updatedProducts,
                  currentPage: response.categories![categoryIndex].products!.currentPage!,
                  lastPage: response.categories![categoryIndex].products!.lastPage!,
                ),
              );
            }
            var newResponse = response.copyWith(categories: currentCategories);
            // _productData = newResponse;

            // Emit the updated state with the updated category data
            emit(CategoryWiseProductSuccess(
              response.copyWith(categories: currentCategories),
            ));
          }
        }
      }


    } on SocketException {
      emit(CategoryWiseProductError('Please check your internet connection'));
    } catch (e) {
      emit(CategoryWiseProductError(e.toString()));
    }
  }

  // Future<void> _fetchCategory(CategoryWiseProductLoadEvent event, Emitter<CategoryWiseProductState> emit) async {
  //   try {
  //     // Show loading only for the first page load
  //     if (event.page == 1 && _productData == null) {
  //       emit(CategoryWiseProductLoading());
  //       final response = await Api.categoryWiseProductApi(event.category_id, event.page, event.search_keyword);
  //       _productData = response;
  //       emit(CategoryWiseProductSuccess(response!));
  //     }else{
  //       final response = await Api.categoryWiseProductApi(event.category_id, event.page, event.search_keyword);
  //
  //       if (response != null && event.search_keyword.isEmpty) {
  //         // Get the current state data if available
  //         List<Categories> currentCategories = [];
  //
  //         if (state is CategoryWiseProductSuccess) {
  //           currentCategories = (state as CategoryWiseProductSuccess).categoryWiseProductModel.categories!;
  //         }
  //
  //         // Find the index of the category being paginated
  //         var categoryIndex = currentCategories.indexWhere((e) => e.id == int.parse(event.category_id));
  //
  //         // Check if category exists before proceeding
  //         if (categoryIndex == -1) {
  //           // Handle the case where the category is not found
  //           print('Category not found');
  //           return;
  //         }
  //
  //         var updatedProducts;
  //         // If the category already exists in the current state, append the new products
  //         if (categoryIndex != -1) {
  //           if(search == true){
  //             var newData = response.categories![categoryIndex].products;
  //             // updatedProducts = [...newData];
  //             // Update the paginated category's product list
  //             currentCategories[categoryIndex] = currentCategories[categoryIndex].copyWith(
  //               products: newData
  //             );
  //
  //             var newResponse = response.copyWith(categories: currentCategories);
  //             _productData = newResponse;
  //
  //             // Emit the updated state with the updated category data
  //             emit(CategoryWiseProductSuccess(
  //               response.copyWith(categories: currentCategories),
  //             ));
  //             // Constant.loading == true ? Navigator.pop(event.context) : (){Constant.loading = false;};
  //
  //             search = false;
  //           }else{
  //             // Get the new data for the current category from the API response
  //             var newData = response.categories![categoryIndex].products?.data ?? [];
  //             var oldProducts = currentCategories[categoryIndex].products?.data ?? [];
  //             updatedProducts = [...oldProducts, ...newData];
  //             // Update the paginated category's product list
  //             currentCategories[categoryIndex] = currentCategories[categoryIndex].copyWith(
  //               products: currentCategories[categoryIndex].products?.copyWith(
  //                   data: updatedProducts,
  //                   currentPage: currentCategories[categoryIndex].products!.currentPage!+1
  //               ),
  //             );
  //
  //             var newResponse = response.copyWith(categories: currentCategories);
  //             _productData = newResponse;
  //
  //             // Emit the updated state with the updated category data
  //             emit(CategoryWiseProductSuccess(
  //               response.copyWith(categories: currentCategories),
  //             ));
  //           }
  //
  //
  //         }
  //
  //       }
  //       else if(response != null && event.search_keyword.isNotEmpty){
  //
  //         search = true;
  //         // Get the current state data if available
  //         List<Categories> currentCategories = [];
  //
  //         if (state is CategoryWiseProductSuccess) {
  //           currentCategories = (state as CategoryWiseProductSuccess).categoryWiseProductModel.categories!;
  //         }
  //
  //         // Find the index of the category being paginated
  //         var categoryIndex = currentCategories.indexWhere((e) => e.id == int.parse(event.category_id));
  //
  //         // Check if category exists before proceeding
  //         if (categoryIndex == -1) {
  //           // Handle the case where the category is not found
  //           print('Category not found');
  //           return;
  //         }
  //
  //         // Get the new data for the current category from the API response
  //         var newData = response.categories![categoryIndex].products;
  //
  //         // If the category already exists in the current state, append the new products
  //         if (categoryIndex != -1) {
  //
  //           // Update the paginated category's product list
  //           currentCategories[categoryIndex] = currentCategories[categoryIndex].copyWith(
  //             products: newData
  //           );
  //         }
  //         var newResponse = response.copyWith(categories: currentCategories);
  //         _productData = newResponse;
  //
  //         // Emit the updated state with the updated category data
  //         emit(CategoryWiseProductSuccess(
  //           response.copyWith(categories: currentCategories),
  //         ));
  //         // Constant.loading == true
  //         //     ? Navigator.pop(event.context) : (){Constant.loading = false;};
  //       }
  //     }
  //
  //
  //   } on SocketException {
  //     emit(CategoryWiseProductError('Please check your internet connection'));
  //   } catch (e) {
  //     emit(CategoryWiseProductError(e.toString()));
  //   }
  // }

  Future<void> _tabChangeEvent(TabChangeEvent event, Emitter<CategoryWiseProductState> emit) async {
    final response = await Api.categoryWiseProductApi('', 1, '');
    emit(CategoryWiseProductSuccess(response!));
  }



  Future<void> _addWishlist(CategoryWishlistEvent event, Emitter<CategoryWiseProductState> emit) async {
    // Find the category that contains the product you want to update
    final categoryIndex = _productData?.categories?.indexWhere(
          (category) => category.products?.data?.any((product) => product.id == event.item.id) ?? false,
    );

    if (categoryIndex != -1 && categoryIndex != null) {
      // Find the product index within that category
      final productIndex = _productData?.categories![categoryIndex!].products?.data
          ?.indexWhere((product) => product.id == event.item.id);

      if (productIndex != -1 && productIndex != null) {
        // Toggle the wishlist status of the selected product
        final updatedProduct = _productData?.categories![categoryIndex].products?.data![productIndex!].copyWith(
          inWishlist: !_productData!.categories![categoryIndex].products!.data![productIndex].inWishlist!,
        );

        // Update the product list with the updated product
        final updatedProductsList = [..._productData!.categories![categoryIndex].products!.data!];
        updatedProductsList[productIndex] = updatedProduct!;

        // Update the category's products with the new product list
        final updatedCategory = _productData!.categories![categoryIndex].copyWith(
          products: _productData!.categories![categoryIndex].products!.copyWith(
            data: updatedProductsList,
          ),
        );

        // Update the entire categories list
        final updatedCategories = [..._productData!.categories!];
        updatedCategories[categoryIndex] = updatedCategory;

        // Update _productData with the new categories list
        _productData = _productData?.copyWith(categories: updatedCategories);

        // Emit the new success state with the updated _productData
        emit(CategoryWiseProductSuccess(_productData!));

        // Call the API to actually update the wishlist status on the server
        await Api.addWishlistApi(event.item.id.toString()).then((value) {
          if (value?.status == 'success') {
            Fluttertoast.cancel();
            Fluttertoast.showToast(msg: value!.message.toString(), backgroundColor: Constant.bgOrangeLite);
          } else {
            Fluttertoast.cancel();
            Fluttertoast.showToast(msg: value!.message.toString(),);
          }
        }).catchError((error) {
          print('Error updating wishlist: $error');
            Fluttertoast.cancel();
          Fluttertoast.showToast(msg: 'Error updating wishlist');
        });
      }
    }
  }



  void _clearModelEvent(ClearModelEvent event , Emitter<CategoryWiseProductState> emit){
    _productData = null;
    emit(CategoryWiseProductInitial());
  }
}
// Future<void> _fetchSubCategory(CategoryWiseProductLoadEvent event, Emitter<CategoryWiseProductState> emit) async {
//   // emit(CategoryWiseProductLoading());
//   try{
//     // Emit loading state only on the first load or when explicitly reloading
//     if (event.page == 1 && _productData == null) {
//       emit(CategoryWiseProductLoading());
//     }
//       final response = await Api.categoryWiseProductApi(event.category_id, /*event.sub_category_id,*/ event.page, event.search_keyword);
//     if (response != null) {
//       // Extract the current products from the state if it exists
//       var currentCategories = <Categories>[];
//
//       if (state is CategoryWiseProductSuccess) {
//         currentCategories = (state as CategoryWiseProductSuccess).categoryWiseProductModel.categories!;
//       }
//
//       // Append new categories to the current list
//       final newCategories = [...currentCategories, ...response.categories!];
//
//       // Create a new CategoryWiseProductModel with updated categories
//       final updatedCategoryWiseProductModel = response.copyWith(
//         categories: newCategories,
//       );
//
//       // Emit the updated success state with the new category list
//       emit(CategoryWiseProductSuccess(updatedCategoryWiseProductModel));
//     }
//   }on SocketException{
//     emit(CategoryWiseProductError('Please check your internet connection'));
//   }catch(e){
//     emit(CategoryWiseProductError(e.toString()));
//   }
// }