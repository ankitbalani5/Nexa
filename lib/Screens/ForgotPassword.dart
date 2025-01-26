import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nexa/Screens/OtpForgotPassword.dart';
import 'package:nexa/Screens/OtpScreen.dart';
import 'package:nexa/Screens/ResetPassword.dart';
import 'package:nexa/Widget/Btn.dart';

import '../Bloc/ForgotPasswordBloc/forgot_password_bloc.dart';
import '../Constant.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60,),
              const Center(child: Text('Forgot Password', style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 30, fontWeight: FontWeight.w700))),
              const Text('lorem Ipsum is simply dunkjdf slkjf'
                  ' lkjdf  ljd f dsjf l jfdkldsj'
                  , textAlign: TextAlign.center
                  , style: TextStyle(
                      fontFamily: 'Roboto', color: Constant.bgGrey,
                      fontSize: 16, fontWeight: FontWeight.w400)),
              const SizedBox(height: 20,),
              const Text('Email', style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Please enter email';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                cursorColor: Constant.bgTextfieldHint,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                  fillColor: Constant.bgTextField,
                  // contentPadding: EdgeInsets.all(10),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent)
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if(state is ForgotPasswordSuccess){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtpForgotPassword(emailController.text.toString(), )));

                  }
                  if(state is ForgotPasswordError){
                    Fluttertoast.showToast(msg: state.error, backgroundColor: Colors.red);
                  }
                },
                builder: (context, state) {
                  return Btn('', height: 50, width: MediaQuery.of(context).size.width ,
                    linearColor1: Constant.bgLinearColor1,
                    linearColor2: Constant.bgLinearColor2,
                    name: state is ForgotPasswordLoading ? '' : 'Continue', callBack: state is ForgotPasswordLoading
                        ? (){}
                        : (){
                      if(_formKey.currentState!.validate()){
                        context.read<ForgotPasswordBloc>().add(ForgotPasswordRefreshEvent(emailController.text));
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                    },
                    child: state is ForgotPasswordLoading  ? CircularProgressIndicator(color: Colors.white) : null,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
