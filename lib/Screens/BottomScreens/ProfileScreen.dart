import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Screens/ProfileScreens/AccountSetting.dart';
import 'package:nexa/Screens/ProfileScreens/CustomerSupport.dart';
import 'package:nexa/Screens/ProfileScreens/MyAccount.dart';
import 'package:nexa/Screens/ProfileScreens/Order/MyOrder.dart';
import 'package:nexa/Screens/ProfileScreens/NotificationScreen.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/ShippingAddress.dart';
import 'package:nexa/Screens/TawkTo.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    // fetchData();
    super.initState();
  }

  fetchData() async{
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 5,
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSetting()));
                },
                child: Image.asset('assets/profile/Settings.png', height: 25, width: 25,)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Tawkto()));
                },
                child: Image.asset('assets/profile/chat.png', height: 25, width: 25, )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(imageUrl: Constant.image, height: 100, width: 100, fit: BoxFit.fill,
        
                      placeholder: (context, url) => Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Text('${Constant.firstName.toString()} ${Constant.lastName}', style: const TextStyle(fontWeight: FontWeight.w700,
                      fontSize: 22),),
                  Text(Constant.email.toString(), style: const TextStyle(fontWeight: FontWeight.w400,
                      fontSize: 14, color: Constant.bgGrey) ),
                ],
              ),
            ),
        
            const SizedBox(height: 20,),
            // ListTile(
            //   leading: SvgPicture.asset('assets/drawer/home.svg'),
            //   title: Text('Home'),
            //   onTap: () {
            //     // Handle the tap
            //   },
            // ),
            ListTile(
              leading: Image.asset('assets/profile/my account.png', width: 40/*, color: Constant.bgOrangeLite*/,),
              title: const Text('My Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyAccount(
                  Constant.firstName.toString(),
                  Constant.lastName.toString(),
                  Constant.country.toString(),
                  Constant.countryCode.toString(),
                  Constant.email.toString(),
                  Constant.phone.toString(),
                  Constant.image.toString(),
                )));
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
            ),
            ListTile(
              leading: Image.asset('assets/profile/notifications.png', width: 40,/*, color: Constant.bgOrangeLite,*/),
              title: const Text('Notification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
            ),
            ListTile(
              leading: Image.asset('assets/profile/address.png', width: 40/*, color: Constant.bgOrangeLite*/,),
              title: const Text('Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddress()));
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
            ),
            ListTile(
              leading: Image.asset('assets/profile/my order.png', width: 40),
              title: const Text('My Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrder()));
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
            ),
            ListTile(
              leading: Image.asset('assets/profile/customer support.png', width: 40),
              title: const Text('Customer support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerSupport()));
              },
              trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   surfaceTintColor: Colors.white,
      //   child: Btn('', height: 60, width: MediaQuery.of(context).size.width,
      //       linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2, name: 'Logout', callBack: (){}),
      // ),
    );
  }
}
