import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Screens/Login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Constant.bgOrangeLite
        )
    );
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset('assets/splash/Splash.svg', fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,),
          Positioned(
            // top: 150,
              bottom: 332,
              left: 40,
              right: 40,
              child: SvgPicture.asset('assets/splash/Welcome.svg',
                // height: MediaQuery.of(context).size.height-100,
                width: 311,
              )
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 162,
            child: Column(
              children: [
                Image.asset('assets/splash/Welcome.png', width: 200),
                // const Text('Welcome to', style: TextStyle(
                //     fontFamily: 'Roboto', color: Colors.white,
                //     fontSize: 36, fontWeight: FontWeight.w700),),
                const SizedBox(height: 53,),
                Image.asset('assets/splash/nexa.png', width: 190, height: 47,)
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 37.0),
                child: InkWell(
                  onTap: () async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    pref.setBool('welcome', true);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                    // Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: Login()));

                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white
                    ),
                    child: const Center(child: Text('Get Started',
                      style: TextStyle(color: Constant.bgOrange,
                          fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Roboto'),)),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
