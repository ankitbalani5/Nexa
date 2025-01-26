import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nexa/Bloc/CountryBloc/country_bloc.dart';
import 'package:nexa/Screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Bloc/CreateOrUpdateProfileBloc/create_or_update_profile_bloc.dart';
import '../Constant.dart';
import '../Model/CountryModel.dart';
import '../Widget/Btn.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  var _formKey = GlobalKey<FormState>();
  String? selectedCountry;
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  void initState() {
    context.read<CountryBloc>().add(CountryRefreshEvent());
    super.initState();
  }
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
      //   leadingWidth: 5,
      //   // title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60,),
                const Center(
                    child: Column(
                      children: [
                        Text('Create Profile',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30)),
                        Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Constant.bgGrey),),
                      ],
                    )
                ),
                const SizedBox(height: 20,),
                const Text('First Name', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                TextFormField(
                  controller: firstNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  cursorColor: Constant.bgTextfieldHint,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      filled: true,
                      hintText: 'John',
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
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('Last Name', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                TextFormField(
                  controller: lastNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter last name';
                    }
                    return null;
                  },
                  cursorColor: Constant.bgTextfieldHint,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      filled: true,
                      hintText: 'Due',
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
                      )
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('Country', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                BlocConsumer<CountryBloc, CountryState>(
                  listener: (context, state) {
                    if(state is CountryLoading){
                      Constant.showDialogProgress(context);
                    }
                  },
                  builder: (context, state) {
                    if(state is CountrySuccess){
                      Navigator.pop(context);
                      return DropdownSearch<Country?>(
                        itemAsString: (item) => item!.name.toString(),
                        items: state.countryModel.country!,
                        popupProps: const PopupProps.menu(
                            showSearchBox: true
                        ),
                        onChanged: (value) {
                          selectedCountry = value!.name.toString();
                        },
                        validator: (item) {
                          if (item == null)
                            return "Required field";
                          else
                            return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              suffixIconColor: Constant.bgOrange,
                              filled: true,
                              fillColor: Constant.bgTextField,
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
                              hintText: 'United States',
                              hintStyle: const TextStyle(
                                  color: Constant.bgTextfieldHint
                              )
                          ),
                          baseStyle: const TextStyle(color: Constant.bgTextfieldHint, fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      );
                    }
                    return DropdownSearch<Country?>(
                      itemAsString: (item) => item!.name.toString(),
                      items: [],
                      popupProps: const PopupProps.menu(
                          showSearchBox: true
                      ),
                      onChanged: (value) {
                        selectedCountry = value!.name.toString();
                      },
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              suffixIconColor: Constant.bgOrange,
                              filled: true,
                              fillColor: Constant.bgTextField,
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
                              hintText: 'United States',
                              hintStyle: const TextStyle(
                                  color: Constant.bgTextfieldHint
                              )
                          ),
                          baseStyle: const TextStyle(color: Constant.bgTextfieldHint, fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20,),
                const Text('Email', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
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
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    filled: true,
                    hintText: 'examplejohn@gmail.com',
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

                  ),
                ),
                const SizedBox(height: 20,),
                const Text('Password', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                TextFormField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
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
                  //   if(value == null || value.isEmpty){
                  //     return 'Please enter password';
                  //   }
                  //   return null;
                  // },
                  cursorColor: Constant.bgTextfieldHint,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    filled: true,
                    hintText: 'Enter your password',
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

                  ),
                ),
                const SizedBox(height: 30,),
                BlocConsumer<CreateOrUpdateProfileBloc, CreateOrUpdateProfileState>(
                  listener: (context, state) async {
                    if(state is CreateOrUpdateProfileLoading){
                      Constant.showDialogProgress(context);
                    }
                    if(state is CreateOrUpdateProfileSuccess){
                      Navigator.pop(context);
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      // pref.setString('first_name', firstNameController.text.toString());
                      // pref.setString('last_name', lastNameController.text.toString());
                      // pref.setString('email', emailController.text.toString());
                      // pref.setString('country', selectedCountry.toString());
                      pref.setString('current_steps', 'step_2');
                      Fluttertoast.showToast(msg: state.createOrUpdateProfileModel.message.toString(), backgroundColor: Constant.bgOrangeLite);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);

                    }
                    if(state is CreateOrUpdateProfileError){
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: state.error, backgroundColor: Colors.red);
                    }

                  },
                  builder: (context, state) {
                    return Btn('', height: 50, width: MediaQuery.of(context).size.width,
                        linearColor1: Constant.bgLinearColor1,
                        linearColor2: Constant.bgLinearColor2,
                        name: 'Continue', callBack: (){
                      if(_formKey.currentState!.validate()){
                        context.read<CreateOrUpdateProfileBloc>().add(CreateOrUpdateProfileRefreshEvent(firstNameController.text, lastNameController.text,
                            selectedCountry.toString(), '', '', passwordController.text, null, emailController.text));
                        }
                      }
                        );
                  },
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
