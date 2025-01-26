import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../Bloc/PlaceOrderBloc/place_order_bloc.dart';
import '../Constant.dart';
import '../NavBar.dart';
import '../Widget/Btn.dart';


class StripeService {
  Map<String, dynamic>? paymentIntent;
  BuildContext context; var selectedList; var totalPrice; var discount; var totalAmount; var paymentMethod; var deliveryOpt; var selectedAddressId; var appliedCoupon;
  var message; var wareHouseId;
  StripeService(this.context, this.selectedList, this.totalPrice, this.discount, this.totalAmount, this.paymentMethod, this.deliveryOpt, this.selectedAddressId, this.appliedCoupon,
      this.message, this.wareHouseId);

  Future<void> makePayment(BuildContext context, String payment) async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent(payment, 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(

          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Ikay'))
          .then((value) {

      });

      //STEP 3: Display Payment sheet
      displayPaymentSheet(context);
    } catch (err) {
      throw Exception(err);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('payment response::::::::::::${json.decode(response.body)}');
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // static payment( BuildContext context, var selectedList, var totalPrice, var discount, var totalAmount, var paymentMethod, var deliveryOpt, var selectedAddressId, var appliedCoupon,
  //     var message, var wareHouseId){
  //   context.read<PlaceOrderBloc>().add(PlaceOrderRefreshEvent(selectedList,
  //       totalPrice, discount, totalAmount,
  //       paymentMethod , deliveryOpt, selectedAddressId , appliedCoupon , message, warehouse_id: wareHouseId));
  //
  // }


  displayPaymentSheet(BuildContext context) async {

    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        context.read<PlaceOrderBloc>().add(PlaceOrderRefreshEvent(selectedList,
            totalPrice, discount, totalAmount,
            paymentMethod , deliveryOpt, selectedAddressId , appliedCoupon , message, warehouse_id: wareHouseId));
        BlocListener<PlaceOrderBloc, PlaceOrderState>(listener: (context, state) {
          if(state is PlaceOrderLoading){

          }
          if(state is PlaceOrderSuccess){
            // showOrderDialog(){
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
        },);

        // }
        // showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //       content: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: const [
        //           Icon(
        //             Icons.check_circle,
        //             color: Colors.green,
        //             size: 100.0,
        //           ),
        //           SizedBox(height: 10.0),
        //           Text("Payment Successful!"),
        //         ],
        //       ),
        //     ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  //calculate Amount
  calculateAmount(String amount) {
    print(amount);
    print(double.parse(amount));
    var calculatedAmount = double.parse(amount) * 100;
    print("gguf");
    print(calculatedAmount);
    print("furfugur${calculatedAmount.toInt().toString()}");
    return calculatedAmount.toInt().toString();
  }

}