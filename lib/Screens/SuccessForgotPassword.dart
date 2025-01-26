import 'package:flutter/material.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Screens/Login.dart';
import 'package:nexa/Widget/Btn.dart';

class SuccessForgotPassword extends StatefulWidget {
  const SuccessForgotPassword({super.key});

  @override
  State<SuccessForgotPassword> createState() => _SuccessForgotPasswordState();
}

class _SuccessForgotPasswordState extends State<SuccessForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/login/success.png', height: 150, width: 250,)),
            SizedBox(height: 20,),
            Text('Successfully', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),),
            SizedBox(height: 20,),
            Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),),
            SizedBox(height: 20,),
            Btn('', height: 50, width: MediaQuery.of(context).size.width,
                linearColor1: Constant.bgLinearColor1,
                linearColor2: Constant.bgLinearColor2,
                name: 'Continue', callBack: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                })
          ],
        ),
      ),
    );
  }
}
