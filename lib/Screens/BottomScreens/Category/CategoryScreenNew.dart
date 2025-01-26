import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Api.dart';
// import 'package:nexa/Bloc/CategoryBloc/category_bloc.dart';
// import 'package:nexa/Model/CategoryModel.dart';
import 'package:nexa/Model/CategoryWiseProductModel.dart';
import 'package:nexa/Screens/BottomScreens/Category/CategoryProducts.dart';
import 'package:nexa/Screens/BottomScreens/home/HomeScreen.dart';
import 'package:nexa/Widget/TextStyles.dart';
// import 'package:nexa/Model/CategoryModel.dart' as category;
import 'package:nexa/Screens/BottomScreens/home/ProductDetails.dart' as product;
import 'package:shimmer/shimmer.dart';

import '../../../Bloc/CategoryWiseProduct/category_wise_product_bloc.dart';
import '../../../Constant.dart';

class CategoryScreen extends StatefulWidget {
  final int selectedIndex; // Add this parameter

  const CategoryScreen({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool loading = true;
  bool loadingPagination = false;
  // List<Products>? myproducts;

  // ScrollController _scrollController = ScrollController();
  ScrollController _scrollControllerSub = ScrollController();
  int currentPage = 1;
  int totalPage = 1;
  Timer? _debounce;
  // CategoryModel? categoryModel;
  CategoryWiseProductModel? categoryWiseProductModel;

  String? selectedSubCategoryId;
  String? categoryId;
  String subCategoryId = '';
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollControllerSub.addListener(_onScroll);
    fetchData();
  }

  fetchData() async {
    final res = await Api.categoryWiseProductApi('', 1, '').then((v) {
      if (v!.status == 'success') {
        categoryWiseProductModel = v; // Save the fetched data
        _tabController = TabController(length: v.categories!.length, vsync: this);

        // Listen for tab changes and call _tabData when a new tab is selected
        _tabController?.addListener(_onTabChanged); // No parameters needed
        _tabController?.index = widget.selectedIndex; // Set the tab index here
        print('selectIndex: ${_tabController?.index}');
        print('tabcontrollerindeex: ${_tabController?.index}');

        // context.read<CategoryBloc>().add(CategoryRefreshEvent(''));
        // Load data for the first tab (initial load)
        context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent('',  '', context, '', page: 1, pagination: true));
        loading = false;
        setState(() {});
      }
    });
  }


