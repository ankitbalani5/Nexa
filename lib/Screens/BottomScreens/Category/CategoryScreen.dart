// import 'dart:async';
//
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
// import 'package:shimmer/shimmer.dart';
//
// import '../../../Bloc/CategoryWiseProduct/category_wise_product_bloc.dart';
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
//   bool loadingPagination = false;
//   // List<Products>? myproducts;
//
//   // ScrollController _scrollController = ScrollController();
//   ScrollController _scrollControllerSub = ScrollController();
//   int currentPage = 1;
//   var totalPage ;
//   Timer? _debounce;
//   CategoryModel? categoryModel;
//
//   String? selectedSubCategoryId;
//   String? categoryId;
//   String subCategoryId = '';
//   var searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollControllerSub.addListener(_onScroll);
//     fetchData();
//   }
//
//   fetchData() async {
//     final res = await Api.categoryApi().then((v) {
//       if (v!.status == 'success') {
//         categoryModel = v; // Save the fetched data
//         _tabController = TabController(length: v.categories!.length, vsync: this);
//
//         // Listen for tab changes and call _tabData when a new tab is selected
//         _tabController?.addListener(_onTabChanged); // No parameters needed
//         _tabController?.index = widget.selectedIndex; // Set the tab index here
//         print('tabcontrollerindeex: ${_tabController?.index}');
//
//         context.read<CategoryBloc>().add(CategoryRefreshEvent(''));
//         // Load data for the first tab (initial load)
//         context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(v.categories![0].id.toString(), _tabController?.index.toString() ?? '', '', page: 1));
//         loading = false;
//         setState(() {});
//       }
//     });
//   }
//
//
//   // Triggered when the tab changes
//   void _onTabChanged() {
//     if (_tabController == null || categoryModel == null) return;
//
//     // Use debounce to prevent rapid API calls
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 1200), () {
//       _tabData();
//     });
//   }
//
//   // for pagination
//   void _onScroll() {
//     if (_scrollControllerSub.position.pixels >= _scrollControllerSub.position.maxScrollExtent - 100) {
//       if(currentPage < totalPage){
//         print('total page : ${totalPage}');
//         loadingPagination = true;
//         setState(() {
//
//         });
//         String selectedCategoryId = categoryModel!.categories![_tabController!.index].id.toString();
//         context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(selectedCategoryId, selectedSubCategoryId ?? '', '', page: ++currentPage));
//       }
//     }
//   }
//
//   // Now this function doesn't take any parameters, it uses _tabController's index
//   _tabData() {
//     if (_tabController == null || categoryModel == null) return;
//     // Reset pagination state
//     currentPage = 1;
//     loadingPagination = false;
//     searchController.clear();
//     String selectedCategoryId = categoryModel!.categories![_tabController!.index].id.toString();
//     context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
//
//     context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(selectedCategoryId, '', '', page: 1));
//
//     setState(() {});
//   }
//
//   // fetchData() async {
//   //   final res = await Api.categoryApi().then((v) {
//   //     if (v!.status == 'success') {
//   //       _tabController = TabController(length: v.categories!.length, vsync: this);
//   //       _tabController?.addListener(_tabData(v/*, _tabController!.index*/));
//   //       _tabController?.index = widget.selectedIndex; // Set the tab index here
//   //       context.read<CategoryBloc>().add(CategoryRefreshEvent(''));
//   //       context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(v.categories![0].id.toString(), '1', ''));
//   //       loading = false;
//   //       setState(() {});
//   //     }
//   //   });
//   // }
//   //
//   // _tabData(CategoryModel? v/*, int index*/) {
//   //   // String selectedCategoryId = v!.categories![index].id.toString();
//   //   //
//   //   // context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(selectedCategoryId, '1', ''));
//   //   setState(() {});
//   // }
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
//                       controller: searchController,
//                       cursorColor: Constant.bgOrangeLite,
//                       onChanged: (value) {
//                         print('categoryId : ${categoryId}');
//                         print('subCategoryId : ${subCategoryId}');
//                         print('search : ${value}');
//                         if (_debounce?.isActive ?? false) _debounce!.cancel();
//                         _debounce = Timer(const Duration(milliseconds: 1000), () {
//                           context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
//                           context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryId.toString(), subCategoryId.toString(), value.toString(), page: 1));
//
//                         });
//                       },
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
//                   const SizedBox(height: 22),
//                   // Tabs
//                   SizedBox(
//                     height: 30,
//                     child: TabBar(
//                       controller: _tabController,
//                       tabAlignment: TabAlignment.start,
//                       isScrollable: true,
//                       labelColor: Constant.bgOrangeLite,
//                       indicatorColor: Constant.bgOrangeLite,
//                       labelStyle: TextStyles.font14w4(Colors.black, ),
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
//                           controller: _scrollControllerSub,
//                           padding: EdgeInsets.zero,
//                           physics: AlwaysScrollableScrollPhysics(),
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
//         // controller: _scrollController,
//         physics: NeverScrollableScrollPhysics(),
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
//                     child: CachedNetworkImage(imageUrl: categoryData!.bannerImage.toString(), fit: BoxFit.fill,
//                       placeholder: (context, url) => Shimmer.fromColors(
//                         baseColor: Colors.grey[300]!,
//                         highlightColor: Colors.grey[100]!,
//                         child: Container(
//                           height: 150,
//                           width: double.infinity,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30,),
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
//                       margin: const EdgeInsets.only(right: 25),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           GestureDetector(
//                               onTap: () {
//                                 // Reset pagination state when subcategory changes
//                                 currentPage = 1;
//                                 loadingPagination = false;
//
//                                 // Update selected subcategory ID
//                                 selectedSubCategoryId = '';
//                                 subCategoryId = '';
//                                 searchController.clear();
//                                 context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
//                                 context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryData.id.toString(), '', '', page: 1));
//
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
//                       height: 110,
//                       child: ListView.builder(
//                         padding: EdgeInsets.zero,
//                         shrinkWrap: true,
//                         itemCount: categoryData?.subcategory?.length ?? 0,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           var subcategory = categoryData?.subcategory?[index];
//                           categoryId = categoryData.id.toString();
//                           return GestureDetector(
//                             onTap: () {
//                               // Reset pagination state when subcategory changes
//                               currentPage = 1;
//                               loadingPagination = false;
//
//                               // Update selected subcategory ID
//                               selectedSubCategoryId = subcategory?.id.toString();
//                               searchController.clear();
//
//                               subCategoryId = categoryData.subcategory![index].id.toString() ?? '';
//                               context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
//                               context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryData.id.toString(), categoryData.subcategory![index].id.toString(), '', page: 1));
//
//                               // setState(() {
//                               //   // Ensure subcategory and its products are not null
//                               //   if (subcategory?.products != null) {
//                               //     myproducts = subcategory!.products!;
//                               //   }
//                               // });
//                             },
//                             child: Container(
//                               width: 80,
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
//                                       placeholder: (context, url) => Shimmer.fromColors(
//                                         baseColor: Colors.grey[300]!,
//                                         highlightColor: Colors.grey[100]!,
//                                         child: Container(
//                                           height: 60,
//                                           width: 60,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             shape: BoxShape.circle,
//                                           ),
//                                         ),
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           Icon(Icons.error),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   Text(
//                                     subcategory?.categoryName.toString() ?? '',
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 2,
//                                     textAlign: TextAlign.center,
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
//               productBody(),
//
//             ],
//           ),]
//     );
//   }
//
//   Widget productBody(){
//     return BlocListener<CategoryWiseProductBloc, CategoryWiseProductState>(
//   listener: (context, state) {
//     if(state is CategoryWiseProductSuccess){
//
//       loadingPagination = false;
//       setState(() {
//
//       });
//     }
//   },
//   child: BlocBuilder<CategoryWiseProductBloc, CategoryWiseProductState>(
//       builder: (context, state) {
//         if(state is CategoryWiseProductLoading){
//           return Center(
//             child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
//           );
//         }
//         if(state is CategoryWiseProductSuccess){
//           var categoryData = state.categoryWiseProductModel.products?.data;
//           totalPage = state.categoryWiseProductModel.products?.lastPage;
//           // loading = false;
//           return categoryData == null
//               ? SizedBox()
//               : Column(
//                 children: [
//                   GridView.builder(
//                     // controller: _scrollControllerSub,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2, crossAxisSpacing: 15,
//                       mainAxisExtent: 240, mainAxisSpacing: 10, ),
//                     itemCount: state.categoryWiseProductModel.products?.data?.length,
//                     itemBuilder: (context, index) {
//                       return InkWell(
//                         onTap: (){
//                           var id = categoryData![index].id.toString();
//                           print('id ${id}');
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => product.ProductDetails('category', categoryData![index].id.toString())));
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Stack(
//                                 children: [
//                                   ClipRRect(
//
//                                       borderRadius: BorderRadius.circular(12),
//                                       child: Container(
//                                         height: 160,
//                                         // width: 160,
//                                         child: CachedNetworkImage(
//                                           imageUrl:  categoryData[index].featureImage.toString(),
//                                           fit: BoxFit.cover,
//                                           width: double.infinity,
//                                           height: double.infinity,
//
//                                         ),
//
//                                       )
//                                     // child: Image.asset(homeData.products![index].featureImage.toString(), height: 180, width: 180,)
//                                   ),
//                                   Positioned(
//                                       top: 10,
//                                       right: 10,
//                                       child: InkWell(
//                                         onTap: categoryData[index].loading == true
//                                             ? (){}
//                                             : (){
//                                           context.read<CategoryWiseProductBloc>().add(CategoryWishlistEvent(categoryData![index]));
//                                           // context.read<AddWishlistBloc>().add(AddWishlistRefreshEvent(homeData.products![index].id.toString()));
//                                         },
//                                         child: Container(
//                                           height: 25,
//                                           width: 25,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius: BorderRadius.circular(30)
//                                           ),
//                                           child: categoryData[index].loading == true
//                                               ? Center(
//                                               child: SizedBox(
//                                                   height: 10,
//                                                   width: 10,
//                                                   child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,)))
//                                               : Icon(categoryData[index].inWishlist == true
//                                               ? Icons.favorite_outlined
//                                               : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
//                                         ),
//                                       )
//                                   )
//                                 ],
//                               ),
//                               const SizedBox(height: 10,),
//                               Text(categoryData[index].productName.toString(),
//                                 maxLines: 2, overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(
//                                     fontSize: 12, fontWeight: FontWeight.bold
//                                 ),),
//                               Row(
//                                 children: [
//                                   Text(categoryData[index].salePrice == null
//                                       ? '\$${categoryData[index].regularPrice.toString()}'
//                                       : '\$${categoryData[index].salePrice.toString()}', style: const TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.bold, color: Constant.bgOrangeLite
//                                   ),),
//                                   const SizedBox(width: 10,),
//                                   const Text('2k+ sold', style: TextStyle(
//                                       fontSize: 10, fontWeight: FontWeight.w400,
//                                       color: Constant.bgGrey
//                                   )),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                     },),
//
//                   loadingPagination == true
//                       ? Container(
//                     height: 40,
//                     width: MediaQuery.of(context).size.width,
//                     child: Center(
//                       child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
//                     ),
//                   ) : SizedBox()
//                 ],
//               );
//         }
//         if(state is CategoryWiseProductError){
//           return Center(
//             child: Text(state.error),
//           );
//         }
//         return SizedBox();
//       },
//     ),
// );
//   }
//
// }
