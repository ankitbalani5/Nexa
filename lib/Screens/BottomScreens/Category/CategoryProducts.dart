import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Bloc/CategoryWiseProduct/category_wise_product_bloc.dart';
import '../../../Bloc/SubCategoryBloc/sub_category_bloc.dart';
import '../../../Constant.dart';
import '../home/ProductDetails.dart';
import '../home/Sort.dart';

class CategoryProducts extends StatefulWidget {
  String CategoryId;
  String SubCategoryId;
  CategoryProducts(this.CategoryId, this.SubCategoryId, {super.key});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {


  ScrollController listScrollController = ScrollController();
  String? _selectedSortOrder;
  String? _selectedValue;
  final List<String> _options = ['High to Low', 'Low to High'];
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  var totalPage ;
  bool loading = false;
  var searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(widget.CategoryId, widget.SubCategoryId, 1, '', false));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1200), () {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if(currentPage < totalPage){
        loading = true;
        setState(() {

        });
        // context.read<SubCategoryBloc>().add(AllProductRefreshEvent('', '' ,'', '', '' , '', page: ++currentPage,));
        context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(widget.CategoryId, widget.SubCategoryId, ++currentPage, searchController.text, true));
      }
    }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        context.read<SubCategoryBloc>().add(DataClearEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: (){
                  context.read<SubCategoryBloc>().add(DataClearEvent());
                  Navigator.pop(context);
                },
                child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
          ),
          title: const Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          //     child: InkWell(
          //         onTap: () {
          //           Navigator.push(context, MaterialPageRoute(builder: (context) => Sort()));
          //         },
          //         child: Image.asset('assets/home/sort.png')),
          //   )
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [

              SizedBox(height: 15,),
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: searchController,
                  cursorColor: Constant.bgOrangeLite,
                  onChanged: (value) {
                    // print('categoryId : ${categoryId}');
                    // print('subCategoryId : ${subCategoryId}');
                    print('search : ${value}');
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 800), () {
                      // context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                      // Constant.showDialogProgress(context);
                      if(searchController.text.isNotEmpty){
                        context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(widget.CategoryId, widget.SubCategoryId, 1 , value.toString(), false));
                      }else if (searchController.text.isEmpty){
                        setState(() {
                          context.read<SubCategoryBloc>().add(SubCategoryLoadEvent(widget.CategoryId, widget.SubCategoryId, 1 , '', false));
                        });
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
              Expanded(
                child: BlocListener<SubCategoryBloc, SubCategoryState>(
                  listener: (context, state) {
                    if(state is SubCategorySuccess){
                      loading = false;
                      setState(() {
                
                      });
                    }
                
                
                  },
                  child: BlocBuilder<SubCategoryBloc, SubCategoryState>(
                    builder: (context, state) {
                      if(state is SubCategoryLoading){
                        return Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: Constant.bgOrangeLite,
                            size: 40,
                          ),);
                      }
                      if(state is SubCategorySuccess){
                        var allProduct = state.subCategoryModel.products?.data;
                        currentPage = state.subCategoryModel.products!.currentPage!;
                        print('currentPage:::$currentPage');
                        totalPage = state.subCategoryModel.products?.lastPage;
                        return allProduct!.isEmpty
                            ? Center(
                          child: Text('No Product'),
                        )
                            : ListView(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: [
                
                            GridView.builder(
                              // controller: _scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, crossAxisSpacing: 15,
                                  mainAxisExtent: 240, mainAxisSpacing: 10),
                              itemCount: allProduct?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        ProductDetails('allproduct', allProduct[index].id.toString())));
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
                                            Container(
                                              height: 160,
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    imageUrl: allProduct![index].featureImage.toString(),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  )
                                              ),
                                            ),
                                            Positioned(
                                                top: 10,
                                                right: 10,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context.read<SubCategoryBloc>().add(AddWishlistEvent(state.subCategoryModel.products!.data![index].id.toString()));
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(30)
                                                    ),
                                                    child: state.subCategoryModel.products!.data![index].loading == true
                                                        ? Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,),
                                                    )
                                                        : Icon(allProduct[index].inWishlist == true
                                                        ? Icons.favorite_outlined
                                                        : Icons.favorite_border, size: 15, color: Constant.bgOrangeLite,),
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(allProduct[index].productName.toString(), maxLines: 2, overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.bold
                                          ),),
                                        Row(
                                          children: [
                                            Text(allProduct[index].salePrice == null
                                                ? '\$${allProduct[index].regularPrice.toString()}'
                                                : '\$${allProduct[index].salePrice.toString()}', style: const TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w700, color: Constant.bgOrangeLite
                                            ),),
                                            const SizedBox(width: 10,),
                                            Text('${allProduct[index].soldOut.toString()} sold', style: TextStyle(
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
                            loading == true
                                ? Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
                              ),
                            ) : SizedBox(height: currentPage < totalPage ? 40 : 0,)
                          ],
                        );
                      }
                      if(state is SubCategoryError){
                        return Center(child: Text(state.error),);
                      }
                      return SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          height: 45,
          width: 45,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.white,
            onPressed: () {
              if(_scrollController.hasClients){
                final position = _scrollController.position.minScrollExtent;
                _scrollController.animateTo(
                    position,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeOut);
              }
            },
            isExtended: true,
            tooltip: 'Scroll to Top',
            child: Icon(Icons.keyboard_arrow_up, color: Constant.bgOrangeLite,),
          ),
        ),
      ),
    );
  }
}
