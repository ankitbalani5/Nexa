import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/CustomerExistingBloc/customer_existing_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Screens/CreateProfile.dart';
import 'package:nexa/Screens/ForgotPassword.dart';
import 'package:nexa/Screens/OtpScreen.dart';
import 'package:nexa/Screens/SignUp.dart';
import 'package:nexa/Screens/TermConditionPage.dart';
import 'package:nexa/SocialAuth.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Bloc/LoginBloc/login_bloc.dart';
import '../NavBar.dart';
import '../auth/Auth.dart';
import 'PrivacyPolicyPage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loginWithPhone = false;
  bool eyeToggle = true;
  var token;
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var _formKeyEmail = GlobalKey<FormState>();
  var _formKeyMobile = GlobalKey<FormState>();
  // static const _initialCountryCode = 'US';
  String _countryName = 'PH'; // Default country code
  String _countryCode = '+63'; // Default country code
  // var _country =
  // countries.firstWhere((element) => element.code == _countryName);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: Colors.white, // status bar color
        ));
    return Scaffold(
      // appBar: AppBar(
      //   leading: const SizedBox(),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60,),
              const Center(child: Text('Log In', style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 30, fontWeight: FontWeight.w700))),
              SizedBox(height: 10,),
              const Text('lorem Ipsum is simply dunkjdf slkjf'
                  ' lkjdf  ljd f dsjf l jfdkldsj'
                  , textAlign: TextAlign.center
                  , style: TextStyle(
                      fontFamily: 'Roboto', color: Constant.bgGrey,
                      fontSize: 16, fontWeight: FontWeight.w400,)),
              const SizedBox(height: 35,),
              // Text(!loginWithPhone ? 'Mobile Number' : 'Email', style: const TextStyle(
              //     fontFamily: 'Roboto',
              //     fontSize: 18, fontWeight: FontWeight.w500)),
              // const SizedBox(height: 10,),
              // login with email
              Visibility(
                visible: !loginWithPhone,
                child: Form(
                  key: _formKeyEmail,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email', style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5,),
                      // Email
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
                      // password
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Text('Password', style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            obscureText: eyeToggle,
                            validator: (value) {
                              if(value == null || value.isEmpty){
                                return 'Please enter password';
                              }
                              return null;
                            },
                            cursorColor: Constant.bgTextfieldHint,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                filled: true,
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                fillColor: Constant.bgTextField,
                                suffixIcon: InkWell(
                                    onTap: (){
                                      eyeToggle = !eyeToggle;
                                      setState(() {

                                      });
                                    },
                                    child: eyeToggle
                                        ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset('assets/login/Icon eye.png', height: 10, width: 10,),
                                    )
                                        : Icon(/*Icons.visibility_off_outlined
                                        : */Icons.visibility_outlined, color: Constant.bgTextfieldHint,)),
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
                                )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) async {
                            if(state is LoginSuccess){
                              SharedPreferences pref = await SharedPreferences.getInstance();
                              pref.setString('token', state.loginModel.token.toString());
                              pref.setString('first_name', state.loginModel.userData!.firstName.toString());
                              pref.setString('last_name', state.loginModel.userData!.lastName.toString());
                              pref.setString('email', state.loginModel.userData!.email.toString());
                              pref.setString('country', state.loginModel.userData!.country.toString());
                              pref.setString('country_code', state.loginModel.userData!.countryCode.toString());
                              pref.setString('phone', state.loginModel.userData!.phone.toString());
                              pref.setString('image', state.loginModel.userData!.image.toString());
                              pref.setString('current_steps', state.loginModel.userData!.currentSteps.toString());
                              Constant.token = pref.getString('token');
                              Constant.firstName = pref.getString('first_name');
                              Constant.lastName = pref.getString('last_name');
                              Constant.email = pref.getString('email');
                              Constant.country = pref.getString('country');
                              Constant.countryCode = pref.getString('country_code');
                              Constant.phone = pref.getString('phone');
                              Constant.image = pref.getString('image');
                              pref.setBool('login', true);
                              print('token : ${Constant.token}');

                              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: NavBar()));
                            }
                            if(state is LoginError){
                              Fluttertoast.showToast(msg: state.error, backgroundColor: Colors.red, textColor: Colors.white);
                            }
                          },
                          builder: (context, state){
                            return Visibility(
                              visible: !loginWithPhone,
                              child: Btn(
                                '',
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                linearColor1: Constant.bgLinearColor1,
                                linearColor2: Constant.bgLinearColor2,
                                name: state is LoginLoading ? '' : 'Continue',
                                callBack: () {
                                  print('email ::::::: ${emailController.text}');
                                  print('password ::::::: ${passwordController.text}');
                                  if (_formKeyEmail.currentState!.validate()) {
                                    context.read<LoginBloc>().add(
                                        LoginRefreshEvent(emailController.text.toString().trim(),
                                            passwordController.text.toString().trim(), Constant.fcmToken));
                                  }
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
                                },
                                child: state is LoginLoading ? Center(
                                  child: LoadingAnimationWidget.fourRotatingDots(
                                    color: Colors.white,
                                    size: 40,
                                  ),) : null,

                              ),
                            );
                          })

                    ],
                  ),
                ),
              ),

              // login with mobile
              Visibility(
                visible: loginWithPhone,
                child: Form(
                  key: _formKeyMobile,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mobile Number', style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10,),
                      // mobile
                      // IntlPhoneField(
                      //   autofocus: true,
                      //   controller: phoneController,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Phone Number',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   // initialCountryCode: 'US',
                      //   validator: (value) {
                      //     if (value == null || value!.completeNumber.isEmpty) {
                      //       return 'Please enter a phone number';
                      //     }
                      //     return null;
                      //   },
                      //   initialCountryCode: _initialCountryCode,
                      //   onChanged: (value) {
                      //     if (value.number.length >= _country.minLength &&
                      //         value.number.length <= _country.maxLength) {
                      //       // Run anything here
                      //     }
                      //   },
                      //   onCountryChanged: (country) => _country = country,
                      // ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: phoneController,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'Please enter mobile number';
                          }
                          else if (!Constant.validatePhoneNumber(value, _countryName)) {
                            return 'Invalid phone number for country $_countryName';
                          }
                          return null;
                        },
                        cursorColor: Constant.bgTextfieldHint,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Enter your number',
                          hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                          fillColor: Constant.bgTextField,
                          // contentPadding: EdgeInsets.all(10),
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
                      SizedBox(height: 20,),
                      BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) async {
                          if(state is LoginSuccess){
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setString('token', state.loginModel.token.toString());
                            token = pref.getString('token');
                            print('token : $token');
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: NavBar()));
                          }
                          if(state is LoginError){
                            Fluttertoast.cancel();
                            Fluttertoast.showToast(msg: state.error, backgroundColor: Constant.bgOrangeLite, textColor: Colors.white);
                          }
                        },
                        child: Visibility(
                            visible: loginWithPhone,
                            child: BlocConsumer<CustomerExistingBloc, CustomerExistingState>(

                              listener: (context, state) {
                                if(state is CustomerExistingSuccess){
                                  if(state.customerExistingModel.status == 'success'){
                                    ScaffoldMessenger.of(context).clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.customerExistingModel.message.toString())));
                                  }else{
                                    ScaffoldMessenger.of(context).clearSnackBars();

                                    Auth.firebaseOtpVerify('login', _countryCode, phoneController.text, context);
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen('login', phoneNumber.toString(), countryCode, verificationId: verificationId)));

                                  }
                                }
                              },
                              builder: (context, state) {
                                return Btn('', height: 50, width: MediaQuery.of(context).size.width,
                                  linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                                  name: state is CustomerExistingLoading ? '' : 'Continue', callBack: state is CustomerExistingLoading
                                      ? (){}
                                      : () {
                                  print('phone number ::::::::::: ${phoneController.text}');
                                  print('countryCode number ::::::::::: ${_countryCode}');
                                    if(_formKeyMobile.currentState!.validate()){
                                      context.read<CustomerExistingBloc>().add(CustomerExistingRefreshEvent(phoneController.text.toString().trim(), _countryCode.toString().trim()));
                                    }
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
                                  },
                                  child: state is CustomerExistingLoading ? Center(
                                    child: LoadingAnimationWidget.fourRotatingDots(
                                      color: Colors.white,
                                      size: 40,
                                    ),) : null,
                                );
                              },
                            )

                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: !loginWithPhone,
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: const ForgotPassword()));

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                      },
                      child: const Text('Forgot Password', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14,
                          color: Constant.bgOrangeLite
                      ),),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      loginWithPhone = !loginWithPhone;
                      setState(() {

                      });
                    },
                    child: Text(loginWithPhone ? 'Log In with Email' : 'Log In with Phone Number',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14,

                        )),
                  ),

                ],
              ),
              const SizedBox(height: 20,),
              const Center(child: Text('Or', style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18,)
              )),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Constant.showDialogProgress(context);
                  SocialAuth().googleLogin(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateProfile()));
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constant.bgBtnGrey
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/login/google.svg'),
                      const SizedBox(width: 10,),
                      const Text('Continue With Google', style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 18,))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  Constant.showDialogProgress(context);
                  SocialAuth().facebookLogin(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Constant.bgBtnGrey
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/login/facebook.png', height: 20, width: 20,),
                      const SizedBox(width: 10,),
                      const Text('Continue With Facebook', style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 18,))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: RichText(textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black, // Default text color
                    ),
                    children: [
                      TextSpan(
                        text: 'By continuing, you agree to our ',
                      ),
                      TextSpan(
                        text: 'Terms of Use ',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Constant.bgOrangeLite,
                          color: Constant.bgOrangeLite,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TermConditionPage()),
                            );
                          },
                      ),
                      TextSpan(
                        text: 'and',
                      ),
                    ],
                  ),
                ),
/*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('By continuing, you agree to our ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14,)),
                    Text('Terms of Use ',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Constant.bgOrangeLite,
                          color: Constant.bgOrangeLite,
                          fontWeight: FontWeight.bold, fontSize: 14,)),
                    Text('and',
                        style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14,)),
                  ],
                ),*/
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                  );
                },
                child: const Center(
                  child: Text('Privacy & Cookie Policy.',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Constant.bgOrangeLite,
                        color: Constant.bgOrangeLite,
                        fontWeight: FontWeight.bold, fontSize: 14,)),
                ),
              ),

              const SizedBox(height: 20,),

              // SizedBox(height: 20,)
            ],
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
              const Text("Don't have an account ",
                  style: TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 14,)),
              InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: const Text('Sign Up ',
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