  // Triggered when the tab changes
  void _onTabChanged() {
    if (_tabController == null || categoryWiseProductModel == null) return;

    // Use debounce to prevent rapid API calls
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // _debounce = Timer(const Duration(milliseconds: 1200), () {
      _tabData();
    // });
  }


  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1200), () {
      if (_scrollControllerSub.position.pixels == _scrollControllerSub.position.maxScrollExtent) {
        if (currentPage < totalPage && !loadingPagination) {
          print('current page category ${categoryWiseProductModel!.categories![_tabController!.index].categoryName} : ${currentPage}');
          print('total page : ${totalPage}');

          // Set loading to prevent multiple calls
          loadingPagination = true;
          setState(() {

          });
          String selectedCategoryId = categoryWiseProductModel!.categories![_tabController!.index].id.toString();
          context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(
              selectedCategoryId, searchController.text, context,'',
              page: ++currentPage, pagination: true
          ));
        }
      }
    });
  }

  // Now this function doesn't take any parameters, it uses _tabController's index
  _tabData() {
    if (_tabController == null || categoryWiseProductModel == null) return;
    // Reset pagination state
    // currentPage = 1;
    loadingPagination = false;
    // searchController.text = '';
    // searchController.clear();
    String selectedCategoryId = categoryWiseProductModel!.categories![_tabController!.index].id.toString();
    // context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
    //
    // context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(selectedCategoryId, /*'',*/ '', page: 1));

    setState(() {});
  }


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 5,
        title: Text('Categories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28)),

      ),
      body: loading == true
          ? Center(
        child: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: Constant.bgOrangeLite,
            size: 40,
          ),

          // CircularProgressIndicator(color: Constant.bgOrangeLite),
      ))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<CategoryWiseProductBloc, CategoryWiseProductState>(
          builder: (context, state) {
            if (state is CategoryWiseProductLoading) {
              return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Constant.bgOrangeLite,
                    size: 40,
                  ),)

                  /*const Center(
                child: CircularProgressIndicator(color: Constant.bgOrangeLite),
              )*/;
            }
            if (state is CategoryWiseProductSuccess) {
              // loadingPagination = false;

              var categoryData = state.categoryWiseProductModel.categories;
              return Column(
                children: [
                  SizedBox(height: 15,),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: searchController,
                      cursorColor: Constant.bgOrangeLite,
                      onChanged: (value) {
                        print('categoryId : ${categoryId}');
                        print('subCategoryId : ${subCategoryId}');
                        print('search : ${value}');
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(const Duration(milliseconds: 1200), () {
                          // context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                          // Constant.showDialogProgress(context);
                          if(searchController.text.isEmpty){
                            context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryId.toString(), '', context, '', page: 1));
                          }else{
                            context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryId.toString(),  value.toString(), context, '', page: 1 ));

                          }

                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        hintText: 'Search',
                        filled: true,
                        fillColor: Constant.bgBtnGrey,
                        hintStyle: TextStyle(color: Color(0xff929292)),
                        suffixIcon: GestureDetector(
                            // onTap: () {
                            //   context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryId.toString(),  searchController.text.toString(), context, '', page: 1 ));
                            //
                            // },
                            child: SvgPicture.asset('assets/home/search.svg', height: 50)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Tabs
                  SizedBox(
                    height: 30,
                    child: TabBar(
                      onTap: (index) {
                        // // Get the selected category's id based on the index
                        // var selectedCategory = categoryData![index];
                        // categoryId = selectedCategory.id.toString();
                        //
                        // // Dispatch event to load products for the selected category
                        // context.read<CategoryWiseProductBloc>().add(ClearModelEvent(),);
                        categoryId = state.categoryWiseProductModel.categories![index].id.toString();
                        print('categoryId:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::$categoryId');
                        searchController.clear();
                        Constant.search = false;
                        context.read<CategoryWiseProductBloc>().add(TabChangeEvent(),);
                        // print('category:::::::::::::::::::::$categoryId');
                      },
                      controller: _tabController,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      labelColor: Constant.bgOrangeLite,
                      indicatorColor: Constant.bgOrangeLite,
                      labelStyle: TextStyles.font14w4(Colors.black, ),
                      dividerColor: Colors.transparent,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),  // Adjust the space between text and the indicator
                      labelPadding: EdgeInsets.only(right: 20.0/*, vertical: 0*/),
                      tabs: categoryData!.map((e) => Tab(text: e.categoryName.toString(), )).toList(),
                    ),
                  ),
                  Flexible(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: categoryData.map((data) {
                        return ListView.builder(
                          controller: _scrollControllerSub,
                          padding: EdgeInsets.zero,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(height: 10,),
                                _buildCategoryGrid(data),
                              ],
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
            if (state is CategoryWiseProductError) {
              return Center(
                child: Text(state.error),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(Categories? categoryData) {
    currentPage = categoryData!.products!.currentPage!;
    print('adlkfj:::::::::::::::::::');
    return ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        // controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
            children: [
              const SizedBox(height: 10,),
              // banner
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(12),
              //   child: Stack(
              //     children: [
              //       CarouselSlider(
              //         items: categoryData!.bannerImage?.map((e) {
              //           return ClipRRect(
              //             borderRadius: BorderRadius.circular(12),
              //             child: CachedNetworkImage(imageUrl: e.image.toString(), fit: BoxFit.fill,),
              //           );
              //         }).toList(),
              //         options: CarouselOptions(
              //           height: 180,
              //           aspectRatio: 16/9,
              //           viewportFraction: 1.0,
              //           initialPage: 0,
              //           enableInfiniteScroll: true,
              //           reverse: false,
              //           autoPlay: true,
              //           autoPlayInterval: const Duration(seconds: 3),
              //           autoPlayAnimationDuration: const Duration(milliseconds: 800),
              //           autoPlayCurve: Curves.fastOutSlowIn,
              //           enlargeCenterPage: false,
              //           enlargeFactor: 0.3,
              //           // onPageChanged: callbackFunction,
              //           scrollDirection: Axis.horizontal,
              //           onPageChanged: (index, reason) {
              //             dotIndex = index;
              //             setState(() {
              //
              //             });
              //           },
              //         ),
              //
              //       ),
              //       Positioned(
              //           bottom: 7,
              //           right: 0,
              //           left: 0,
              //           child: DotsIndicator(
              //             dotsCount: homeData.homeBanner!.map((e) => e.image).length,
              //             position: dotIndex,
              //             decorator: DotsDecorator(
              //               spacing: const EdgeInsets.all(2),
              //               size: const Size.square(5.0),
              //               activeSize: const Size(18.0, 5.0),
              //               activeColor: Constant.bgOrangeLite,
              //               activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              //             ),
              //           )
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: CachedNetworkImage(imageUrl: categoryData!.bannerImage.toString(), fit: BoxFit.fill,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "All" option
                    // Container(
                    //   height: 90,
                    //   width: 60,
                    //   margin: const EdgeInsets.only(right: 25),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       GestureDetector(
                    //           onTap: () {
                    //             // Reset pagination state when subcategory changes
                    //             currentPage = 1;
                    //             loadingPagination = false;
                    //
                    //             // Update selected subcategory ID
                    //             selectedSubCategoryId = '';
                    //             subCategoryId = '';
                    //             // searchController.text = '';
                    //             // searchController.clear();
                    //             context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                    //             context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryData.id.toString(), /*'',*/ '', context,'', page: 1));
                    //
                    //           },
                    //           child: Image.asset(
                    //             'assets/images/more.png',
                    //             height: 60,
                    //             width: 60,
                    //             fit: BoxFit.cover,
                    //           )),
                    //       SizedBox(height: 10),
                    //       Text(
                    //         "All",
                    //         overflow: TextOverflow.ellipsis,
                    //         style: const TextStyle(
                    //             fontWeight: FontWeight.w500, fontSize: 12),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Subcategory List
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: categoryData?.subcategory?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var subcategory = categoryData?.subcategory?[index];
                          categoryId = categoryData.id.toString();
                          return GestureDetector(
                            onTap: () {
                              // Reset pagination state when subcategory changes
                              currentPage = 1;
                              loadingPagination = false;

                              // Update selected subcategory ID
                              selectedSubCategoryId = subcategory?.id.toString();
                              // searchController.text = '';
                              // searchController.clear();

                              subCategoryId = categoryData.subcategory![index].id.toString() ?? '';
                              // context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                              // context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent(categoryData.id.toString(), /*categoryData.subcategory![index].id.toString(),*/ '', context,'', page: 1));

                              // setState(() {
                              //   // Ensure subcategory and its products are not null
                              //   if (subcategory?.products != null) {
                              //     myproducts = subcategory!.products!;
                              //   }
                              // });

                              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryProducts(categoryData.id.toString(), subCategoryId),));
                            },
                            child: Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      subcategory?.image?.toString() ?? '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            // width: 90.0,
                                            // height: 90.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    subcategory?.categoryName.toString() ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              // Column(
              //   children: [
              //     GridView.builder(
              //       // controller: _scrollControllerSub,
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2, crossAxisSpacing: 15,
              //         mainAxisExtent: 240, mainAxisSpacing: 10, ),
              //       itemCount: categoryData.products?.data?.length,
              //       itemBuilder: (context, index) {
              //       totalPage = categoryData.products?.lastPage;
              //         return InkWell(
              //           onTap: (){
              //             var id = categoryData.products!.data![index].id.toString();
              //             print('id ${id}');
              //             Navigator.push(context, MaterialPageRoute(builder: (context) => product.ProductDetails('category', categoryData.products!.data![index].id.toString())));
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
              //                             imageUrl:  categoryData.products!.data![index].featureImage.toString(),
              //                             placeholder: (context, url) => Shimmer.fromColors(
              //                               baseColor: Colors.grey[300]!,
              //                               highlightColor: Colors.grey[100]!,
              //                               child: Container(
              //                                 height: 160,
              //                                 // width: 60,
              //                                 decoration: BoxDecoration(
              //                                   color: Colors.white,
              //                                 ),
              //                               ),
              //                             ),
              //                             fit: BoxFit.cover,
              //                             width: double.infinity,
              //                             height: double.infinity,
              //
              //                           ),
              //
              //                         )
              //                       // child: Image.asset(homeData.products![index].featureImage.toString(), height: 180, width: 180,)
              //                     ),
              //                     Positioned(
              //                         top: 10,
              //                         right: 10,
              //                         child: InkWell(
              //                           onTap: categoryData.products!.data![index].loading == true
              //                               ? (){}
              //                               : (){
              //                             context.read<CategoryWiseProductBloc>().add(CategoryWishlistEvent(categoryData.products!.data![index]));
              //                             // context.read<AddWishlistBloc>().add(AddWishlistRefreshEvent(homeData.products![index].id.toString()));
              //                           },
              //                           child: Container(
              //                             height: 25,
              //                             width: 25,
              //                             decoration: BoxDecoration(
              //                                 color: Colors.white,
              //                                 borderRadius: BorderRadius.circular(30)
              //                             ),
              //                             child: categoryData.products!.data![index].loading == true
              //                                 ? Center(
              //                                 child: SizedBox(
              //                                     height: 10,
              //                                     width: 10,
              //                                     child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,)))
              //                                 : Icon(categoryData.products!.data![index].inWishlist == true
              //                                 ? Icons.favorite_outlined
              //                                 : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
              //                           ),
              //                         )
              //                     )
              //                   ],
              //                 ),
              //                 const SizedBox(height: 10,),
              //                 Text(categoryData.products!.data![index].productName.toString(),
              //                   maxLines: 2, overflow: TextOverflow.ellipsis,
              //                   style: const TextStyle(
              //                       fontSize: 12, fontWeight: FontWeight.bold
              //                   ),),
              //                 Row(
              //                   children: [
              //                     Text(categoryData.products!.data![index].salePrice == null
              //                         ? '\$${categoryData.products!.data![index].regularPrice.toString()}'
              //                         : '\$${categoryData.products!.data![index].salePrice.toString()}', style: const TextStyle(
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
              //       },),
              //
              //     loadingPagination == true
              //         ? Container(
              //       height: 40,
              //       width: MediaQuery.of(context).size.width,
              //       child: Center(
              //         child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
              //       ),
              //     ) : SizedBox()
              //   ],
              // )
              productBody( categoryData),

            ],
          ),]
    );
  }

  Widget productBody(var categoryData){
    return BlocListener<CategoryWiseProductBloc, CategoryWiseProductState>(
  listener: (context, state) {
    if(state is CategoryWiseProductSuccess){

      loadingPagination = false;
      setState(() {

      });
    }
  },
  child: /*_debounce!.isActive ? CircularProgressIndicator(color: Constant.bgOrangeLite,) : */BlocBuilder<CategoryWiseProductBloc, CategoryWiseProductState>(
      builder: (context, state) {
        if(state is CategoryWiseProductLoading){
          return Center(
            child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
          );
        }
        if(state is CategoryWiseProductSuccess){
          // var categoryData = state.categoryWiseProductModel.products?.data;
          // totalPage = state.categoryWiseProductModel.products?.lastPage;
          // loading = false;
          return categoryData == null
              ? SizedBox()
              : Column(
            children: [
              GridView.builder(
                // controller: _scrollControllerSub,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 15,
                  mainAxisExtent: 240, mainAxisSpacing: 10, ),
                itemCount: categoryData.products?.data?.length,
                itemBuilder: (context, index) {
                  currentPage = categoryData.products?.currentPage;
                  print('currentPage:::$currentPage');
                  totalPage = categoryData.products?.lastPage;
                  print('totalPage:::::::::: $totalPage');
                  return InkWell(
                    onTap: (){
                      var id = categoryData.products!.data![index].id.toString();
                      print('id ${id}');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => product.ProductDetails('category', categoryData.products!.data![index].id.toString())));
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
                                      imageUrl:  categoryData.products!.data![index].featureImage.toString(),
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 160,
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
                                    onTap: categoryData.products!.data![index].loading == true
                                        ? (){}
                                        : (){
                                      context.read<CategoryWiseProductBloc>().add(CategoryWishlistEvent(categoryData.products!.data![index]));
                                      // context.read<AddWishlistBloc>().add(AddWishlistRefreshEvent(homeData.products![index].id.toString()));
                                    },
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(30)
                                      ),
                                      child: categoryData.products!.data![index].loading == true
                                          ? Center(
                                          child: SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,)))
                                          : Icon(categoryData.products!.data![index].inWishlist == true
                                          ? Icons.favorite_outlined
                                          : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
                                    ),
                                  )
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Text(categoryData.products!.data![index].productName.toString(),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold
                            ),),
                          Row(
                            children: [
                              Text(categoryData.products!.data![index].salePrice == null
                                  ? '\$${categoryData.products!.data![index].regularPrice.toString()}'
                                  : '\$${categoryData.products!.data![index].salePrice.toString()}', style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Constant.bgOrangeLite
                              ),),
                              const SizedBox(width: 10,),
                              Text('${categoryData.products!.data![index].soldOut.toString()} sold', style: TextStyle(
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

              loadingPagination == true
                  ? Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
                ),
              ) : SizedBox(height: currentPage < totalPage ? 40 : 0,)
            ],
          )
          /*Column(
                children: [
                  GridView.builder(
                    // controller: _scrollControllerSub,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 15,
                      mainAxisExtent: 240, mainAxisSpacing: 10, ),
                    itemCount: state.categoryWiseProductModel.products?.data?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          var id = categoryData![index].id.toString();
                          print('id ${id}');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => product.ProductDetails('category', categoryData![index].id.toString())));
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
                                          imageUrl:  categoryData[index].featureImage.toString(),
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
                                        onTap: categoryData[index].loading == true
                                            ? (){}
                                            : (){
                                          context.read<CategoryWiseProductBloc>().add(CategoryWishlistEvent(categoryData![index]));
                                          // context.read<AddWishlistBloc>().add(AddWishlistRefreshEvent(homeData.products![index].id.toString()));
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          child: categoryData[index].loading == true
                                              ? Center(
                                              child: SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                  child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,)))
                                              : Icon(categoryData[index].inWishlist == true
                                              ? Icons.favorite_outlined
                                              : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
                                        ),
                                      )
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Text(categoryData[index].productName.toString(),
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold
                                ),),
                              Row(
                                children: [
                                  Text(categoryData[index].salePrice == null
                                      ? '\$${categoryData[index].regularPrice.toString()}'
                                      : '\$${categoryData[index].salePrice.toString()}', style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold, color: Constant.bgOrangeLite
                                  ),),
                                  const SizedBox(width: 10,),
                                  const Text('2k+ sold', style: TextStyle(
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

                  loadingPagination == true
                      ? Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
                    ),
                  ) : SizedBox()
                ],
              )*/;
        }
        if(state is CategoryWiseProductError){
          return Center(
            child: Text(state.error),
          );
        }
        return SizedBox();
      },
    ),
);
  }

}
