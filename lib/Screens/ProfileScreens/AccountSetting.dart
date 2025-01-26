import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexa/Bloc/AllWishlistBloc/all_wishlist_bloc.dart';
import 'package:nexa/Bloc/CategoryBloc/category_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Screens/Login.dart';
import 'package:nexa/SocialAuth.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:nexa/Widget/Btn2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Api.dart';
import '../../Bloc/CartProductsBloc/cart_products_bloc.dart';
import '../../Bloc/HomeBloc/home_bloc.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/profile/back.png', height: 30, width: 30,),
          ),
        ),
        title: const Text('Account Setting', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Image.asset('assets/profile/chat1.png', height: 30, width: 30,),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Text('My Account', style: TextStyle(color: Constant.bgGrey, fontSize: 14, fontWeight: FontWeight.w400),),
          ),
          ListTile(
            leading: Image.asset('assets/settings/payment_method.png', width: 40,/*, color: Constant.bgOrangeLite,*/),
            title: const Text('Payment Methods'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
          ListTile(
            leading: Image.asset('assets/settings/account_security.png', width: 40/*, color: Constant.bgOrangeLite*/,),
            title: const Text('Account & Security'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingAddress()));
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
          ListTile(
            leading: Image.asset('assets/settings/about.png', width: 40),
            title: const Text('About'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrder()));
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Text('Settings', style: TextStyle(color: Constant.bgGrey, fontSize: 14, fontWeight: FontWeight.w400),),
          ),
          ListTile(
            leading: Image.asset('assets/settings/chat.png', width: 40),
            title: const Text('Chat Settings'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrder()));
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
          ListTile(
            leading: Image.asset('assets/settings/notification.png', width: 40),
            title: const Text('Notification Settings'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrder()));
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
          ListTile(
            leading: Image.asset('assets/settings/privacy.png', width: 40),
            title: const Text('Privacy Settings'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrder()));
            },
            trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 140,
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Column(
          children: [
            Btn2(height: 50, width: MediaQuery.of(context).size.width,
                name: 'Switch Account', callBack: (){

                }),
            SizedBox(height: 10,),
            Btn('', height: 50, width: MediaQuery.of(context).size.width,
              linearColor1: Constant.bgLinearColor1,
              linearColor2: Constant.bgLinearColor2, name: 'Logout', callBack: () {
                Constant.customDialog(context, 'Logout',
                    'Are you sure you want to logout?',
                    'Cancel', 'Confirm', () async {
                      Constant.showDialogProgress(context);
                      Api.logoutApi(Constant.deviceToken).then((value) async {
                        if(value['status']  == 'success'){
                          Navigator.pop(context);
                          SocialAuth().signout();
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.clear();
                          context.read<CategoryBloc>().add(CategoryLogoutEvent());
                          context.read<HomeBloc>().add(HomeLogoutEvent());
                          context.read<AllWishlistBloc>().add(WishlistLogoutEvent());
                          context.read<CartProductsBloc>().add(CartLogoutEvent());
                          context.read<CategoryBloc>().add(CategoryLogoutEvent());
                          pref.setBool('welcome', true);
                          pref.setString('fcmToken', Constant.fcmToken);
                          var welcome = pref.getBool('welcome');

                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),
                                  (route) => false);
                        }else{
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: value['message'], backgroundColor: Constant.bgOrangeLite);
                        }
                      });

                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
