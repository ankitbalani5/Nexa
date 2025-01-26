
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/HomeBloc/home_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Model/CategoryModel.dart' as category;
import 'package:nexa/Model/HomeModel.dart';
import 'package:nexa/NavBar.dart';
import 'package:nexa/Screens/BottomScreens/home/AllProducts.dart';
import 'package:nexa/Screens/BottomScreens/home/ProductDetails.dart' as product;
import 'package:nexa/Screens/BottomScreens/home/Sort.dart';
import 'package:nexa/Screens/ProfileScreens/NotificationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Api.dart';
import '../../../Bloc/BrandBloc/brand_bloc.dart';
import '../../../Bloc/CountdownBloc/countdown_bloc.dart';
import '../../../Bloc/SuggestionBloc/suggestion_bloc.dart';
import '../Category/CategoryScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static category.CategoryModel? categoryModel;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearch = false;
  var searchController = TextEditingController();

  int dotIndex = 0;
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    context.read<HomeBloc>().add(HomeRefreshEvent('', ''));
    context.read<BrandBloc>().add(BrandFetchEvent());
    // categoryFetch();
    fetchFcm();
    flashDeal();
    super.initState();
  }
  Timer? _timer;
  void flashDeal() async {
    HomeModel? homeModel = await Api.homeApi('', '');
    var time = homeModel?.flashDeals![0].endFlashDeal.toString();
    DateTime endTime = DateTime.parse(time!);

    // _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    //   final now = DateTime.now();
    //   final difference = a.difference(now);
    //
    //   if (difference.isNegative) {
    //     // Stop timer when countdown ends
    //     _timer?.cancel();
    //   } else {
    //     final hours = difference.inHours;
    //     final minutes = difference.inMinutes % 60;
    //     final seconds = difference.inSeconds % 60;
    //
    //     // Dispatch the countdown event to update UI
    //     context.read<CountdownBloc>().add(StartCountDown(hour: hours, min: minutes, sec: seconds.toString()));
    //   }
    // });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (endTime == null || endTime!.isBefore(DateTime.now())) {
        // Stop timer when countdown ends
        _timer?.cancel();
        return;
      }

      final hours = endTime!.hour;
      final minutes = endTime!.minute;
      final seconds = endTime!.second;

      // Dispatch the countdown event to update UI
      context.read<CountdownBloc>().add(
        StartCountDown(hour: hours, min: minutes, sec: seconds.toString()),
      );

      // Update the end time by subtracting one second
      endTime = endTime!.subtract(Duration(seconds: 1));
      print('endTime $endTime');
    });
  }


  // flashDeal() async{
  //   HomeModel? homeModel = await Api.homeApi('', '');
  //   var time = homeModel?.flashDeals![0].endFlashDeal.toString();
  //   DateTime a = DateTime.parse(time!);
  //   var sec = a.second-1;
  //   Timer(Duration(seconds: 1), () {
  //     sec = sec-1;
  //     print('sec $sec');
  //   context.read<CountdownBloc>().add(StartCountDown(hour: a.hour, min: a.minute, sec: sec.toString()));
  //   },);
  // }

  fetchFcm() async{
    Constant.fcmToken = await FirebaseMessaging.instance.getToken();
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('fcmToken', Constant.fcmToken);
    print("FCM Token: ${Constant.fcmToken}");
  }

  // categoryFetch() async {
  //   HomeScreen.categoryModel = await Api.categoryApi('');
  // }

  @override
  Widget build(BuildContext context) {
    print('build');
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: Colors.white, // status bar color
        ));
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Builder(builder: (context) {
              return Image.asset('assets/home/nexa.png',/* height: 40, width: 40,*/);
            },)

        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                },
                child: Image.asset('assets/home/notification.png', height: 40, width: 40,)),
          )
        ],
      ),
      // drawer: Drawer(
      //   width: MediaQuery.of(context).size.width/1.5,
      //   shadowColor: Colors.transparent.withOpacity(.2),
      //   surfaceTintColor: Colors.transparent.withOpacity(.2),
      //
      //   // Define your drawer contents here
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 20.0, ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const SizedBox(height: 60,),
      //             Builder(builder: (context) {
      //               return
      //                 GestureDetector(
      //                     onTap: (){
      //                       Scaffold.of(context).closeDrawer();
      //                     },
      //                     child: Image.asset('assets/home/close.png', height: 40, width: 40,));
      //             },),
      //             const SizedBox(height: 20,),
      //             ClipRRect(
      //               borderRadius: BorderRadius.circular(30),
      //               child: Image.asset('assets/home/profile.png', height: 70, width: 70,),
      //             ),
      //             const SizedBox(height: 30,),
      //             const Text('John Due', style: TextStyle(fontWeight: FontWeight.w700,
      //             fontSize: 22),),
      //             const Text('examplejohn@gmail.com', style: TextStyle(fontWeight: FontWeight.w400,
      //                 fontSize: 14, color: Constant.bgGrey) ),
      //           ],
      //         ),
      //       ),
      //
      //       const SizedBox(height: 20,),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/home.svg'),
      //         title: const Text('Home'),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/profile.svg'/*, color: Constant.bgOrangeLite*/,),
      //         title: const Text('Profile'),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/notification.svg', width: 20,/*, color: Constant.bgOrangeLite,*/),
      //         title: const Text('Notification'),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/cart.svg'/*, color: Constant.bgOrangeLite*/,),
      //         title: const Text('Cart'),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/privacypolicy.svg'),
      //         title: const Text('Privacy Policy'),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/help.svg'),
      //         title: const Text('Help'),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/termcondition.svg'),
      //         title: const Text('Terms And Condition'),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //       ListTile(
      //         leading: SvgPicture.asset('assets/drawer/Logout.svg'),
      //         title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w700,
      //         fontSize: 15, color: Constant.bgOrange),),
      //         onTap: () {
      //           // Handle the tap
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: RefreshIndicator(
        color: Constant.bgOrange,
        onRefresh: () async{
          context.read<HomeBloc>().add(HomeLogoutEvent());
          context.read<HomeBloc>().add(HomeRefreshEvent('', ''));
          context.read<BrandBloc>().add(BrandFetchEvent());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              // Add logic here to avoid rebuilds unless necessary
              return current is HomeSuccess; // Example: Only rebuild if HomeBloc updates specific parts
            },
            builder: (context, state) {
              if(state is HomeLoading){
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Constant.bgOrangeLite,
                    size: 40,
                  ),);
              }
              if(state is HomeSuccess){
                print('home bloc');
                var homeData = state.homeModel;

                return ListView(
                    controller: listScrollController,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 15,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                controller: searchController,
                                cursorColor: Constant.bgOrangeLite,
                                onChanged: (value) {
                                  context.read<SuggestionBloc>().add(SuggestionLoadEvent(value.toString()));
                                  if(searchController.text.isNotEmpty){
                                    isSearch = true;
                                  }else{
                                    isSearch = false;
                                  }
                                  setState(() {

                                  });
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    hintText: 'Search',
                                    filled: true,
                                    hintStyle: TextStyle(color: Color(0xff929292)),
                                    fillColor: Constant.bgBtnGrey,
                                    suffixIcon: SvgPicture.asset('assets/home/search.svg', height: 50,),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                              // const SizedBox(height: 25,),
                          Stack(
                            children: [
                              // banner
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, top: 25, bottom: 20),
                                child: ClipRRect(
                                  // borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*1.2,
                                    height: 170,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: -MediaQuery.of(context).size.width*.15,
                                          child: Container(
                                            // padding: EdgeInsets.symmetric(horizontal: 10),
                                            height: 144,
                                            width: MediaQuery.of(context).size.width*1.4,
                                            child: CarouselSlider(
                                              items: homeData.homeBanner?.map((e) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(12),
                                                    child: CachedNetworkImage(
                                                      imageUrl: e.image.toString(),
                                                      placeholder: (context, url) => Shimmer.fromColors(
                                                        baseColor: Colors.grey[300]!,
                                                        highlightColor: Colors.grey[100]!,
                                                        child: Container(
                                                          // width: 60,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      fit: BoxFit.fill,),
                                                  ),
                                                );
                                              }).toList(),
                                              options: CarouselOptions(
                                                height: 144,
                                                aspectRatio: 16/9,
                                                viewportFraction: 0.60,
                                                initialPage: 0,
                                                enableInfiniteScroll: true,
                                                // reverse: false,
                                                autoPlay: true,
                                                autoPlayInterval: const Duration(seconds: 3),
                                                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                                autoPlayCurve: Curves.fastOutSlowIn,
                                                enlargeCenterPage: false,
                                                enlargeFactor: 0.3,
                                                // onPageChanged: callbackFunction,
                                                scrollDirection: Axis.horizontal,
                                                onPageChanged: (index, reason) {
                                                  dotIndex = index;
                                                  setState(() {

                                                  });
                                                },
                                              ),

                                            ),
                                          ),
                                        ),

                                        Positioned(
                                            bottom: 7,
                                            right: 20,
                                            left: 0,
                                            child: DotsIndicator(
                                              dotsCount: homeData.homeBanner!.map((e) => e.image).length,
                                              position: dotIndex,
                                              decorator: DotsDecorator(
                                                spacing: const EdgeInsets.all(2),
                                                size: const Size.square(6.0),
                                                activeSize: const Size(6.0, 6.0),
                                                activeColor: Constant.bgOrange,
                                                color: Constant.bgOrange.withOpacity(.30),
                                                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // search suggestion
                              Positioned(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                    child: isSearch == false ? SizedBox() : BlocBuilder<SuggestionBloc, SuggestionState>(
                                        builder: (context, state) {
                                          // if(state is SuggestionLoading){
                                          //   return Center(
                                          //       child: CircularProgressIndicator(color: Constant.bgOrangeLite,)
                                          //   );
                                          // }
                                          if(state is SuggestionSuccess){
                                            return state.suggestionModel.suggestions!.isEmpty ? SizedBox() : Container(
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                height: state.suggestionModel.suggestions?.length == 1 ? 60 : state.suggestionModel.suggestions?.length == 2 ? 100 : 150,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(blurRadius: 10, offset: Offset(0, .1))
                                                    ]
                                                ),
                                                child: ListView.builder(
                                                  itemCount: state.suggestionModel.suggestions?.length,
                                                  itemBuilder: (context, index) {
                                                    var data = state.suggestionModel.suggestions![index];
                                                    return GestureDetector(
                                                      onTap: () {
                                                        searchController.clear();
                                                        isSearch = false;
                                                        setState(() {

                                                        });
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => product.ProductDetails('home', data.id.toString())));
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                                                            child: Text(data.name.toString()),
                                                          ),
                                                          index+1 == state.suggestionModel.suggestions?.length ? SizedBox() : Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
                                                            child: Divider(color: Colors.grey.shade300, thickness: 1,),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },));
                                          }
                                          if(state is SuggestionError){
                                            return Text(state.error);
                                          }
                                          return SizedBox();
                                        },
                                      ),
                                    ),
                                  )

                              // const SizedBox(height: 20,),
                            ],
                          ),
                          // const Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text('Categories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                          //     Text('See all', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Constant.bgOrangeLite)),
                          //
                          //   ],
                          // ),
                          // const SizedBox(height: 20,),
                          BlocBuilder<CountdownBloc, CountdownState>(
                            builder: (context, state) {
                              if(state is CountdownSuccess){
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Constant.bgTextField
                                        ),
                                        child: Center(
                                          child: Text(state.hour.toString(), style: TextStyle(color: Constant.bgTextfieldHint),),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Constant.bgTextField
                                        ),
                                        child: Center(
                                          child: Text(state.min.toString(), style: TextStyle(color: Constant.bgTextfieldHint)),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Constant.bgTextField
                                        ),
                                        child: Center(
                                          child: Text(state.sec.toString(), style: TextStyle(color: Constant.bgTextfieldHint)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              height: 110,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: homeData.categories?.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 80,
                                    // color: Colors.red,
                                    margin: const EdgeInsets.only(right: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        InkWell(   onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NavBar(i: 1, selectedIndex: index),
                                            ),
                                          );

                                        },
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            child: CachedNetworkImage(
                                              imageUrl: homeData.categories![index].image.toString(),
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: Container(
                                                  // height: 160,
                                                  // width: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                              imageBuilder: (context, imageProvider) => Container(
                                                width: 90.0,
                                                height: 90.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: imageProvider, fit: BoxFit.cover),
                                                ),
                                              ),
                                              // placeholder: (context, url) => CircularProgressIndicator(),
                                              errorWidget: (context, url, error) => Icon(Icons.error),

                                            ),
                                          ),
                                        ),
                                        // Image.asset(categoryItem[index]['image'], width: 100,),
                                        const SizedBox(height: 10,),
                                        Text(homeData.categories![index].categoryName.toString(),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.bold,
                                              fontSize: 12),)
                                      ],
                                    ),
                                  );
                                },),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AllProduct(brandListSend: [], discountListSend: [], maxPrice: '', minPrice: '', priceListSend: [], ratingListSend: [],)));
                                    },
                                    child: Text('See all', style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: Constant.bgOrange,
                                      decorationThickness: 2,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, color: Constant.bgOrange, ))),

                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, crossAxisSpacing: 15,
                                mainAxisExtent: 240, mainAxisSpacing: 10, ),
                              itemCount: homeData.products?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => product.ProductDetails('home', homeData.products![index].id.toString())));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(

                                                borderRadius: BorderRadius.circular(12),
                                                child: Container(
                                                  height: 160,
                                                  // width: 160,
                                                  child: CachedNetworkImage(
                                                    imageUrl: homeData.products![index].featureImage.toString(),

                                                    placeholder: (context, url) => Shimmer.fromColors(
                                                      baseColor: Colors.grey[300]!,
                                                      highlightColor: Colors.grey[100]!,
                                                      child: Container(
                                                        // height: 160,
                                                        // width: 60,
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),

                                                )
                                              // child: Image.asset(homeData.products![index].featureImage.toString(), height: 180, width: 180,)
                                            ),
                                            Positioned(
                                                top: 10,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: homeData.products![index].loading == true
                                                      ? (){}
                                                      : (){
                                                    context.read<HomeBloc>().add(AddHomeWishlistEvent(homeData.products![index]));
                                                    // context.read<AddWishlistBloc>().add(AddWishlistRefreshEvent(homeData.products![index].id.toString()));
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(30)
                                                    ),
                                                    child: homeData.products![index].loading == true
                                                        ? Center(
                                                        child: SizedBox(
                                                            height: 10,
                                                            width: 10,
                                                            child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,)))
                                                        : Icon(homeData.products![index].inWishlist == true
                                                        ? Icons.favorite_outlined
                                                        : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(homeData.products![index].productName.toString(), maxLines: 2, overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.bold
                                          ),),
                                        Row(
                                          children: [
                                            Text(/*homeData.products![index].productType == 'variable'
                                                ? homeData.products![index].productDetails!.salePrice == null
                                                    ? homeData.products![index].productDetails!.regularPrice.toString()
                                                    : homeData.products![index].productDetails!.salePrice.toString()
                                                : */homeData.products![index].salePrice == null
                                                ? '\$${homeData.products![index].regularPrice.toString()}'
                                                : '\$${homeData.products![index].salePrice.toString()}', style: const TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.bold, color: Constant.bgOrange
                                            ),),
                                            const SizedBox(width: 10,),
                                            Text('${homeData.products![index].soldOut.toString()} sold', style: TextStyle(
                                                fontSize: 10, fontWeight: FontWeight.w400,
                                                color: Constant.bgGrey
                                            )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },),
                          )
                        ],
                      ),]
                );
              }
              if(state is HomeError){
                return Center(
                  child: Text(state.error),
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 45,
        width: 45,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.white,
          onPressed: () {
            if (listScrollController.hasClients) {
              final position = listScrollController.position.minScrollExtent;
              listScrollController.animateTo(
                position,
                duration: Duration(seconds: 1),
                curve: Curves.easeOut,
              );
            }
          },
          isExtended: true,
          tooltip: "Scroll to Top",
          child: Icon(Icons.keyboard_arrow_up, color: Constant.bgOrangeLite,),
        ),
      ),
    );
  }
}
