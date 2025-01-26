
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:nexa/auth/Auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Bloc/CountryBloc/country_bloc.dart';
import '../../Bloc/CreateOrUpdateProfileBloc/create_or_update_profile_bloc.dart';
import '../../Bloc/ForgotPasswordBloc/forgot_password_bloc.dart';
import '../../Bloc/OtpVerifyEmailBloc/otp_verify_email_bloc.dart';
import '../../Bloc/OtpVerifyForgotPasswordBloc/otp_verify_forgot_password_bloc.dart';
import '../../Bloc/VerifyEmailBloc/verify_email_bloc.dart';
// import '../../Bloc/VerifyEmailBloc/verify_password_bloc.dart';
// import '../../Bloc/VerifyPasswordBloc/verify_password_bloc.dart';
import '../../Constant.dart';
import '../../Model/CountryModel.dart';
import '../../NavBar.dart';

class MyAccount extends StatefulWidget {
  String firstName;
  String lastName;
  String country;
  String countryCode;
  String email;
  String phone;
  String image;
  MyAccount(this.firstName, this.lastName, this.country, this.countryCode,
      this.email, this.phone, this.image, {super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var _formKey = GlobalKey<FormState>();
  File? _image;
  String? selectedCountry;
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var countryController = TextEditingController();
  var countryCodeController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var imageController = TextEditingController();
  bool verifyEmail = true;
  bool verifyPhone = false;
  bool phoneLoading = false;

  String _countryName = 'PH'; // Default country code
  String? _countryCode ; // Default country code

  @override
  void initState() {
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    countryController.text = widget.country;
    countryCodeController.text = widget.countryCode;
    print('country code ${widget.countryCode}');
    print('country name ${_countryName}');
    _countryCode = widget.countryCode;
    if(_countryCode == null || _countryCode == 'null'){
      _countryCode = '+93';
      print('country code ${_countryCode}');
    }
    emailController.text = widget.email;
    phoneController.text = widget.phone;
    if(widget.phone != null && widget.phone != 'null'){
      verifyPhone = true;
    }
    imageController.text = widget.image;
    selectedCountry = widget.country;
    _countryName = Constant.getCountryCodeFromName(widget.country);
    context.read<CountryBloc>().add(CountryRefreshEvent());
    super.initState();
  }


  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // .pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> handleImageSelection() async {
    await Constant.requestPermissions(); // Request permissions before selecting image

    final cameraStatus = await Permission.camera.status;
    final galleryStatus13 = await Permission.photos.status;
    final galleryStatus12 = await Permission.storage.status;
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if(sdkInt >= 33){
      if (cameraStatus.isGranted && galleryStatus13.isGranted) {
        showOptions();
      } else if (cameraStatus.isPermanentlyDenied || galleryStatus13.isPermanentlyDenied) {
        openAppSettings();
      } else if(cameraStatus.isDenied || galleryStatus13.isDenied){
        await Constant.requestPermissions();
      }
    }else{
      if (cameraStatus.isGranted && galleryStatus12.isGranted) {
        showOptions();
      } else if (cameraStatus.isPermanentlyDenied || galleryStatus12.isPermanentlyDenied) {
        openAppSettings();
      } else if(cameraStatus.isDenied || galleryStatus12.isDenied){
        await Constant.requestPermissions();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
        ),
        title: const Text('My Account', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15,),
                Center(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: /*CachedNetworkImage(imageUrl: imageController.text.toString(), height: 100, width: 100,),*/
                        _image != null
                            ? Image.file(
                          _image!,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.fill,
                        )
                            : CachedNetworkImage(
                          imageUrl: widget.image,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                              onTap: () async {
                                await handleImageSelection();
                                // Constant.cameraRequestPermissions();
                                // Constant.galleryRequestPermissions();
                                // final cameraStatus = await Permission.camera.status;
                                // final galleryStatus = await Permission.photos.status;
                                // if(cameraStatus.isGranted && galleryStatus.isGranted){
                                //   showOptions();
                                // }else if(cameraStatus.isPermanentlyDenied && galleryStatus.isPermanentlyDenied){
                                //   openAppSettings();
                                // }else{
                                //   print('camera status ::::::::::${cameraStatus}');
                                //   print('gallery status ::::::::::${galleryStatus}');
                                //
                                // }
                              },
                              child: Image.asset('assets/profile/camerapicker.png', height: 30, width: 30,)))
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('First Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                SizedBox(
                  // color: Colors.red,
                  // height: 60,
                  child: TextFormField(
                    controller: firstNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                    cursorColor: Constant.bgTextfieldHint,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please enter first name';
                      }
                      return null;
                    },
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
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                const Text('Last Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(
                  // color: Colors.red,
                  // height: 60,
                  child: TextFormField(
                    controller: lastNameController,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                    cursorColor: Constant.bgTextfieldHint,
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please enter last name';
                      }
                      return null;
                    },
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
                ),
                const SizedBox(height: 15,),
                const Text('Country', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                BlocBuilder<CountryBloc, CountryState>(
                  builder: (context, state) {
                    if(state is CountrySuccess){
                      return SizedBox(
                        // color: Colors.red,
                          height: 60,
                          child: DropdownSearch<Country?>(
                            selectedItem: _getSelectedCountry(selectedCountry, state.countryModel.country),
                            itemAsString: (item) => item!.name.toString(),
                            items: state.countryModel.country!,
                            popupProps: const PopupProps.menu(
                                showSearchBox: true
                            ),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                suffixIconColor: Constant.bgOrange,
                                filled: true,
                                fillColor: Constant.bgTextField,
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
                                ),
                              ),
                              baseStyle: const TextStyle(
                                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400 // Set the selected item text color to white
                              ),
                            ),
                          )
                        /*TextFormField(style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Enter mobile number',
                                      hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                      fillColor: Constant.bgTextField,
                                      // contentPadding: EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.transparent)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.transparent)
                                      )
                                  ),
                                ),*/
                      );
                    }
                    return SizedBox(
                      // color: Colors.red,
                        height: 60,
                        child: DropdownSearch(
                          selectedItem: countryController.text,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              suffixIconColor: Constant.bgOrange,
                              filled: true,
                              fillColor: Constant.bgTextField,
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
                              ),
                            ),
                            baseStyle: const TextStyle(
                              color: Constant.bgTextfieldHint, fontSize: 16, fontWeight: FontWeight.w400 // Set the selected item text color to white
                            ),
                          ),
                        )
                      /*TextFormField(style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Enter mobile number',
                                      hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                                      fillColor: Constant.bgTextField,
                                      // contentPadding: EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.transparent)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Colors.transparent)
                                      )
                                  ),
                                ),*/
                    );
                  },
                ),
                const SizedBox(height: 15,),
                const Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(
                  // color: Colors.red,
                  // height: 60,
                  child: TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                    cursorColor: Constant.bgTextfieldHint,
                    onChanged: (value) {
                      verifyEmail = false;
                      setState(() {

                      });
                    },
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please enter email';
                      }
                      if(verifyEmail != true){
                        return 'Please verify email';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      filled: true,
                      hintText: 'examplejohn@gmail.com',
                      hintStyle: const TextStyle(color: Constant.bgTextfieldHint, fontSize: 16, fontWeight: FontWeight.w400),
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
                      suffixIcon: BlocConsumer<VerifyEmailBloc, VerifyEmailState>(
                          listener: (context, state) {
                            if(state is VerifyEmailSuccess){
                              Fluttertoast.showToast(msg: state.verifyEmailModel.message.toString(), backgroundColor: Constant.bgOrangeLite);
                              verifyDialog(context, emailController.text , '', '');
                            }
                            if(state is VerifyEmailError){
                              Fluttertoast.showToast(msg: state.error.toString(), backgroundColor: Colors.red);
                            }
                          },
                          builder: (BuildContext context, VerifyEmailState state) {
                            return TextButton(
                              onPressed: () {
                                // context.read<ForgotPasswordBloc>().add(ForgotPasswordRefreshEvent(emailController.text));
                                context.read<VerifyEmailBloc>().add(VerifyEmailNewEvent(emailController.text));

                                // Verify button action
                              },
                              child: state is VerifyEmailLoading ? SizedBox(height: 18, width: 18,
                                  child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 2,)) :
                              verifyEmail == true
                                  ? Icon(Icons.check, color: Colors.green,)
                                  : const Text('Verify', style: TextStyle(color: Constant.bgOrange)),
                            );
                          },
                        ),
                      /*suffixIcon: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Verify', style: TextStyle(color: Constant.bgOrange),),
                          ),
                        ],
                      )*/
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                // SizedBox(
                //   // color: Colors.red,
                //   // height: 60,
                //   child: Theme(
                //     data: ThemeData(
                //       inputDecorationTheme: const InputDecorationTheme(
                //         border: OutlineInputBorder(),
                //       ),
                //
                //       primaryColor: Colors.green, // Sets the primary color
                //       hintColor: Colors.green, // Sets the accent color
                //     ),
                //     child: IntlPhoneField(
                //       controller: phoneController,
                //       style: TextStyle(color: Constant.bgTextfieldHint),
                //       decoration: InputDecoration(
                //         counter: const SizedBox(),
                //         // labelText: 'Phone Number',counterText: '',
                //         suffixIcon: TextButton(
                //           onPressed: () {
                //             // Verify button action
                //           },
                //           child: const Text('Verify', style: TextStyle(color: Constant.bgOrange)),
                //         ),
                //         filled: true,
                //         fillColor: Constant.bgTextField,
                //         hintText: '123123',
                //         hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                //         // border: OutlineInputBorder(
                //         //   borderSide: BorderSide(),
                //         // ),
                //         enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(12),
                //           borderSide: const BorderSide(
                //             color: Colors.transparent,
                //           )
                //         )
                //       ),
                //       initialCountryCode: countryCodeController.text.toString(), // Default country
                //       // style: TextStyle(color: Colors.red), // Change the color of the input text including the country code
                //       dropdownTextStyle: const TextStyle(color: Colors.white),
                //       onChanged: (phone) {
                //         if (kDebugMode) {
                //           print(phone.completeNumber);
                //         } // Output the complete phone number
                //       },
                //     ),
                //   ),

                TextFormField(
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                  cursorColor: Constant.bgTextfieldHint,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    verifyPhone = false;
                    setState(() {

                    });
                  },
                  validator: (value) {
                    print('cccccCCCCC $_countryCode');
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    if (!Constant.validatePhoneNumberFromCode(value, _countryCode!)) {
                      return 'Invalid phone number for ${_countryCode}';
                    }
                    return null; // Validation passed
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      filled: true,
                      hintText: 'Enter mobile number',
                      hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
                      fillColor: Constant.bgTextField,
                      // contentPadding: EdgeInsets.all(10),
                      prefixIcon: CountryCodePicker(
                        padding: EdgeInsets.zero,
                        onChanged: (country) {

                          setState(() {
                            _countryCode = country.dialCode!;
                          });
                        },
                        initialSelection: _countryCode,
                        showFlag: true,
                        textStyle: TextStyle(color: Constant.bgTextfieldHint),
                      ),
                      suffixIcon: TextButton(
                        onPressed: () {
                          phoneLoading = true;
                          setState(() {

                          });
                          // Verify button action
                          firebaseOtpVerify(_countryCode.toString(), phoneController.text, context);
                        },
                        child: phoneLoading == true ? SizedBox(height: 18, width: 18,
                            child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 2,)) :
                        verifyPhone == true
                            ? Icon(Icons.check, color: Colors.green,)
                            : Text('Verify', style: TextStyle(color: Constant.bgOrange)),
                      ),

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
                // ),
                const SizedBox(height: 30,),
                BlocConsumer<CreateOrUpdateProfileBloc, CreateOrUpdateProfileState>(
                  listener: (context, state) async {
                    if(state is CreateOrUpdateProfileLoading){
                      Constant.showDialogProgress(context);
                    }
                    if(state is CreateOrUpdateProfileSuccess){
                      Navigator.pop(context);
                      final response = await Api.getProfileApi();
                      SharedPreferences pref = await SharedPreferences.getInstance();
                      pref.setString('first_name',response!.profile!.firstName.toString());
                      pref.setString('last_name', response.profile!.lastName.toString());
                      pref.setString('email', response.profile!.email.toString());
                      pref.setString('country', response.profile!.country.toString());
                      pref.setString('country_code', response.profile!.countryCode.toString());
                      pref.setString('phone', response.profile!.phone.toString());
                      pref.setString('image', response.profile!.image.toString());
                      Constant.token = pref.getString('token');
                      Constant.firstName = pref.getString('first_name');
                      Constant.lastName = pref.getString('last_name');
                      Constant.email = pref.getString('email');
                      Constant.country = pref.getString('country');
                      Constant.countryCode = pref.getString('country_code');
                      Constant.phone = pref.getString('phone');
                      Constant.image = pref.getString('image');
                      FocusScope.of(context).unfocus();
                      Fluttertoast.showToast(msg: state.createOrUpdateProfileModel.message.toString(), backgroundColor: Constant.bgOrangeLite);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NavBar(i: 4,)));
                    }
                    if(state is CreateOrUpdateProfileError){
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: state.error.toString(), backgroundColor: Colors.red);

                    }
                  },
                  builder: (context, state) {
                    return Btn('', height: 50, width: MediaQuery.of(context).size.width,
                        linearColor1: Constant.bgLinearColor1,
                        linearColor2: Constant.bgLinearColor2,
                        name: 'Save', callBack: (){
                          print('${_countryCode} ${phoneController.text}');
                          if(_formKey.currentState!.validate()){
                            FocusScope.of(context).unfocus();
                            if(verifyEmail == true){
                              context.read<CreateOrUpdateProfileBloc>().add(CreateOrUpdateProfileRefreshEvent(
                                  firstNameController.text, lastNameController.text,
                                  selectedCountry.toString(), _countryCode.toString(),
                                  phoneController.text, '', _image, emailController.text)
                              );
                            }


                          }
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyDialog(BuildContext context, String email, String path , String verificationId) {
    TextEditingController pinController = TextEditingController();
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 46,
      textStyle: const TextStyle(
          fontSize: 22,
          // color: Color.fromRGBO(30, 60, 87, 1),
          color: Constant.bgOrangeLite
      ),
      decoration: BoxDecoration(
        color: Constant.bgTextField,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: borderColor),
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the dialog compact
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel))
                  ],
                ),
                const Text(
                  "Verify It's you",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "We've sent OTP to",
                  style: TextStyle(fontSize: 14, color: Constant.bgGrey, fontWeight: FontWeight.w400),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Pinput(
                  length: 6, // Number of digits in the OTP
                  defaultPinTheme: defaultPinTheme,
                  controller: pinController,
                  onChanged: (value) {
                    // Add logic here when OTP is entered
                  },
                ),
                const SizedBox(height: 20),
                BlocConsumer<OtpVerifyEmailBloc, OtpVerifyEmailState>(
                  listener: (context, state) {
                    if(state is OtpVerifyEmailSuccess){
                      Navigator.pop(context);
                      pinController.clear();
                      Fluttertoast.showToast(msg: state.emailOtpVerifyModel.message.toString(), backgroundColor: Constant.bgOrangeLite);
                      verifyEmail = true;
                      setState(() {

                      });
                    }
                    if(state is OtpVerifyEmailError){
                      Fluttertoast.showToast(msg: state.error.toString(), backgroundColor: Colors.red);
                    }
                  },
                  builder: (context, state) {
                    return Btn('', height: 50, width: MediaQuery.of(context).size.width,
                                  linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                                  name: 'Verify Otp', callBack: () {
                      if(path == 'phone'){
                        _verifyOTP(path, pinController.text, verificationId);
                      }else{
                        context.read<OtpVerifyEmailBloc>().add(OtpVerifyNewEvent(email, pinController.text));

                      }

                      },);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Country? _getSelectedCountry(String? countryName, List<Country>? countries) {
    if (countryName == null || countries == null) return null;
    return countries.firstWhere(
          (country) => country.name == countryName,
      orElse: () => Country(name: '', id: ''),
    );
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future<void> firebaseOtpVerify(String countryCode, String phoneNumber, BuildContext context) async {
    String formattedPhoneNumber = '$countryCode$phoneNumber';
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: '${countryCode} ${phoneNumber}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {

        phoneLoading = false;
        setState(() {

        });
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The provided phone number is not valid.')),
          );
        } else {
          print('Verification failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        }
      },
      // resend use only android not ios
      codeSent: (String verificationId, int? resendToken) {
        Constant.resendToken = resendToken;
        phoneLoading = false;
        setState(() {

        });
        verifyDialog(context, phoneNumber, 'phone', verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Constant.resendToken = '';
        print('resendToken ::::::::${Constant.resendToken}');
      },
    );
  }

  void _verifyOTP(String path, String otp, String verificationId) async {
    if (_formKey.currentState!.validate()) {
      // setState(() {
      //   _isLoading = true;
      // });

      String smsCode = otp.trim();

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        // setState(() {
        //   _isLoading = false;
        // });

        if(path == 'phone'){
          verifyPhone = true;
          setState(() {

          });
          Navigator.pop(context);
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

}
