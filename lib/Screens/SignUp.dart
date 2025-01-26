import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexa/Bloc/CustomerExistingBloc/customer_existing_bloc.dart';
import 'package:nexa/Screens/Login.dart';
import 'package:page_transition/page_transition.dart';

import '../Constant.dart';
import '../NavBar.dart';
import '../Widget/Btn.dart';
import '../auth/Auth.dart';
import 'OtpScreen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _formKey = GlobalKey<FormState>();
  var phoneController = TextEditingController();
  String _countryName = 'PH'; // Default country code
  String _countryCode = '+63'; // Default country code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60,),
                const Center(child: Text('Sign Up', style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30, fontWeight: FontWeight.w700))),

                const SizedBox(height: 10,),
                const Text('lorem Ipsum is simply dunkjdf slkjf'
                    ' lkjdf  ljd f dsjf l jfdkldsj'
                    , textAlign: TextAlign.center
                    , style: TextStyle(
                        fontFamily: 'Roboto', color: Constant.bgGrey,
                        fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 40,),
                const Text('Mobile Number', style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5,),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  cursorColor: Constant.bgTextfieldHint,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter mobile number';
                    }
                    if (!Constant.validatePhoneNumber(value, _countryName)) {
                      return 'Invalid phone number for country $_countryName';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    prefixIcon: CountryCodePicker(
                      onChanged: (country) {
                        setState(() {
                          _countryName = country.code!;
                          _countryCode = country.dialCode!;
                        });
                      },
                      initialSelection: _countryCode,
                      showFlag: true,
                      textStyle: TextStyle(color: Constant.bgTextfieldHint),
                    ),
                    filled: true,
                    hintText: 'Enter mobile number',
                    hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                    fillColor: Constant.bgTextField,
                    // contentPadding: EdgeInsets.all(10),
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
                const SizedBox(height: 30,),
                BlocConsumer<CustomerExistingBloc, CustomerExistingState>(
                  listener: (context, state) {
                    if(state is CustomerExistingSuccess){
                      if(state.customerExistingModel.status == 'success'){
                        ScaffoldMessenger.of(context).clearSnackBars();
                        Auth.firebaseOtpVerify('Signup', _countryCode, phoneController.text, context);
                        // Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OtpScreen('Signup', phoneController.text.toString(), _countryCode)));
                      }else{
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.customerExistingModel.message.toString())));

                      }
                    }
                  },
                  builder: (context, state) {
                    return Btn('', height: 50, width: MediaQuery.of(context).size.width,
                      linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                      name: state is CustomerExistingLoading ? '' :'Continue', callBack: () {
                        if(_formKey.currentState!.validate()){
                          context.read<CustomerExistingBloc>().add(CustomerExistingRefreshEvent(phoneController.text.toString(), _countryCode));
                          // Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OtpScreen('Signup')));
                        }

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
                      },

                      child: state is CustomerExistingLoading ? CircularProgressIndicator(color: Colors.white) : null,
                    );
                  },
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        surfaceTintColor: Colors.white,
        color: Colors.transparent,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account ",
                  style: TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 14,)),
              InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text('Log In ',
                    style: TextStyle(color: Constant.bgOrangeLite,
                      fontWeight: FontWeight.w500, fontSize: 14,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
