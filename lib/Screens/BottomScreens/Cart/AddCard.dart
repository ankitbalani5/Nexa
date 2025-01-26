import 'package:flutter/material.dart';
import 'package:nexa/Screens/BottomScreens/Cart/AddNewCard.dart';
import 'package:nexa/Widget/Btn.dart';

import '../../../Constant.dart';
import '../../../Widget/TextStyles.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String delivery_Opt = 'Pickup';
  String paymentMethod = 'Cash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/profile/back.png', height: 30, width: 30,),
          ),
        ),
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                paymentMethod = 'Cash';
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Constant.bgOrangeLite.withOpacity(.10),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/cash_delivery.png', height: 40, width: 40),
                          SizedBox(width: 10,),
                          Text('Cash on Delivery', style: TextStyles.font16w5(Colors.black))
                        ],
                      ),
                      Radio(
                        value: 'Cash',
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
                paymentMethod = 'Credit';
                setState(() {

                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Constant.bgOrangeLite.withOpacity(.10),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/work_delivery.png', height: 40, width: 40),
                          SizedBox(width: 10,),
                          Text('Credit/Debit Card', style: TextStyles.font16w5(Colors.black),)
                        ],
                      ),
                      Radio(
                        value: 'Credit',
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
            SizedBox(height: 20,),
            Btn('borderColor', height: 50, width: MediaQuery.of(context).size.width,
              linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
              name: 'Add New Card', callBack: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewCard()));
            },)
          ],
        ),
      ),
    );
  }
}
