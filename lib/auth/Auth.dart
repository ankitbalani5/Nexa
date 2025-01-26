import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';
import '../Screens/OtpScreen.dart';

class Auth{

  static Future<void> firebaseOtpVerify(String path, String countryCode, String phoneNumber, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: '${countryCode} ${phoneNumber}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {

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

        // if (e.code == 'invalid-phone-number') {
        //   print('The provided phone number is not valid.');
        // }
      },
      // resend use only android not ios
      codeSent: (String verificationId, int? resendToken) {
        Constant.resendToken = resendToken;
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(path, phoneNumber.toString(), countryCode, verificationId: verificationId)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Constant.resendToken = '';
        print('resendToken ::::::::${Constant.resendToken}');
      },
    );
  }
}