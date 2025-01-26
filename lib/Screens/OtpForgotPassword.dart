import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/OtpVerifyForgotPasswordBloc/otp_verify_forgot_password_bloc.dart';
import 'package:nexa/Screens/ResetPassword.dart';
import 'package:pinput/pinput.dart';

import '../Bloc/ForgotPasswordBloc/forgot_password_bloc.dart';
import '../Constant.dart';
import '../Widget/Btn.dart';

class OtpForgotPassword extends StatefulWidget {
  String email;
  OtpForgotPassword(this.email, {super.key});

  @override
  State<OtpForgotPassword> createState() => _OtpForgotPasswordState();
}

class _OtpForgotPasswordState extends State<OtpForgotPassword> {
  var _formKey = GlobalKey<FormState>();
  var otpController = TextEditingController();
  // var otp = '123456';

  final defaultPinTheme = PinTheme(
    width: 54,
    height: 50,
    textStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        // color: Color.fromRGBO(30, 60, 87, 1),
        color: Constant.bgOrangeLite
    ),
    decoration: BoxDecoration(
      color: Constant.bgTextField,
      borderRadius: BorderRadius.circular(10),
      // border: Border.all(color: borderColor),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60,),
                const Center(child: Text('Verification Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 30, fontWeight: FontWeight.w700))),
                SizedBox(height: 10,),
                const Center(
                  child: Text('Please type the verification code sent to'
                      , textAlign: TextAlign.center
                      , style: TextStyle(
                          fontFamily: 'Roboto', color: Constant.bgGrey,
                          fontSize: 16, fontWeight: FontWeight.w400)),
                ),
                Center(
                  child: Text(widget.email != null ? widget.email.toString() : '' /*'(91+)78xxxxxx65'*/
                      , textAlign: TextAlign.center
                      , style: TextStyle(
                          fontFamily: 'Roboto', color: Constant.bgOrangeLite,
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 35,),
                Center(
                  child: Pinput(
                    controller: otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => SizedBox(width: 10),
                    // Custom theme for the filled field
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Constant.bgTextField,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange), // Orange border for filled fields
                      ),
                    ),
                    // Custom theme for the focused field
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: Constant.bgTextField,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.orange), // Orange border when focused
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 6) {
                        return 'Enter OTP';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20,),
                BlocConsumer<OtpVerifyForgotPasswordBloc, OtpVerifyForgotPasswordState>(
                  listener: (context, state) {
                    if(state is OtpVerifyForgotPasswordSuccess){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPassword(widget.email)));
                    }
                    if(state is OtpVerifyForgotPasswordError){
                      Fluttertoast.showToast(msg: state.error, backgroundColor: Colors.red);
                    }
                  },
                  builder: (context, state) {
                    return Btn('', height: 50, width: MediaQuery.of(context).size.width,
                      linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                      name: state is OtpVerifyForgotPasswordLoading ? '' : 'Verify', callBack: state is OtpVerifyForgotPasswordLoading
                          ? (){}
                          : (){
                        if(_formKey.currentState!.validate()){

                          context.read<OtpVerifyForgotPasswordBloc>().add(OtpVerifyForgotPasswordRefreshEvent(widget.email, otpController.text));
                        }
                      },
                      child: state is OtpVerifyForgotPasswordLoading ? Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.white,
                          size: 40,
                        ),) : null,
                    );
                  },
                ),
                const SizedBox(height: 26,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I don't receive a code! ", style: TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 16)),
                    BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                    listener: (context, state) {
                      if(state is ForgotPasswordSuccess){
                        Fluttertoast.showToast(msg: 'Otp Resend Successfully', backgroundColor: Constant.bgOrangeLite);
                      }
                    },
                    child: InkWell(
                      onTap: () {

                        context.read<ForgotPasswordBloc>().add(ForgotPasswordRefreshEvent(widget.email));
                      },
                      child: const Text("Resend", style: TextStyle(color: Constant.bgOrangeLite,
                          fontWeight: FontWeight.w700, fontSize: 16),),
                    ),
                    ),
                  ],
                )

                // SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
