import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/CustomerRegisterOrLoginBloc/customer_register_or_login_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constant.dart';
import '../NavBar.dart';
import '../Widget/Btn.dart';
import '../auth/Auth.dart';
import 'CreateProfile.dart';
import 'ResetPassword.dart';
import 'VerifyScreen.dart';

class OtpScreen extends StatefulWidget {
  String path;
  String phoneOrEmail;
  String countryCode;
  String verificationId;
  OtpScreen(this.path, this.phoneOrEmail, this.countryCode, {this.verificationId = '' ,super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var _formKey = GlobalKey<FormState>();
  var otpController = TextEditingController();
  var otp = '123456';

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
  void initState() {
    super.initState();
  }

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
                SizedBox(height: 10),
                const Center(
                  child: Text('Please type the verification code sent to'
                      , textAlign: TextAlign.center
                      , style: TextStyle(
                          fontFamily: 'Roboto', color: Constant.bgGrey,
                          fontSize: 16, fontWeight: FontWeight.w400)),
                ),
                Center(
                  child: Text('${widget.countryCode} ${widget.phoneOrEmail}'
                      , textAlign: TextAlign.center
                      , style: TextStyle(
                          fontFamily: 'Roboto', color: Constant.bgOrangeLite,
                          fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 35,),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
                ),
                const SizedBox(height: 20,),
                BlocConsumer<CustomerRegisterOrLoginBloc, CustomerRegisterOrLoginState>(
                  listener: (context, state) async {
                    if(state is CustomerRegisterOrLoginSuccess){
                      if(state.customerRegisterOrLoginModel.status == 'success'){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => NavBar()));
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.setString('token', state.customerRegisterOrLoginModel.token.toString());
                        pref.setString('phone', state.customerRegisterOrLoginModel.userdata!.phone.toString());
                        pref.setString('image', state.customerRegisterOrLoginModel.userdata!.image.toString());
                        pref.setString('country_code', state.customerRegisterOrLoginModel.userdata!.countryCode.toString());
                        pref.setString('current_steps', state.customerRegisterOrLoginModel.userdata!.currentSteps.toString());
                        Constant.token = pref.getString('token');
                        Constant.countryCode = pref.getString('country_code');
                        Constant.phone = pref.getString('phone');
                        Constant.image = pref.getString('image');

                        print('token ::: ${Constant.token}');
                        if (widget.path == 'Signup') {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CreateProfile()), (Route<dynamic> route) => false);
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateProfile()));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
                        } else {
                          pref.setBool('login', true);
                          pref.setString('first_name', state.customerRegisterOrLoginModel.userdata!.firstName.toString());
                          pref.setString('last_name', state.customerRegisterOrLoginModel.userdata!.lastName.toString());
                          pref.setString('email', state.customerRegisterOrLoginModel.userdata!.email.toString());
                          pref.setString('country', state.customerRegisterOrLoginModel.userdata!.country.toString());

                          Constant.firstName = pref.getString('first_name');
                          Constant.lastName = pref.getString('last_name');
                          Constant.email = pref.getString('email');
                          Constant.country = pref.getString('country');
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar()), (route) => false);
                        }

                      }
                    }
                  },
                  builder: (BuildContext context, CustomerRegisterOrLoginState state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Btn('', height: 50, width: MediaQuery.of(context).size.width,
                        linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                        name: state is CustomerRegisterOrLoginLoading ? '' : 'Verify', callBack:
                        state is CustomerRegisterOrLoginLoading ? (){} : (){
                          if(_formKey.currentState!.validate()){
                            _verifyOTP();
                            // if(otpController.text == otp ){
                            //
                            //   if (widget.path == 'ForgotPassword') {
                            //     // Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                            //   } else if (widget.path == 'Signup') {
                            //     context.read<CustomerRegisterOrLoginBloc>().add(CustomerRegisterOrLoginRefreshEvent(widget.phoneOrEmail, widget.countryCode, Constant.deviceToken));
                            //
                            //     // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
                            //   } else {
                            //     context.read<CustomerRegisterOrLoginBloc>().add(CustomerRegisterOrLoginRefreshEvent(widget.phoneOrEmail, widget.countryCode, Constant.deviceToken));
                            //   }
                            // }else{
                            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Otp is wrong')));
                            // }
                          }
                        },
                        child: state is CustomerRegisterOrLoginLoading ? Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: Colors.white,
                            size: 40,
                          ),) : null,
                      ),
                    );
                  },

                ),
                const SizedBox(height: 26,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("I don't receive a code! ", style: TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 16)),
                    Text("Resend", style: TextStyle(color: Constant.bgOrange,
                        fontWeight: FontWeight.w700, fontSize: 16),),
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

  void _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      // setState(() {
      //   _isLoading = true;
      // });

      String smsCode = otpController.text.trim();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        // setState(() {
        //   _isLoading = false;
        // });

        // Navigate to home or desired screen
        if (widget.path == 'ForgotPassword') {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
        } else if (widget.path == 'Signup') {
          context.read<CustomerRegisterOrLoginBloc>().add(CustomerRegisterOrLoginRefreshEvent(widget.phoneOrEmail, widget.countryCode, Constant.deviceToken));

        } else {
          context.read<CustomerRegisterOrLoginBloc>().add(CustomerRegisterOrLoginRefreshEvent(widget.phoneOrEmail, widget.countryCode, Constant.deviceToken));
        }
      } on FirebaseAuthException catch (e) {
        // setState(() {
        //   _isLoading = false;
        // });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    }
  }

  void _resendOTP() async {
    // Implement resend OTP logic if needed
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneOrEmail,
      timeout: Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your home screen
        //       (Route<dynamic> route) => false,
        // );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification Failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        widget.verificationId = verificationId;
        setState(() {
          // Update verificationId if needed
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Resent')),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );
  }


}
