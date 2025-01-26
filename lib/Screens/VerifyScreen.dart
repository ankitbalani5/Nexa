import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/NavBar.dart';
import 'package:nexa/Screens/CreateProfile.dart';
import 'package:nexa/Screens/ResetPassword.dart';
import 'package:nexa/Widget/Btn.dart';

class VerifyScreen extends StatefulWidget {
  String path;
  VerifyScreen(this.path, {super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SvgPicture.asset('assets/login/verify.svg'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Image.asset('assets/login/verify.png'),
            ),
            const SizedBox(height: 20,),
            const Text('Successfully', style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 28)),
            const SizedBox(height: 20,),
            const Text('Thank you for verifying the Email '
                'Address. The Email Address is now verified',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 16,
            color: Constant.bgGrey)),
            const SizedBox(height: 30,),
            Btn('', height: 50, width: MediaQuery.of(context).size.width,
                linearColor1: Constant.bgLinearColor1,
                linearColor2: Constant.bgLinearColor2,
                name: 'Continue', callBack: widget.path == 'ForgotPassword'
                    ? (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                      }
                    : widget.path == 'Signup'  ? (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
                      }
                    : (){
                        // con
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar()));
                      }
                )

          ],
        ),
      ),
    );
  }
}
