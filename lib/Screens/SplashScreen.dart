import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Screens/CreateProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../NavBar.dart';
import 'Login.dart';
import 'WelcomeScreen.dart';

class SplashScreen extends StatefulWidget {
  var uriPath;
  var _navigatorKey;
  SplashScreen(this.uriPath, this._navigatorKey,{super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var welcome = pref.getBool('welcome');
      var login = pref.getBool('login');
      var current_steps = pref.getString('current_steps');
      var token = pref.getString('token');
      var deepLink = pref.getBool('deepLink');
      print('token $token');
      // await Constant.requestPermissions();

        print('PPPPPPTTTTTTTTPPPPPPPPPPPPPP${widget.uriPath}');
        if(deepLink == true){
            return null;
        }
      else/*(widget.uriPath == null)*/{
        print('PPPPPPPPPPPPPPPPPPPP${widget.uriPath}');
        print('::::::::::::::::::::::::::::::::::::::::DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (mycontext) =>
        welcome == null || welcome == false
            ? WelcomeScreen()
            : current_steps
            == 'step_1' ? CreateProfile() : current_steps == 'step_2' ? NavBar()
            : Login()
        ));

      }
    });
    _getDeviceUniqueId();
    super.initState();
  }

  // Function to get the device unique ID
  Future<void> _getDeviceUniqueId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceUniqueId;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceUniqueId = androidInfo.id;  // This is the Android device ID
      print('android::::$deviceUniqueId');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceUniqueId = iosInfo.identifierForVendor;  // Unique ID for iOS
      print('ios::::$deviceUniqueId');
    }

    setState(() {
      Constant.deviceToken = deviceUniqueId;
    });

    // You can use the device ID for your specific purposes, such as saving it or sending it to your server.
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Constant.bgOrange
        )
    );
    return Scaffold(
      body: /*Image.asset('assets/splash/Splash.png',
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width,)*/
      Stack(
          children: [
            SvgPicture.asset('assets/splash/Splash.svg', fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,),
            Positioned(
                top: 0,
                bottom: 0,
                left: 60,
                right: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Image.asset('assets/splash/nexa.png', width: 190, height: 50,),
                )
            )
          ]
      ),
    );
  }
}
