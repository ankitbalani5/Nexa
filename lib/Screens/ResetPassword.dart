import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nexa/Bloc/ForgotPasswordBloc/forgot_password_bloc.dart';
import 'package:nexa/Bloc/ResetPasswordBloc/reset_password_bloc.dart';
import 'package:nexa/Screens/Login.dart';
import 'package:nexa/Screens/SuccessForgotPassword.dart';

import '../Constant.dart';
import '../Widget/Btn.dart';

class ResetPassword extends StatefulWidget {
  String email;
  ResetPassword(this.email, {super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var _formKey = GlobalKey<FormState>();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
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
              const Center(child: Text('Reset Password', style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 30, fontWeight: FontWeight.w700))),
              const Text('lorem Ipsum is simply dunkjdf slkjf'
                  ' lkjdf  ljd f dsjf l jfdkldsj'
                  , textAlign: TextAlign.center
                  , style: TextStyle(
                      fontFamily: 'Roboto', color: Constant.bgGrey,
                      fontSize: 16, fontWeight: FontWeight.w400)),
              const SizedBox(height: 20,),
              const Text('Create New Password', style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10,),
              TextFormField(
                controller: passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    filled: true,
                    hintText: 'Create New Password',
                    hintStyle: TextStyle(color: Constant.bgTextfieldHint),
                    fillColor: Constant.bgTextField,
                    // contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)
                    )
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Password";
                  } else if (value.length < 8) {
                    return "Password must be at least 8 characters long";
                  } else if (!value.contains(RegExp(r'[A-Z]'))) {
                    return "Password must contain at least one uppercase letter";
                  } else if (!value.contains(RegExp(r'[a-z]'))) {
                    return "Password must contain at least one lowercase letter";
                  } else if (!value.contains(RegExp(r'[0-9]'))) {
                    return "Password must contain at least one digit";
                  } else if (!value
                      .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    return "Password must contain at least one special character";
                  }
                  return null; // Return null if the password is valid
                },
                // validator: (value) {
                //   if(value == null || value.isEmpty ){
                //     return 'Please enter confirm password';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 20,),
              const Text('Confirm Password', style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10,),
              TextFormField(
                controller: confirmPasswordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    filled: true,
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(color: Constant.bgTextfieldHint),
                    fillColor: Constant.bgTextField,
                    // contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)
                    )
                ),
                validator: (value) {
                  if(value == null || value.isEmpty ){
                    return 'Please enter confirm password';
                  }else if(value != passwordController.text){
                    return 'Confirm password should be match password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30,),
              BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                listener: (context, state) {
                  if(state is ResetPasswordSuccess){
                    Fluttertoast.showToast(msg: state.message);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false,);

                  }
                  if(state is ResetPasswordError){
                    Fluttertoast.showToast(msg: state.error);
                  }
                },
                builder: (context, state) {
                  return Btn('', height: 50, width: MediaQuery.of(context).size.width ,
                    linearColor1: Constant.bgLinearColor1,
                    linearColor2: Constant.bgLinearColor2,
                    name: state is ResetPasswordLoading ? '' : 'Save', callBack: state is ResetPasswordLoading
                        ? (){}
                        : (){
                      if(_formKey.currentState!.validate()){
                        context.read<ResetPasswordBloc>().add(ResetPasswordRefreshEvent(widget.email, passwordController.text));
                      }
                    },
                    child: state is ResetPasswordLoading ? CircularProgressIndicator() : null,
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
