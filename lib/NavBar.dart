import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Bloc/CartProductsBloc/cart_products_bloc.dart';
import 'Bloc/CategoryWiseProduct/category_wise_product_bloc.dart';
import 'Constant.dart';
import 'Screens/BottomScreens/Cart/CartScreen.dart';
// import 'Screens/BottomScreens/Category/CategoryScreen.dart';
import 'Screens/BottomScreens/Category/CategoryScreenNew.dart';
import 'Screens/BottomScreens/home/HomeScreen.dart';
import 'Screens/BottomScreens/ProfileScreen.dart';
import 'Screens/BottomScreens/WishlistScreen.dart';

class NavBar extends StatefulWidget {
  int i;
  int selectedIndex ;
  NavBar( {this.i = 0 , this.selectedIndex = 0, super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  DateTime? currentBackPressTime;
  List Screens = [];



  @override
  void initState() {
    _currentIndex = widget.i ;
    Screens =  [
      HomeScreen(),
      CategoryScreen(selectedIndex: widget.selectedIndex),
      // CategoryScreen(selectedIndex: widget.selectedIndex),
      WishlistScreen(),
      CartScreen(),
      ProfileScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
        body: WillPopScope(
          onWillPop: _currentIndex != 0
              ? (){
            _currentIndex = 0;

            context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
            context.read<CartProductsBloc>().add(CartLogoutEvent());
            setState(() {

            });
            return Future.value(false);
          }
              : (){
            DateTime now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
              currentBackPressTime = now;
              Fluttertoast.showToast(
                  msg: "Press again to exit",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Constant.bgOrangeLite,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              // Fluttertoast.showToast(msg: 'Press again to exit');
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Press again to exit')));
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Screens[_currentIndex],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 0),
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            height: 72,
            // elevation: 10,
            // shadowColor: Colors.grey,
            surfaceTintColor: Colors.white,
            child: Material(
              elevation: 20,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),

              child: Container(
                height: 68,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                        setState(() {
                          _currentIndex = 0;
                        });
                        context.read<CartProductsBloc>().add(CartLogoutEvent());
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white
                        ),
                        // padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            Image.asset('assets/navbar/home.png', height: 20, width: 20, color: _currentIndex == 0 ? Constant.bgOrange : Constant.bgGrey, ),
                            const SizedBox(height: 5,),
                            Text('Home', style: TextStyle(fontWeight: _currentIndex == 0 ? FontWeight.bold : FontWeight.w400 ,fontSize: 10 ,color: _currentIndex == 0 ? Constant.bgOrange : Constant.bgGrey),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_currentIndex != 1){
                          context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                          setState(() {
                            _currentIndex = 1;
                            Screens[1] = CategoryScreen(selectedIndex: 0,);
                          });
                          context.read<CartProductsBloc>().add(CartLogoutEvent());
                          print('current i : $_currentIndex');
                        }
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white
                        ),
                        // padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Image.asset('assets/navbar/category.png', height: 20, width: 20, color: _currentIndex == 1 ? Constant.bgOrange : Constant.bgGrey),
                            SizedBox(height: 5,),
                            Text('Category', style: TextStyle(fontWeight: _currentIndex == 1 ? FontWeight.bold : FontWeight.w400 ,fontSize: 10 ,color: _currentIndex == 1 ? Constant.bgOrange : Constant.bgGrey),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                        setState(() {
                          _currentIndex = 2;
                        });
                        context.read<CartProductsBloc>().add(CartLogoutEvent());
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white
                        ),
                        // padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Image.asset('assets/navbar/wishlist.png', height: 20, width: 20, color: _currentIndex == 2 ? Constant.bgOrange : Constant.bgGrey),
                            SizedBox(height: 5,),
                            Text('Wishlist', style: TextStyle(fontWeight: _currentIndex == 2 ? FontWeight.bold : FontWeight.w400 ,fontSize: 10 ,color: _currentIndex == 2 ? Constant.bgOrange : Constant.bgGrey),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_currentIndex != 3){

                            context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                            setState(() {
                              _currentIndex = 3;
                            });
                            context.read<CartProductsBloc>().add(CartLogoutEvent());
                        }
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white
                        ),
                        // padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            Image.asset('assets/navbar/cart.png', height: 20, width: 20, color: _currentIndex == 3 ? Constant.bgOrange : Constant.bgGrey),
                            const SizedBox(height: 5,),
                            Text('Cart', style: TextStyle(fontWeight: _currentIndex == 3 ? FontWeight.bold : FontWeight.w400 ,fontSize: 10 ,color: _currentIndex == 3 ? Constant.bgOrange : Constant.bgGrey),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                        setState(() {
                          _currentIndex = 4;
                        });
                        context.read<CartProductsBloc>().add(CartLogoutEvent());
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        // padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Image.asset('assets/navbar/profile.png', height: 20, width: 20, color: _currentIndex == 4 ? Constant.bgOrange : Constant.bgGrey),
                            SizedBox(height: 5,),
                            Text('Profile', style: TextStyle(fontWeight: _currentIndex == 4 ? FontWeight.bold : FontWeight.w400,fontSize: 10 ,color: _currentIndex == 4 ? Constant.bgOrange : Constant.bgGrey),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
