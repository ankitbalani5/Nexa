// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:nexa/Api.dart';
// import 'package:nexa/Bloc/CategoryBloc/category_bloc.dart';
// import 'package:nexa/Model/CategoryModel.dart';
// import 'package:nexa/Screens/BottomScreens/Category/CategoryProducts.dart';
// import 'package:nexa/Screens/BottomScreens/home/HomeScreen.dart';
// import 'package:nexa/Widget/TextStyles.dart';
// import 'package:nexa/Model/CategoryModel.dart' as category;
// import 'package:nexa/Screens/BottomScreens/home/ProductDetails.dart' as product;
//
// import '../../../Constant.dart';
//
// class CategoryScreen extends StatefulWidget {
//   final int selectedIndex; // Add this parameter
//
//   const CategoryScreen({Key? key, this.selectedIndex = 0}) : super(key: key);
//
//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }
//
// class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
//   TabController? _tabController;
//   bool loading = true;
//   List<Products>? myproducts;
//
//   ScrollController listScrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   fetchData() async {
//     final res = await Api.categoryApi(/*''*/).then((v) {
//       if (v!.status == 'success') {
//         _tabController = TabController(length: v.categories!.length, vsync: this);
//         _tabController?.addListener(_tabData);
//         _tabController?.index = widget.selectedIndex; // Set the tab index here
//         context.read<CategoryBloc>().add(CategoryRefreshEvent(''));
//         loading = false;
//         setState(() {});
//       }
//     });
//   }
//
//   _tabData() {
//     myproducts = null;
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _tabController?.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: SizedBox(),
//         leadingWidth: 5,
//         title: Text('Categories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28)),
//
//       ),
//       body: loading == true
//           ? const Center(
//         child: CircularProgressIndicator(color: Constant.bgOrangeLite),
//       )
//           : Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: BlocBuilder<CategoryBloc, CategoryState>(
//           builder: (context, state) {
//             if (state is CategoryLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(color: Constant.bgOrangeLite),
//               );
//             }
//             if (state is CategorySuccess) {
//               var categoryData = state.categoryModel.categories;
//               return Column(
//                 children: [
//                   SizedBox(height: 15,),
//                   SizedBox(
//                     height: 50,
//                     child: TextFormField(
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                         hintText: 'Search',
//                         filled: true,
//                         fillColor: Constant.bgBtnGrey,
//                         hintStyle: TextStyle(color: Color(0xff929292)),
//                         suffixIcon: SvgPicture.asset('assets/home/search.svg', height: 50),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(color: Colors.transparent),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(color: Colors.transparent),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   // Tabs
//                   SizedBox(
//                     height: 30,
//                     child: TabBar(
//                       controller: _tabController,
//                       tabAlignment: TabAlignment.start,
//                       isScrollable: true,
//                       labelColor: Constant.bgOrangeLite,
//                       indicatorColor: Constant.bgOrangeLite,
//                       labelStyle: TextStyles.font14w4(Colors.black,),
//                       dividerColor: Colors.transparent,
//                       indicatorPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),  // Adjust the space between text and the indicator
//                       labelPadding: EdgeInsets.only(right: 20.0/*, vertical: 0*/),
//                       tabs: categoryData!.map((e) => Tab(text: e.categoryName.toString(), )).toList(),
//                     ),
//                   ),
//                   Flexible(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: categoryData.map((data) {
//                         return ListView.builder(
//                           padding: EdgeInsets.zero,
//                           itemCount: 1,
//                           itemBuilder: (context, index) {
//                             return Column(
//                               children: [
//                                 SizedBox(height: 10,),
//                                 _buildCategoryGrid(data),
//                               ],
//                             );
//                           },
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               );
//             }
//             if (state is CategoryError) {
//               return Center(
//                 child: Text(state.error),
//               );
//             }
//             return const SizedBox();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCategoryGrid(Categories? categoryData) {
//     print('adlkfj:::::::::::::::::::');
//     return ListView(
//         padding: EdgeInsets.zero,
//         shrinkWrap: true,
//         controller: listScrollController,
//         children: [
//           Column(
//             children: [
//               const SizedBox(height: 10,),
//               // banner
//               // ClipRRect(
//               //   borderRadius: BorderRadius.circular(12),
//               //   child: Stack(
//               //     children: [
//               //       CarouselSlider(
//               //         items: categoryData!.bannerImage?.map((e) {
//               //           return ClipRRect(
//               //             borderRadius: BorderRadius.circular(12),
//               //             child: CachedNetworkImage(imageUrl: e.image.toString(), fit: BoxFit.fill,),
//               //           );
//               //         }).toList(),
//               //         options: CarouselOptions(
//               //           height: 180,
//               //           aspectRatio: 16/9,
//               //           viewportFraction: 1.0,
//               //           initialPage: 0,
//               //           enableInfiniteScroll: true,
//               //           reverse: false,
//               //           autoPlay: true,
//               //           autoPlayInterval: const Duration(seconds: 3),
//               //           autoPlayAnimationDuration: const Duration(milliseconds: 800),
//               //           autoPlayCurve: Curves.fastOutSlowIn,
//               //           enlargeCenterPage: false,
//               //           enlargeFactor: 0.3,
//               //           // onPageChanged: callbackFunction,
//               //           scrollDirection: Axis.horizontal,
//               //           onPageChanged: (index, reason) {
//               //             dotIndex = index;
//               //             setState(() {
//               //
//               //             });
//               //           },
//               //         ),
//               //
//               //       ),
//               //       Positioned(
//               //           bottom: 7,
//               //           right: 0,
//               //           left: 0,
//               //           child: DotsIndicator(
//               //             dotsCount: homeData.homeBanner!.map((e) => e.image).length,
//               //             position: dotIndex,
//               //             decorator: DotsDecorator(
//               //               spacing: const EdgeInsets.all(2),
//               //               size: const Size.square(5.0),
//               //               activeSize: const Size(18.0, 5.0),
//               //               activeColor: Constant.bgOrangeLite,
//               //               activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//               //             ),
//               //           )
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               Container(
//                 height: 150,
//                 width: MediaQuery.of(context).size.width,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                     child: CachedNetworkImage(imageUrl: categoryData!.bannerImage.toString(), fit: BoxFit.fill,),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20,),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // "All" option
//                     Container(
//                       height: 90,
//                       width: 60,
//                       margin: const EdgeInsets.only(right: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   myproducts = [];
//
//                                   if (categoryData?.subcategory != null) {
//                                     for (var subcategory
//                                     in categoryData!.subcategory!) {
//                                       if (subcategory.products != null) {
//                                         myproducts!.addAll(subcategory.products!);
//                                       }
//                                     }
//                                   }
//                                 });
//                               },
//                               child: Image.asset(
//                                 'assets/images/more.png',
//                                 height: 60,
//                                 width: 60,
//                                 fit: BoxFit.cover,
//                               )),
//                           SizedBox(height: 10),
//                           Text(
//                             "All",
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w500, fontSize: 12),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Subcategory List
//                     SizedBox(
//                       height: 90,
//                       child: ListView.builder(
//                         padding: EdgeInsets.zero,
//                         shrinkWrap: true,
//                         itemCount: categoryData?.subcategory?.length ?? 0,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           var subcategory = categoryData?.subcategory?[index];
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 // Ensure subcategory and its products are not null
//                                 if (subcategory?.products != null) {
//                                   myproducts = subcategory!.products!;
//                                 }
//                               });
//                             },
//                             child: Container(
//                               width: 70,
//                               margin: const EdgeInsets.only(right: 15),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     width: 60,
//                                     height: 60,
//                                     child: CachedNetworkImage(
//                                       imageUrl:
//                                       subcategory?.image?.toString() ?? '',
//                                       imageBuilder: (context, imageProvider) =>
//                                           Container(
//                                             // width: 90.0,
//                                             // height: 90.0,
//                                             decoration: BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               image: DecorationImage(
//                                                   image: imageProvider,
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                       errorWidget: (context, url, error) =>
//                                           Icon(Icons.error),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   Text(
//                                     subcategory?.categoryName.toString() ?? '',
//                                     overflow: TextOverflow.ellipsis,
//                                     // maxLines: 2,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // SizedBox(
//               //   height: 120,
//               //   child: ListView.builder(
//               //     shrinkWrap: true,
//               //     itemCount: categoryData?.subcategory?.length,
//               //     scrollDirection: Axis.horizontal,
//               //     itemBuilder: (context, index) {
//               //       return GestureDetector(
//               //         onTap: (){
//               //           setState(() {
//               //             myproducts = categoryData.subcategory![index].products;
//               //           });
//               //         },
//               //         child: Container(
//               //           width: 100,
//               //           padding: const EdgeInsets.symmetric(horizontal: 5),
//               //           child: Column(
//               //             crossAxisAlignment: CrossAxisAlignment.center,
//               //             children: [
//               //               Container(
//               //                 width: 90,
//               //                 height: 90,
//               //                 child: CachedNetworkImage(imageUrl: categoryData!.subcategory![index].image.toString(),
//               //                   imageBuilder: (context, imageProvider) => Container(
//               //                     width: 90.0,
//               //                     height: 90.0,
//               //                     decoration: BoxDecoration(
//               //                       shape: BoxShape.circle,
//               //                       image: DecorationImage(
//               //                           image: imageProvider, fit: BoxFit.cover),
//               //                     ),
//               //                   ),
//               //                   // placeholder: (context, url) => CircularProgressIndicator(),
//               //                   errorWidget: (context, url, error) => Icon(Icons.error),
//               //
//               //                 ),
//               //               ),
//               //               // Image.asset(categoryItem[index]['image'], width: 100,),
//               //               const SizedBox(height: 10,),
//               //               Text(categoryData.subcategory![index].categoryName.toString(),
//               //                 overflow: TextOverflow.ellipsis,
//               //                 style: const TextStyle(fontWeight: FontWeight.w500,
//               //                     fontSize: 12),)
//               //             ],
//               //           ),
//               //         ),
//               //       );
//               //     },),
//               // ),
//               const SizedBox(height: 20,),
//               productBody(myproducts, categoryData)
//             ],
//           ),]
//     );
//   }
//
//   Widget productBody(List<Products>? myproducts, Categories? categoryData){
//     if(myproducts != null){
//       print('Original myproducts:');
//       myproducts.forEach((product) => print('Original myproducts:   ''ID: ${product.id}, Name: ${product.inWishlist}'));
//
//       // Find matching products based on IDs
//       final matchingProducts = categoryData!.subcategory!
//           .map((subcategory) => subcategory.products ?? [])
//           .expand((productList) => productList!) // Flatten the list of lists
//           .where((categoryProduct) => myproducts!.any((myProduct) => myProduct.id == categoryProduct.id))
//           .toList();
//
//       // Print the IDs of matching products for debugging
//       final matchingIds = matchingProducts.map((product) => product.id).toSet();
//       print('Matching IDs: $matchingIds');
//
//       print('Matching products:');
//       matchingProducts.forEach((product) => print('Matching products:   ''ID: ${product.id}, Name: ${product.inWishlist}'));
//
//
//       // Update myproducts with the matching products
//       if (matchingProducts.isNotEmpty) {
//         myproducts = matchingProducts;
//       }
//
//       // if (categoryData!.subcategory!.any((subcategory) =>
//       // subcategory.products != null && subcategory.products!.any((subcategoryProduct) =>
//       //     myproducts!.any((myProduct) => myProduct.id == subcategoryProduct.id)))) {
//       //
//       //
//       //   myproducts = categoryData.subcategory!
//       //       .map((subcategory) => subcategory.products ?? [])
//       //       .expand((productList) => productList!) // Use expand correctly to flatten the list
//       //       .toList() as List<Products>; // Explicitly cast to List<Products>
//       // }
//     }
//     else{
//
//     }
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2, crossAxisSpacing: 15,
//         mainAxisExtent: 240, mainAxisSpacing: 10, ),
//       itemCount: myproducts != null ? myproducts.length : categoryData?.products?.length,
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: (){
//             var id = categoryData!.products![index].id.toString();
//             print('id ${id}');
//             Navigator.push(context, MaterialPageRoute(builder: (context) => product.ProductDetails('category', myproducts != null
//                 ? myproducts[index].id.toString()
//                 : categoryData!.products![index].id.toString())));
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   children: [
//                     ClipRRect(
//
//                         borderRadius: BorderRadius.circular(12),
//                         child: Container(
//                           height: 160,
//                           // width: 160,
//                           child: CachedNetworkImage(
//                             imageUrl: myproducts != null
//                                 ? myproducts[index].featureImage.toString()
//                                 : categoryData!.products![index].featureImage.toString(),
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                             height: double.infinity,
//                           ),
//
//                         )
//                       // child: Image.asset(homeData.products![index].featureImage.toString(), height: 180, width: 180,)
//                     ),
//                     Positioned(
//                         top: 10,
//                         right: 10,
//                         child: InkWell(
//                           onTap: myproducts != null
//                               ? myproducts[index].loading == true
//                               ? (){}
//                               : (){
//                             context.read<CategoryBloc>().add(AddCategoryWishlistEvent(myproducts![index]));
//                             // context.read<AddWishlistBloc>().add(AddWishlistRefreshEvent(homeData.products![index].id.toString()));
//                           }
//                               : categoryData!.products![index].loading == true
//                               ? (){}
//                               : (){
//                             context.read<CategoryBloc>().add(AddCategoryWishlistEvent(categoryData.products![index]));
//                             // context.read<AddWishlistBloc>().add(AddWishlistRefreshEvent(homeData.products![index].id.toString()));
//                           },
//                           child: myproducts != null ? Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(30)
//                             ),
//                             child: myproducts[index].loading == true
//                                 ? Center(
//                                 child: SizedBox(
//                                     height: 10,
//                                     width: 10,
//                                     child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,)))
//                                 : Icon(myproducts[index].inWishlist == true
//                                 ? Icons.favorite_outlined
//                                 : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
//                           )
//                               : Container(
//                             height: 25,
//                             width: 25,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(30)
//                             ),
//                             child: categoryData!.products![index].loading == true
//                                 ? Center(
//                                 child: SizedBox(
//                                     height: 10,
//                                     width: 10,
//                                     child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,)))
//                                 : Icon(categoryData.products![index].inWishlist == true
//                                 ? Icons.favorite_outlined
//                                 : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
//                           ),
//                         )
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 10,),
//                 Text(myproducts != null
//                     ? myproducts[index].productName.toString()
//                     : categoryData!.products![index].productName.toString(),
//                   maxLines: 2, overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       fontSize: 12, fontWeight: FontWeight.bold
//                   ),),
//                 myproducts != null
//                     ? Row(
//                   children: [
//                     Text(/*myproducts[index].productType == 'variable'
//                         ? myproducts[index].productDetails!.salePrice == null
//                         ? myproducts[index].productDetails!.regularPrice.toString()
//                         : myproducts[index].productDetails!.salePrice.toString()
//                         : */myproducts[index].salePrice == null
//                         ? '\$${myproducts[index].regularPrice.toString()}'
//                         : '\$${myproducts[index].salePrice.toString()}', style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold, color: Constant.bgOrangeLite
//                     ),),
//                     const SizedBox(width: 10,),
//                     const Text('2k+ sold', style: TextStyle(
//                         fontSize: 10, fontWeight: FontWeight.w400,
//                         color: Constant.bgGrey
//                     )),
//                   ],
//                 )
//                     : Row(
//                   children: [
//                     Text(/*categoryData!.products![index].productType == 'variable'
//                         ? categoryData.products![index].productDetails!.salePrice == 'null' || categoryData.products![index].productDetails!.salePrice == null
//                         ? categoryData.products![index].productDetails!.regularPrice.toString()
//                         : categoryData.products![index].productDetails!.salePrice.toString()
//                         : */categoryData!.products![index].salePrice == null
//                         ? '\$${categoryData.products![index].regularPrice.toString()}'
//                         : '\$${categoryData.products![index].salePrice.toString()}', style: const TextStyle(
//                         fontSize: 18, fontWeight: FontWeight.bold, color: Constant.bgOrangeLite
//                     ),),
//                     const SizedBox(width: 10,),
//                     const Text('2k+ sold', style: TextStyle(
//                         fontSize: 10, fontWeight: FontWeight.w400,
//                         color: Constant.bgGrey
//                     )),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       },);
//   }
//
// }
