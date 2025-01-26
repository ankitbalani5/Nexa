import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/CartProductsBloc/cart_products_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Screens/BottomScreens/Cart/Checkout.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/AddShippingAddress.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/ShippingAddress.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Model/CartProductsModel.dart';
import '../../../Widget/Btn2.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool edit = false;
  ScrollController listScrollController = ScrollController();
  List selectedList = [];
  List<ViewCart> selectedListData = [];
  double? totalPriceCheckout;

  @override
  void initState() {
    context.read<CartProductsBloc>().add(CartProductsRefreshEvent(''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 5,
        title: const Text('Cart', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),),
        actions: [
          BlocBuilder<CartProductsBloc, CartProductsState>(
            builder: (context, state) {
              if(state is CartProductsSuccess){
                var cartProducts = state.cartProductsModel.viewCart;
                return cartProducts!.isEmpty
                    ? SizedBox()
                    : Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: InkWell(
                      onTap: (){
                        edit = !edit;
                        if(edit == false){
                          selectedList = [];
                          selectedListData = [];
                          cartProducts.forEach((product) {
                            if (product.select == true) {
                              product.select = false;
                            }
                          });
                        }
                        setState(() {

                        });
                      },
                      child: Image.asset('assets/home/edit.png', height: 40, width: 40,)),
                );
              }
              return SizedBox();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        color: Constant.bgOrange,
        onRefresh: () async{
          context.read<CartProductsBloc>().add(CartLogoutEvent());
          context.read<CartProductsBloc>().add(CartProductsRefreshEvent(''));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocBuilder<CartProductsBloc, CartProductsState>(
            builder: (context, state) {
              if(state is CartProductsLoading){
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Constant.bgOrangeLite,
                    size: 40,
                  ),);
              }
              if(state is CartProductsSuccess){
                var cartProducts = state.cartProductsModel.viewCart!;
                return cartProducts!.isEmpty
                    ? Center(child: Image.asset('assets/home/empty_cart.png', width: 250,))
                    : ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: listScrollController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 10,),
                          Text('${cartProducts?.length} items', style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18
                          )),
                          const Text('in cart', style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16,
                              color: Constant.bgGrey
                          )),
                          const SizedBox(height: 10,),
                          ListView.builder(
                            // controller: listScrollController,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartProducts?.length,
                            itemBuilder: (context, index) {
                              return edit == false
                              // without edit
                                  ? GestureDetector(

                                onLongPress: () {
                                  edit = !edit;
                                  if(edit == false){
                                    selectedList = [];
                                    selectedListData = [];
                                    cartProducts.forEach((product) {
                                      if (product.select == true) {
                                        product.select = false;
                                      }
                                    });

                                  }
                                  setState(() {

                                  });
                                },
                                child: Slidable(
                                  key: ValueKey(cartProducts![index].productName),
                                  // startActionPane: ActionPane(
                                  //   motion: const ScrollMotion(),
                                  //   children: [
                                  //     Expanded(
                                  //       child: Container(
                                  //         // padding: const EdgeInsets.all(8.0),
                                  //         margin: const EdgeInsets.all(8.0),
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(12),
                                  //           color: Constant.bgOrangeLite,
                                  //         ),
                                  //         child: Column(
                                  //           mainAxisAlignment: MainAxisAlignment.center,
                                  //           children: [
                                  //             Padding(
                                  //               padding: const EdgeInsets.all(5.0),
                                  //               child: InkWell(
                                  //                 child:
                                  //                 /*icon: const */const Icon(Icons.add, color: Colors.white),
                                  //                 onTap: () => _addItem(index),
                                  //               ),
                                  //             ),
                                  //             Text(
                                  //               '${cartProducts[index].quantity}',
                                  //               style: const TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                   fontSize: 18,
                                  //                   color: Colors.white
                                  //               ),
                                  //             ),
                                  //             Padding(
                                  //               padding: const EdgeInsets.all(5.0),
                                  //               child: InkWell(
                                  //                 child:
                                  //                 /*icon: const*/ const Icon(Icons.remove, color: Colors.white),
                                  //                 onTap: () => _subtractItem(index),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     // SlidableAction(
                                  //     //   borderRadius: BorderRadius.circular(12),
                                  //     //   padding: EdgeInsets.only(right: 10),
                                  //     //   onPressed: (context) => _addItem(),
                                  //     //   backgroundColor: Constant.bgOrange,
                                  //     //   foregroundColor: Colors.white,
                                  //     //   // icon: ,
                                  //     //   label: 'Delete',
                                  //     // ),
                                  //   ],
                                  // ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: (){
                                            selectedList = [];
                                            // selectedList.add(cartProducts[index].id);
                                            context.read<CartProductsBloc>().add(DeleteCartEvent([cartProducts[index].id]/*selectedList*/));
                                          },
                                          child: Container(
                                            // padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colors.red,
                                            ),
                                            child: Container(
                                              height: double.infinity,
                                              child: Icon(Icons.delete_forever_outlined, color: Colors.white,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // ActionPane(
                                  //   motion: const ScrollMotion(),
                                  //   children: [
                                  //     Expanded(
                                  //       child: Container(
                                  //         margin: const EdgeInsets.all(8.0),
                                  //         child: SlidableAction(
                                  //           borderRadius: BorderRadius.circular(12),
                                  //           padding: const EdgeInsets.only(right: 10),
                                  //           onPressed: (context) => {}/*_deleteItem(index)*/,
                                  //           backgroundColor: Colors.red,
                                  //           foregroundColor: Colors.white,
                                  //           icon: Icons.delete_forever_outlined,
                                  //           // label: 'Add',
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    height: 96,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Constant.bgLiteGrey
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                                height: 80,
                                                width: 80,
                                                imageUrl: cartProducts[index].featureImg!.toString()),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context).size.width*.58,
                                                  child: Text(cartProducts[index].productName.toString(), maxLines: 2, style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 14
                                                  ),)),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width*.58,

                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        cartProducts[index].loadinglike == true
                                                            ? Shimmer.fromColors(
                                                          baseColor: Colors.grey[300]!,
                                                          highlightColor: Colors.grey[100]!,
                                                          child: Container(
                                                            width: 70,
                                                            height: 20,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                            : Text('\$${cartProducts[index].totalPrice.toString()}', style: const TextStyle(
                                                            fontWeight: FontWeight.w700, fontSize: 18
                                                        ),),
                                                        // SizedBox(width: 5,),
                                                        // Text('\$1200', style: TextStyle(
                                                        //     decoration: TextDecoration.lineThrough,
                                                        //     decorationColor: Constant.bgGrey,
                                                        //     fontWeight: FontWeight.w700, fontSize: 16,
                                                        //     color: Constant.bgGrey),)
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 25,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: Constant.bgOrangeLite
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          InkWell(
                                                              onTap: cartProducts[index].loadinglike == true
                                                                  ? (){}
                                                                  : (){
                                                                selectedList = [];
                                                                selectedList.add(cartProducts[index].id);
                                                                cartProducts[index].quantity! <= 1 || int.parse(cartProducts[index].minOrder.toString()) == cartProducts[index].quantity
                                                                    ? context.read<CartProductsBloc>().add(DeleteCartEvent(selectedList))
                                                                    : context.read<CartProductsBloc>().add(DecreaseCartEvent(state.cartProductsModel.viewCart![index]));
                                                              },
                                                              child: const Icon(Icons.remove, color: Colors.white, size: 18,)),
                                                          cartProducts[index].loadinglike == true
                                                              ? Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: SizedBox(
                                                                width: 10,
                                                                child: CircularProgressIndicator(color: Constant.bgWhite, strokeWidth: 1,)),
                                                          )
                                                              : Text(cartProducts[index].quantity.toString(), style: const TextStyle(color: Colors.white,
                                                              fontWeight: FontWeight.w600, fontSize: 16),),
                                                          InkWell(
                                                              onTap: cartProducts[index].loadinglike == true
                                                                  ? (){}
                                                                  : (){
                                                                context.read<CartProductsBloc>().add(IncreaseCartEvent(state.cartProductsModel.viewCart![index]));
                                                              },
                                                              child: const Icon(Icons.add, color: Colors.white, size: 18,)),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              // when edit
                                  : GestureDetector(
                                onLongPress: () {
                                  edit = !edit;
                                  if(edit == false){
                                    selectedList = [];
                                    selectedListData = [];
                                    cartProducts.forEach((product) {
                                      if (product.select == true) {
                                        product.select = false;
                                      }
                                    });
                                  }
                                  setState(() {

                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        activeColor: Constant.bgOrangeLite,
                                        side: const BorderSide(color: Constant.bgOrangeLite),
                                        value: cartProducts[index].select,
                                        onChanged: (value) {
                                          cartProducts[index].select = cartProducts[index].select == true ? false : true;

                                          if (cartProducts[index].select == true) {
                                            // selectedList for delete
                                            selectedList.add(cartProducts[index].id);
                                            // selectedListData for pass data to checkout
                                            selectedListData.add(cartProducts[index]);
                                          }
                                          else {
                                            selectedList.remove(cartProducts[index].id);
                                            selectedListData.removeWhere((item) => item.id == cartProducts[index].id);

                                          }

                                          // Calculate total price
                                          totalPriceCheckout = selectedListData.fold(0, (sum, item) {
                                            double price = double.parse(item.totalPrice.toString());
                                            return sum! + price;
                                          });


                                          print('totalPriceCheckout : ${totalPriceCheckout}');
                                          print('selectedList : ${selectedList}');
                                          print('selectedListData : ${selectedListData}');
                                          setState(() {

                                          });
                                        },),
                                    ),
                                    const SizedBox(width: 15,),
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      height: 96,
                                      width: MediaQuery.of(context).size.width-80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Constant.bgLiteGrey
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: CachedNetworkImage(
                                                  height: 80,
                                                  width: 80,
                                                  imageUrl: cartProducts[index].featureImg!.toString()),
                                            ),
                                          ),
                                          const SizedBox(width: 2,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: MediaQuery.of(context).size.width*.50,
                                                    child: Text(cartProducts[index].productName.toString(), maxLines: 2, style: const TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 14
                                                    ),)),
                                                SizedBox(
                                                  width: MediaQuery.of(context).size.width*.50,

                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          cartProducts[index].loadinglike == true
                                                              ? Shimmer.fromColors(
                                                            baseColor: Colors.grey[300]!,
                                                            highlightColor: Colors.grey[100]!,
                                                            child: Container(
                                                              width: 70,
                                                              height: 20,
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                              : Text('\$${cartProducts[index].totalPrice.toString()}', style: const TextStyle(
                                                              fontWeight: FontWeight.w700, fontSize: 18
                                                          ),),
                                                          // const SizedBox(width: 5,),
                                                          // Text('\$1200', style: TextStyle(fontWeight: FontWeight.w700,
                                                          //     fontSize: 16, color: Constant.bgGrey,
                                                          //     decoration: TextDecoration.lineThrough, decorationColor: Constant.bgGrey)),
                                                        ],
                                                      ),
                                                      Container(
                                                        height: 25,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            color: Constant.bgOrangeLite
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children: [
                                                            InkWell(
                                                                onTap: cartProducts[index].loadinglike == true
                                                                    ? (){}
                                                                    : (){
                                                                  selectedList.add(cartProducts[index].id);
                                                                  cartProducts[index].quantity! <= 1 || int.parse(cartProducts[index].minOrder.toString()) == cartProducts[index].quantity
                                                                      ? context.read<CartProductsBloc>().add(DeleteCartEvent(selectedList))
                                                                      : context.read<CartProductsBloc>().add(DecreaseCartEvent(state.cartProductsModel.viewCart![index]));
                                                                },
                                                                child: const Icon(Icons.remove, color: Colors.white, size: 18,)),
                                                            cartProducts[index].loadinglike == true
                                                                ? Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: SizedBox(
                                                                  width: 10,
                                                                  child: CircularProgressIndicator(color: Constant.bgWhite, strokeWidth: 1,)),
                                                            )
                                                                : Text(cartProducts[index].quantity.toString(), style: const TextStyle(color: Colors.white,
                                                                fontWeight: FontWeight.w600, fontSize: 16),),
                                                            InkWell(
                                                                onTap: cartProducts[index].loadinglike == true
                                                                    ? (){}
                                                                    : (){
                                                                  context.read<CartProductsBloc>().add(IncreaseCartEvent(state.cartProductsModel.viewCart![index]));
                                                                },
                                                                child: const Icon(Icons.add, color: Colors.white, size: 18,)),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount:', style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16
                              )),
                              state.cartProductsModel.loading == true
                                  ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              )
                                  : Text('\$${state.cartProductsModel.subTotalPrice}', style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16
                              )),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Save:', style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16
                              )),
                              state.cartProductsModel.loading == true
                                  ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              )
                                  : Text('\$${state.cartProductsModel.discount}', style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16
                              )),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('You Pay:', style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18
                              )),
                              state.cartProductsModel.loading == true
                                  ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 100,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              )
                                  : Text('\$${state.cartProductsModel.totalPrice}', style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18, color: Constant.bgOrangeLite
                              )),
                            ],
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),]
                );
              }
              if(state is CartProductsError){
                // return Center(
                //   child: Padding(
                //     padding: const EdgeInsets.all(16.0),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.error_outline,
                //           color: Colors.red,
                //           size: 60,
                //         ),
                //         SizedBox(height: 20),
                //         Text(
                //           'Oops! Something went wrong.',
                //           style: TextStyle(
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //         SizedBox(height: 10),
                //         Text(
                //           state.error,
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.grey[700],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // );
                return Center(
                  child: Text(state.error),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      // floatingActionButton: BlocBuilder<CartProductsBloc, CartProductsState>(
      //   builder: (context, state) {
      //     if(state is CartProductsSuccess){
      //       var cartProducts = state.cartProductsModel.viewCart;
      //       return cartProducts!.isEmpty
      //           ? const  SizedBox()
      //           : FloatingActionButton(
      //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      //         backgroundColor: Constant.bgOrangeLite,
      //         onPressed: () {
      //           if (listScrollController.hasClients) {
      //             final position = listScrollController.position.minScrollExtent;
      //             listScrollController.animateTo(
      //               position,
      //               duration: const Duration(seconds: 1),
      //               curve: Curves.easeOut,
      //             );
      //           }
      //         },
      //         isExtended: true,
      //         tooltip: "Scroll to Top",
      //         child: const Icon(Icons.keyboard_arrow_up, color: Colors.white,),
      //       );
      //     }
      //     return const SizedBox();
      //   },
      // ),
      bottomNavigationBar:  BlocBuilder<CartProductsBloc, CartProductsState>(
        builder: (context, state) {
          if(state is CartProductsSuccess){
            var cartProducts = state.cartProductsModel.viewCart;
            return edit == true ? cartProducts!.isEmpty
                ? SizedBox()
                : selectedListData.isEmpty ? SizedBox()
                : BottomAppBar(
              color: Colors.transparent,
              height: edit == true ? 135 : 124,
              surfaceTintColor: Colors.white,
              child: Column(
                children: [
                  Btn2(height: 50, width: MediaQuery.of(context).size.width, name: 'Delete', callBack: selectedListData.isEmpty
                      ? (){}
                      : () {
                    edit = false;
                    // selectedListData = [];
                    context.read<CartProductsBloc>().add(DeleteCartEvent(selectedList));
                    selectedList = [];
                    selectedListData = [];
                  },),
                  const SizedBox(height: 10,),
                  Btn('', height: 50, width: MediaQuery.of(context).size.width,
                      linearColor1: selectedListData.isEmpty ? Constant.bgBtnGrey : Constant.bgLinearColor1,
                      linearColor2: selectedListData.isEmpty ? Constant.bgBtnGrey : Constant.bgLinearColor2,
                      name: state.cartDeleted == true || state.cartIncrease || state.cartDecrease ? '' : 'Proceed', callBack: selectedListData.isEmpty
                          ? (){}
                          : (){
                        if(state.cartDeleted == false && state.cartIncrease == false && state.cartDecrease == false){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(state.cartProductsModel.deliveryAddress, cartProducts: selectedListData, totalPrice: totalPriceCheckout)));
                        }

                        // showOrderDialog();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AddShippingAddress()));
                      },
                    child: state.cartDeleted == true || state.cartIncrease || state.cartDecrease ? Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 40,
                      ),) :  null,
                      ),

                ],
              )

            )
                : cartProducts!.isEmpty
                ? SizedBox()
                : BottomAppBar(
                color: Colors.transparent,
                height: edit == true ? 135 : 124,
                surfaceTintColor: Colors.white,
                child: Column(
                children: [
                  Btn('', height: 50, width: MediaQuery.of(context).size.width,
                      linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                      name: state.cartDeleted == true || state.cartIncrease || state.cartDecrease ? '' : 'Proceed', callBack: (){
                        // showOrderDialog();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AddShippingAddress()));
                      if(state.cartDeleted == false && state.cartIncrease == false && state.cartDecrease == false){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(state.cartProductsModel.deliveryAddress, cartProducts: cartProducts, totalPrice: double.parse(state.cartProductsModel.totalPrice.toString()))));
                      }

                      },
                    child: state.cartDeleted == true || state.cartIncrease || state.cartDecrease ? Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 40,
                      ),) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 5), // Add padding to push the button inside a bit
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.white,
                          onPressed: () {
                            if (listScrollController.hasClients) {
                              final position = listScrollController.position.minScrollExtent;
                              listScrollController.animateTo(
                                position,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                          isExtended: true,
                          tooltip: "Scroll to Top",
                          child: const Icon(Icons.keyboard_arrow_up, color: Constant.bgOrangeLite,),
                        ),
                      )
                      ,
                    ),
                  )
                ],
              ),
            );
          }
          return SizedBox();

        },
      ),
    );
  }

  showOrderDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Image.asset('assets/profile/ordersuccess.png', height: 150, width: 150,),
                const SizedBox(height: 40,),
                const Text('Order Confirm', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),),
                const SizedBox(height: 10,),
                const Text('Your order has been placed successfully. ',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Btn('', height: 50, width: MediaQuery.of(context).size.width,
                      linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                      name: 'Continue', callBack: (){}),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
