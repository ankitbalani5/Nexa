import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Bloc/AllShippingAddressBloc/all_shipping_address_bloc.dart';
import 'package:nexa/Bloc/PlaceOrderBloc/place_order_bloc.dart';
import 'package:nexa/Bloc/get_coupon_model_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Model/CartProductsModel.dart';
import 'package:nexa/NavBar.dart';
import 'package:nexa/Screens/BottomScreens/Cart/AddCard.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/AddShippingAddress.dart';
import 'package:nexa/Stripe/Stripe.dart';
import 'package:nexa/Widget/Btn2.dart';
import 'package:nexa/Widget/TextField/TextField.dart';
import 'package:nexa/Widget/TextStyles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Bloc/ApplyCouponBloc/apply_coupon_bloc.dart';
import '../../../Bloc/CartProductsBloc/cart_products_bloc.dart';
import '../../../Widget/Btn.dart';
class Checkout extends StatefulWidget {
  List<ViewCart> cartProducts;
  List<DeliveryAddress>? address;
  double? totalPrice;
  Checkout(this.address, {required this.cartProducts, required this.totalPrice,  super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var messageController = TextEditingController();
  var couponController = TextEditingController();
  String delivery_Opt = 'workDelivery';
  String paymentMethod = 'cod';
  String? selectedAddress;
  String? selectedWarehouse;
  String? selectedAddressId;
  String? selectedWarehouseId = '';
  double totalPrice = 0;
  double totalPriceAfterCoupon = 0;
  double discount = 0;
  List<String> cartIds = [];
  List  selectedList = [];
  String? appliedCoupon = '';
  bool readOnly = false;
  bool couponSheetOpen = false;

  List<Map<String, dynamic>> promoCodes = [
    {
      'name': 'Personal offer',
      'code': 'Mypromocode2024',
      'time': '6 days ago',
      'percentage': '10',
      'image': 'assets/images/promo1.png'
    },
    {
      'name': 'Personal offer',
      'code': 'Mypromocode2024',
      'time': '6 days ago',
      'percentage': '15',
      'image': 'assets/images/promo2.png'
    },
    {
      'name': 'Personal offer',
      'code': 'Mypromocode2024',
      'time': '6 days ago',
      'percentage': '22',
      'image': 'assets/images/promo3.png'
    },
  ];

  @override
  void initState() {
    context.read<GetCouponModelBloc>().add(GetCouponLoadEvent());
    context.read<AllShippingAddressBloc>().add(ClearShippingAddressEvent());
    context.read<AllShippingAddressBloc>().add(FetchShippingAddressEvent());
    print('cartIds: $cartIds');
    firstData();


    super.initState();
  }

  firstData() async{
    final response = await Api.allShippingAddressApi();
    selectedList = widget.cartProducts.map((e) => e.id).toList();
    if (response!.shippingAddress!.isNotEmpty) {
      selectedAddress = response.shippingAddress![0].address;
      selectedAddressId = response.shippingAddress![0].id.toString();
    }

    totalPrice = widget.totalPrice!;
    cartIds = widget.cartProducts.map((e) => e.id.toString()).toList();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 3,)), (route) => false,);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 3,)), (route) => false,);
                },
                child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
          ),
          title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
        ),
        body: BlocBuilder<AllShippingAddressBloc, AllShippingAddressState>(
          builder: (context, state) {
            if(state is AllShippingAddressLoading){
              // return Center(child: CircularProgressIndicator(color: Constant.bgOrangeLite,));
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Constant.bgOrangeLite,
                  size: 40,
                ),);
            }
            if(state is AllShippingAddressSuccess){
              // Find the address with primary_address set to 1
              for (var address in state.allShippingAddressModel.shippingAddress!) {
                if (address.primaryAddress == 1) {
                  selectedAddress = address.address;
                  selectedAddressId = address.id.toString();
                  break; // Exit loop after finding the primary address
                }else{

                }
              }

              // Print the selected address and ID
              print('Selected Address: $selectedAddress');
              print('Selected Address ID: $selectedAddressId');
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.cartProducts.length,
                      itemBuilder: (context, index) {
                        return Container(
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
                                        imageUrl: widget.cartProducts[index].featureImg!.toString()),
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
                                          child: Text(widget.cartProducts[index].productName.toString(), maxLines: 2, style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 14
                                          ),)),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*.58,
      
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                widget.cartProducts[index].loadinglike == true
                                                    ? Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor: Colors.grey[100]!,
                                                  child: Container(
                                                    width: 70,
                                                    height: 20,
                                                    color: Colors.white,
                                                  ),
                                                )
                                                    : Text('\$${widget.cartProducts[index].totalPrice.toString()}', style: const TextStyle(
                                                    fontWeight: FontWeight.w700, fontSize: 18
                                                ),),
                                              ],
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
                    SizedBox(height: 10,),
                    ExpandablePanel(
                      theme: ExpandableThemeData(
                        iconPadding: EdgeInsets.only(top: 7, bottom: 6, left: 5),
                        expandIcon: Icons.arrow_forward_ios_outlined, // Icon when collapsed
                        collapseIcon: Icons.keyboard_arrow_down_sharp, // Icon when expanded
                        iconColor: Colors.black,
                        iconSize: 15.0,
                        // useInkWell: false,
                      ),
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selectedAddress != null ? 'Delivery Address' : 'Choose Address', style: TextStyles.font18w7(Colors.black)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddShippingAddress(path: 'checkout')));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Constant.bgOrangeLite,
                              ),
                              child: Icon(Icons.add, color: Colors.white,),
                            ),
                          )
                        ],
                      ),
      
                      // Collapsed state: Show only the selected address with custom radio button
                      collapsed: selectedAddress != null
                          ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          print(':::::::::::::::::::::::$selectedAddress');
                          final selectedAddressItem = state.allShippingAddressModel.shippingAddress?.firstWhere((address) => address.address == selectedAddress);
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/del_addr.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .65,
                                      child: Text(
                                        '${selectedAddressItem?.address}, ${selectedAddressItem?.city}, ${selectedAddressItem?.state}, ${selectedAddressItem?.zipCode}, ${selectedAddressItem?.country}',
                                        style: TextStyles.font15w4(Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                // Custom radio button with check icon
                                GestureDetector(
                                  onTap: () {
                                    // Handle tap event
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange, // Fill color for selected state
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white, // Check icon color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                          : Text("*Select an address", style: TextStyle(color: Colors.red),),
      
                      // Expanded state: Show all addresses with custom radio buttons
                      expanded: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.allShippingAddressModel.shippingAddress?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final currentAddress = state.allShippingAddressModel.shippingAddress?[index];
                          final isSelected = currentAddress?.address == selectedAddress;
      
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/del_addr.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * .65,
                                      child: Text(
                                        '${currentAddress?.address}, ${currentAddress?.city}, ${currentAddress?.state}, ${currentAddress?.zipCode}, ${currentAddress?.country}',
                                        style: TextStyles.font15w4(Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                // Custom radio button with check icon and orange fill
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAddress = currentAddress?.address;
                                      selectedAddressId = currentAddress?.id.toString();
                                    });
                                  },
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? Colors.orange : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected ? Colors.orange : Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white, // Check icon color
                                    )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
      
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Coupon Code', style: TextStyles.font18w7(Colors.black),),
      
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
      
                    DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        strokeCap: StrokeCap.butt,
                        stackFit: StackFit.passthrough,
                        borderPadding: EdgeInsets.zero,
                        // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        color: Constant.bgOrange,
                        strokeWidth: 1.0,
                        dashPattern: const [6, 3],
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 10), // Inner padding
                          color: Constant.bgOrangeLite.withOpacity(.10),
                          child: Center(
                            child: TextField(
                              readOnly: readOnly,
                              controller: couponController,
                              cursorColor: Constant.bgOrangeLite,
                              onChanged: (value) {
                                print('couponController:::${couponController.text}');
                                setState(() {
      
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: 'Enter coupon code here',
                                  fillColor: Constant.bgOrangeLite,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                                  suffixIcon: readOnly == true
                                      ? GestureDetector(
                                      onTap: () {
                                        readOnly = false;
                                        totalPriceAfterCoupon = widget.totalPrice!;
                                        discount = 0.0;
                                        couponController.clear();
                                        appliedCoupon = '';
                                        setState(() {

                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8),
                                        child: Text('Remove', style: TextStyle(color: Colors.blue),),
                                      ))
                                      : BlocListener<ApplyCouponBloc, ApplyCouponState>(
                                    listener: (context, state) {
                                      if (state is ApplyCouponSuccess) {
                                        FocusScope.of(context).unfocus();
                                        // If the couponCode is not empty, it means the coupon was applied successfully
                                        if (state.applyCouponModel.status != false) {
                                          final message = context.read<ApplyCouponBloc>().message;
                                          final totalAmount1 = context.read<ApplyCouponBloc>().totalAmount;
                                          discount = context.read<ApplyCouponBloc>().discount;
                                          final coupon = context.read<ApplyCouponBloc>().couponCode;

                                          totalPriceAfterCoupon = totalAmount1;
                                          print('totalAmount1 $totalAmount1   $discount  $totalPriceAfterCoupon');

                                          // Update the coupon code input field
                                          // if(state.applyCouponModel.status != false){
                                            print('status :::: ${state.applyCouponModel.status}');
                                            couponController.text = coupon;
                                            appliedCoupon = coupon;
                                          // }
                                          readOnly = true;
                                          setState(() {

                                          });

                                          // Show a success message
                                          if(message.isNotEmpty){
                                            Fluttertoast.showToast(msg: message, backgroundColor: Constant.bgOrangeLite,);
                                          }
                                        }
                                        else {
                                          // Show a fallback message if something went wrong
                                          final message = context.read<ApplyCouponBloc>().message;
                                          discount = context.read<ApplyCouponBloc>().discount;
                                          final totalAmount1 = context.read<ApplyCouponBloc>().totalAmount;
                                          totalPriceAfterCoupon = totalAmount1;
                                          couponController.clear();
                                          setState(() {

                                          });
                                          if(message.isNotEmpty){
                                            Fluttertoast.showToast(msg: message, backgroundColor: Constant.bgOrangeLite,);
                                          }
                                        }
                                        if(couponSheetOpen == true){
                                          Navigator.pop(context);
                                          couponSheetOpen = false;
                                        }
                                      }

                                      if (state is ApplyCouponError) {
                                        FocusScope.of(context).unfocus();
                                        // Handle the error case properly
                                        print(state.error);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(state.error)),
                                        );
                                      }
                                    },
                                    child: TextButton(
                                        onPressed:  () {
                                          FocusScope.of(context).unfocus(); // Dismiss the keyboard

                                          if (couponController.text.isNotEmpty) {
                                            // Apply the coupon logic
                                            context.read<ApplyCouponBloc>().add(
                                              ApplyNewCouponEvent(
                                                context,
                                                cartIds,
                                                couponController.text,
                                                totalPrice.toString(),
                                              ),
                                            );
                                          } else {
                                            couponSheet(); // Open the coupon sheet if no text is entered
                                          }
                                        }, child: Text('Apply', style: TextStyles.font18w7(Constant.bgOrangeLite),)),
                                  ),
                                  border: InputBorder.none
                              ),
                            ),
                          ),
                        )
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Option', style: TextStyles.font18w7(Colors.black),),
                        // Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        delivery_Opt = 'Pickup';
                        setState(() {
      
                        });
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            color: Constant.bgOrangeLite.withOpacity(.10),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(Icons.wheelchair_pickup),
                                  Image.asset('assets/images/pickup.png', height: 35, width: 35),
                                  SizedBox(width: 10,),
                                  Text('Pick up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                ],
                              ),
                              Radio(
                                value: 'Pickup',
                                groupValue: delivery_Opt,
                                activeColor: Constant.bgOrange,
                                onChanged: (value) {
                                  delivery_Opt = value!;
                                  setState(() {
      
                                  });
                                },)
                            ],
                          ),
                        ),
                      ),
                    ),
      
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        delivery_Opt = 'workDelivery';
                        setState(() {
      
                        });
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            color: Constant.bgOrangeLite.withOpacity(.10),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(Icons.delivery_dining),
                                  Image.asset('assets/images/work_delivery.png', height: 35, width: 35),
                                  SizedBox(width: 10,),
                                  Text('Delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                ],
                              ),
                              Radio(
                                value: 'workDelivery',
                                groupValue: delivery_Opt,
                                activeColor: Constant.bgOrange,
                                onChanged: (value) {
                                  delivery_Opt = value!;
                                  setState(() {
      
                                  });
                                },)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: delivery_Opt == 'Pickup',
                      child: Column(
                        children: [
                          ExpandablePanel(
                            theme: ExpandableThemeData(
                              iconPadding: EdgeInsets.only(top: 7, bottom: 6, left: 5),
                              expandIcon: Icons.arrow_forward_ios_outlined, // Icon when collapsed
                              collapseIcon: Icons.keyboard_arrow_down_sharp, // Icon when expanded
                              iconColor: Colors.black,
                              iconSize: 15.0,
                              // useInkWell: false,
                            ),
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('WareHouse Address', style: TextStyles.font18w7(Colors.black)),

                              ],
                            ),

                            // Collapsed state: Show only the selected address with custom radio button
                            collapsed: selectedWarehouse != null
                                ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                print(':::::::::::::::::::::::$selectedWarehouse');
                                final selectedAddressItem = state.wareHouseModel.warehouse?.firstWhere((address) => address.warehouseName == selectedWarehouse);
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/del_addr.png',
                                            height: 50,
                                            width: 50,
                                          ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * .65,
                                            child: Text(
                                              '${selectedAddressItem?.warehouseName}, ${selectedAddressItem?.streetAddress}, ${selectedAddressItem?.city}, ${selectedAddressItem?.zipCode}, ${selectedAddressItem?.state}, ${selectedAddressItem?.country}',
                                              style: TextStyles.font15w4(Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Custom radio button with check icon
                                      GestureDetector(
                                        onTap: () {

                                          // Handle tap event
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.orange, // Fill color for selected state
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 15,
                                            color: Colors.white, // Check icon color
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                                : Text("*Select an address", style: TextStyle(color: Colors.red),),

                            // Expanded state: Show all addresses with custom radio buttons
                            expanded: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.wareHouseModel.warehouse?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final currentAddress = state.wareHouseModel.warehouse?[index];
                                final isSelected = currentAddress?.warehouseName == selectedWarehouse;

                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/del_addr.png',
                                            height: 50,
                                            width: 50,
                                          ),
                                          SizedBox(width: 10),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width * .65,
                                            child: Text(
                                              '${currentAddress?.warehouseName}, ${currentAddress?.streetAddress}, ${currentAddress?.city}, ${currentAddress?.zipCode}, ${currentAddress?.state}, ${currentAddress?.country}',
                                              style: TextStyles.font15w4(Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Custom radio button with check icon and orange fill
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedWarehouse = currentAddress?.warehouseName;
                                            selectedWarehouseId = currentAddress?.id.toString();
                                          });
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected ? Colors.orange : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected ? Colors.orange : Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: isSelected
                                              ? Icon(
                                            Icons.check,
                                            size: 15,
                                            color: Colors.white, // Check icon color
                                          )
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AddCard()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Payment Method', style: TextStyles.font18w7(Colors.black),),
                          Icon(Icons.arrow_forward_ios, size: 15,)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        paymentMethod = 'cod';
                        setState(() {
      
                        });
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            color: Constant.bgOrangeLite.withOpacity(.10),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(Icons.money_off),
                                  Image.asset('assets/images/cash_delivery.png', height: 35, width: 35),
                                  SizedBox(width: 10,),
                                  Text('Cash on Delivery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                                ],
                              ),
                              Radio(
                                value: 'cod',
                                groupValue: paymentMethod,
                                activeColor: Constant.bgOrange,
                                onChanged: (value) {
                                  paymentMethod = value!;
                                  setState(() {
      
                                  });
                                },)
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        paymentMethod = 'online';
                        setState(() {

                        });
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            color: Constant.bgOrangeLite.withOpacity(.10),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Icon(Icons.credit_card),
                                  Image.asset('assets/images/work_delivery.png', height: 35, width: 35,),
                                  SizedBox(width: 10,),
                                  Text('Online', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                                ],
                              ),
                              Radio(
                                value: 'online',
                                groupValue: paymentMethod,
                                activeColor: Constant.bgOrange,
                                onChanged: (value) {
                                  paymentMethod = value!;
                                  setState(() {

                                  });
                                },)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Message For Sellers', style: TextStyles.font18w7(Colors.black),),
                    SizedBox(
                      height: 10,
                    ),
                    TextFields.simpleTextFieldArea(
                        controller: messageController,
                        hint: 'Enter message',
                        color: Constant.bgOrangeLite.withOpacity(.10)),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('sub total:', style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16
                        )),
                        Text('\$${totalPrice.toString()}', style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16
                        )),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('discount:', style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16
                        )),
                        Text('\$${discount != 0 ? discount.toString() : '0.0'}', style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16
                        )),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18
                        )),
                        Text('\$${totalPriceAfterCoupon != 0 ? totalPriceAfterCoupon : totalPrice.toString()}', style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18, color: Constant.bgOrangeLite
                        )),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    BlocListener<PlaceOrderBloc, PlaceOrderState>(
                      listener: (context, state) {
                        if(state is PlaceOrderLoading){
                          Constant.showDialogProgress(context);
                        }
                        if(state is PlaceOrderSuccess){

                          Navigator.pop(context);
                          showOrderDialog();
                        }
                        if(state is PlaceOrderError){
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: 'something went wrong', backgroundColor: Colors.red);
                        }
                      },
                      child: Btn('', height: 50, width: MediaQuery.of(context).size.width,
                          linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                          name: 'Proceed To Order', callBack: (){

                            print('selectedList:: $selectedList');
                            String totalAmount = totalPriceAfterCoupon != 0 ? totalPriceAfterCoupon.toString() : totalPrice.toString();
                            if(paymentMethod == 'online'){
                              if(delivery_Opt == 'Pickup'){
                                if(selectedAddressId != null && selectedWarehouseId != null && selectedWarehouseId!.isNotEmpty)
                                {
                                  StripeService(context, selectedList.join(','), totalPrice.toString(), discount.toString(),  totalAmount.toString(),
                                      paymentMethod , delivery_Opt, selectedAddressId.toString(), appliedCoupon.toString(), messageController.text, selectedWarehouseId.toString()).makePayment(context, totalAmount).then((e){
                                    // payment(context, selectedList.join(','), totalPrice.toString(), discount.toString(),  totalAmount.toString(),
                                    //     paymentMethod , delivery_Opt, selectedAddressId.toString(), appliedCoupon.toString(), messageController.text, selectedWarehouseId.toString());
                                    // context.read<PlaceOrderBloc>().add(PlaceOrderRefreshEvent(selectedList.join(','),
                                    //     totalPrice.toString(), discount.toString(), totalAmount.toString(),
                                    //     paymentMethod , delivery_Opt, selectedAddressId.toString(), appliedCoupon.toString(), messageController.text, warehouse_id: selectedWarehouseId.toString()));

                                  });
                                }else{
                                  Fluttertoast.showToast(msg: 'Please select an address first', backgroundColor: Colors.red);
                                }
                              }else{

                                if(selectedAddressId != null){
                                  StripeService(context, selectedList.join(','), totalPrice.toString(), discount.toString(),  totalAmount.toString(),
                                      paymentMethod , delivery_Opt, selectedAddressId.toString(), appliedCoupon.toString(), messageController.text, selectedWarehouseId.toString()).makePayment(context, totalAmount).then((e){
                                    // context.read<PlaceOrderBloc>().add(PlaceOrderRefreshEvent(selectedList.join(','),
                                    //     totalPrice.toString(), discount.toString(), totalAmount.toString(),
                                    //     paymentMethod , delivery_Opt, selectedAddressId.toString(), appliedCoupon.toString(), messageController.text, warehouse_id: selectedWarehouseId.toString()));

                                  });
                                }else{
                                  Fluttertoast.showToast(msg: 'Please select an address first', backgroundColor: Colors.red);
                                }
                              }


                            }else{
                              if(delivery_Opt == 'Pickup'){
                                if(selectedAddressId != null && selectedWarehouseId != null && selectedWarehouseId!.isNotEmpty){

                                  context.read<PlaceOrderBloc>().add(PlaceOrderRefreshEvent(selectedList.join(','),
                                      totalPrice.toString(), discount.toString(), totalAmount.toString(),
                                      paymentMethod , delivery_Opt, selectedAddressId.toString(), appliedCoupon.toString(), messageController.text, warehouse_id: selectedWarehouseId.toString()));
                                }else{
                                  Fluttertoast.showToast(msg: 'Please select an address first', backgroundColor: Colors.red);
                                }
                              }else{
                                if(selectedAddressId != null){

                                  context.read<PlaceOrderBloc>().add(PlaceOrderRefreshEvent(selectedList.join(','),
                                      totalPrice.toString(), discount.toString(), totalAmount.toString(),
                                      paymentMethod , delivery_Opt, selectedAddressId.toString(), appliedCoupon.toString(), messageController.text, warehouse_id: selectedWarehouseId.toString()));
                                }else{
                                  Fluttertoast.showToast(msg: 'Please select an address first', backgroundColor: Colors.red);
                                }
                              }
                            }


                            print('selectedList::::::::${selectedList.join(', ')}');
                            print('totalPrice::::::::::${totalPrice.toString()}');
                            print('discount::::::::::${discount.toString()}');
                            print('totalAmount::::::::::${totalAmount.toString()}');
                            print('deliveryOption:::::::${delivery_Opt}');
                            print('paymentMethod:::::::${paymentMethod}');
                            print('selectedWarehouseId:::::${selectedWarehouseId.toString()}');
                            print('selectedAddressId:::::::${selectedAddressId.toString()}');
                            print('appliedCoupon::::::::::${appliedCoupon.toString()}');
                            print('message::::::::::::::::${messageController.text}');

                          }),
                    ),
                    const SizedBox(height: 10,),
                  ],
                ),
              );
            }
            if(state is AllShippingAddressError){
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  // static payment( BuildContext context, var selectedList, var totalPrice, var discount, var totalAmount, var paymentMethod, var deliveryOpt, var selectedAddressId, var appliedCoupon,
  //     var message, var wareHouseId){
  //   context.read<PlaceOrderBloc>().add(PlaceOrderRefreshEvent(selectedList,
  //       totalPrice, discount, totalAmount,
  //       paymentMethod , deliveryOpt, selectedAddressId , appliedCoupon , message, warehouse_id: wareHouseId));
  //
  // }

  couponSheet(){
    couponSheetOpen = true;
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,

      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.48, // Set height to 50% of the screen height
          child: BlocBuilder<GetCouponModelBloc, GetCouponModelState>(
            builder: (context, state) {
              if(state is GetCouponModelLoading){
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Constant.bgOrangeLite,
                    size: 40,
                  ),);
              }
            if(state is GetCouponModelSuccess){
              return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Coupon Codes', style: TextStyles.font18w7(Colors.black),),
                          InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.cancel, color: Constant.bgOrangeLite,size: 24,)),
                        ],
                      ),
                    ),
                    const Divider(color: Constant.bgBtnGrey,thickness: 1,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        child: state.getCouponModel.availableCoupon!.isEmpty
                            ? Center(
                            child: Text('No Coupon')
                        )
                            : ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.getCouponModel.availableCoupon?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Constant.bgGreytile
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                      children: [
                                        Container(
                                          // height: 100,
                                          // width: 100,
                                          // color: Constant.bgGreen,
                                          child: Image.asset(promoCodes[index]['image'], ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(state.getCouponModel.availableCoupon![index].code.toString()/*promoCodes[index]['percentage']*/,
                                                      style: const TextStyle(color: Colors.white,
                                                          /*fontFamily: 'Gilroy-Bold',*/ fontWeight: FontWeight.w400,
                                                          fontSize: 12
                                                      ),),
                                                  ],
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(state.getCouponModel.availableCoupon![index].title.toString()/*promoCodes[index]['name']*/, style: TextStyle(
                                                /*fontFamily: 'Gilroy-SemiBold',*/ fontWeight: FontWeight.bold,
                                                  fontSize: 14),),
                                              Text(state.getCouponModel.availableCoupon![index].code.toString()/*promoCodes[index]['code']*/, style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text('${state.getCouponModel.availableCoupon![index].expire ?? 0} day after'/*promoCodes[index]['time']*/, style: const TextStyle(
                                                  color: Constant.bgGrey, fontWeight: FontWeight.w400,
                                                  fontSize: 14)),
                                              BlocListener<ApplyCouponBloc, ApplyCouponState>(
                                                listenWhen: (previous, current) => previous != current,
                                                listener: (context, state) {
                                                  // if (state is ApplyCouponSuccess) {
                                                  //   // If the couponCode is not empty, it means the coupon was applied successfully
                                                  //   if (state.applyCouponModel.status != false) {
                                                  //     final message = context.read<ApplyCouponBloc>().message;
                                                  //     final totalAmount1 = context.read<ApplyCouponBloc>().totalAmount;
                                                  //     discount = context.read<ApplyCouponBloc>().discount;
                                                  //     final coupon = context.read<ApplyCouponBloc>().couponCode;
                                                  //
                                                  //     totalPriceAfterCoupon = totalAmount1;
                                                  //     print('totalAmount1 $totalAmount1   $discount  $totalPriceAfterCoupon');
                                                  //
                                                  //     // Update the coupon code input field
                                                  //     // if(state.applyCouponModel.status != false){
                                                  //       print('status :::: ${state.applyCouponModel.status}');
                                                  //       couponController.text = coupon;
                                                  //       appliedCoupon = coupon;
                                                  //     // }
                                                  //     readOnly = true;
                                                  //
                                                  //     // Show a success message
                                                  //     if(message.isNotEmpty){
                                                  //       Fluttertoast.showToast(msg: message, backgroundColor: Constant.bgOrangeLite,);
                                                  //     }
                                                  //     Navigator.pop(context);
                                                  //   } else {
                                                  //     final message = context.read<ApplyCouponBloc>().message;
                                                  //     discount = context.read<ApplyCouponBloc>().discount;
                                                  //     final totalAmount1 = context.read<ApplyCouponBloc>().totalAmount;
                                                  //     totalPriceAfterCoupon = totalAmount1;
                                                  //     couponController.clear();
                                                  //     Navigator.pop(context);
                                                  //     if(message.isNotEmpty){
                                                  //       Fluttertoast.showToast(msg: message, backgroundColor: Constant.bgOrangeLite,);
                                                  //     }
                                                  //   }
                                                  // }
                                                  //
                                                  // if (state is ApplyCouponError) {
                                                  //   // Handle the error case properly
                                                  //   couponController.clear();
                                                  //   print(state.error);
                                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                                  //     SnackBar(content: Text(state.error)),
                                                  //   );
                                                  // }
                                                },
                                                child: InkWell(
                                                  onTap: () {
                                                    // Add event to apply the coupon when tapped
                                                    context.read<ApplyCouponBloc>().add(
                                                      ApplyNewCouponEvent(
                                                        context,
                                                        cartIds,
                                                        state.getCouponModel.availableCoupon![index].code.toString(),
                                                        totalPrice.toString(),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      color: Constant.bgOrange,
                                                      gradient: LinearGradient(colors: [Constant.bgLinearColor1, Constant.bgLinearColor2]),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Center(
                                                      child: state.getCouponModel.availableCoupon![index].loading == true
                                                          ? Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: SizedBox(
                                                          height: 10,
                                                          width: 10,
                                                          child: CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 1,
                                                          ),
                                                        ),
                                                      )
                                                          : Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },),
                      ),
                    )
                  ],
                );
            }
            // if(state is GetCouponModelError){
            //   return Center(
            //     child: Text(state.error),
            //   );
            // }
            return SizedBox();
          },)

        );
      },
    );
  }

  showOrderDialog(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // Handle the back button press and navigate to your desired screen
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 0,)), (route) => false,);
            return false; // Prevent the dialog from closing
          },
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Container(
              height: 370,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Image.asset('assets/profile/ordersuccess.png', height: 112, width: 112,),
                  const SizedBox(height: 40,),
                  const Text('Order Confirmed!', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),),
                  const SizedBox(height: 10,),
                  const Text('Your order has been placed',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                  const Text('successfully. ',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Btn('', height: 50, width: MediaQuery.of(context).size.width,
                        linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                        name: 'Continue', callBack: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 0,)), (route) => false,);
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
