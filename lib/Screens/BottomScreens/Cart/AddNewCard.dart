import 'package:flutter/material.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:nexa/Widget/TextField/TextField.dart';
import 'package:nexa/Widget/TextStyles.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  var nameController = TextEditingController();

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
        title: const Text('Add New Card', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),

            Text('Card Holder Name', style: TextStyles.font18w7(Colors.black),),
            SizedBox(height: 10,),
            TextFields.myTextField(hint: 'Enter card name', controller: nameController),

            SizedBox(height: 20,),
            Text('Card Number', style: TextStyles.font18w7(Colors.black),),
            SizedBox(height: 10,),
            TextFields.myTextField(hint: 'Enter card number', controller: nameController),

            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('Exp Month', style: TextStyles.font18w7(Colors.black),),
                      SizedBox(height: 10,),
                      TextFields.myTextField(hint: 'Enter Month', controller: nameController)
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('Exp Date', style: TextStyles.font18w7(Colors.black),),
                      SizedBox(height: 10,),
                      TextFields.myTextField(hint: 'Enter Date', controller: nameController)
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 20,),
            Text('Cvv', style: TextStyles.font18w7(Colors.black),),
            SizedBox(height: 10,),
            TextFields.myTextField(hint: 'CVV pin', controller: nameController),
            SizedBox(height: 40,),
            Btn('borderColor', height: 50, width: MediaQuery.of(context).size.width,
              linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
              name: 'Save', callBack: () {

            },)
          ],
        ),
      ),
    );
  }
}
