import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/AllProductBloc/all_product_bloc.dart';
import 'package:nexa/Model/AllProductModel.dart' as allProductModel;
import 'package:nexa/Screens/BottomScreens/home/Sort.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Constant.dart';
import 'ProductDetails.dart';

class AllProduct extends StatefulWidget {
  var brandListSend;
  var minPrice;
  var maxPrice;
  var ratingListSend;
  var priceListSend;
  var discountListSend;
  AllProduct({this.brandListSend, this.minPrice, this.maxPrice, this.ratingListSend, this.priceListSend, this.discountListSend, super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  ScrollController listScrollController = ScrollController();
  late allProductModel.Products product;
  String? _selectedSortOrder;
  String? _selectedValue;
  final List<String> _options = ['High to Low', 'Low to High'];
  ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  var totalPage ;
  bool loading = false;
  var top_sale = '';
  var price_sorting = '';
  var sorting = false;

  @override
  void initState() {

    context.read<AllProductBloc>().add(SortProductEvent(widget.brandListSend, widget.minPrice, widget.maxPrice, widget.ratingListSend, widget.priceListSend, widget.discountListSend, top_sale, price_sorting, page: 1, context: context));
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if(currentPage < totalPage){
            loading = true;
            setState(() {

            });
            context.read<AllProductBloc>().add(SortProductEvent(widget.brandListSend, widget.minPrice, widget.maxPrice, widget.ratingListSend, widget.priceListSend, widget.discountListSend, top_sale, price_sorting, page: ++currentPage, pagination: true, context: context));
          }
        }
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
        context.read<AllProductBloc>().add(DataClearEvent());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: (){
                  context.read<AllProductBloc>().add(DataClearEvent());
                  Navigator.pop(context);
                },
                child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
          ),
          title: const Text('Products', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Sort()));
                  },
                  child: Image.asset('assets/home/sort.png')),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocListener<AllProductBloc, AllProductState>(
            listener: (context, state) {
              if(state is AllProductSuccess){
                currentPage = state.allProductModel.products!.currentPage!;
                if(sorting == true){
                  Navigator.pop(context);
                  sorting = false;
                  setState(() {

                  });
                }
                loading = false;
                setState(() {

                });
              }


            },
            child: BlocBuilder<AllProductBloc, AllProductState>(
              builder: (context, state) {
                if(state is AllProductLoading){
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Constant.bgOrangeLite,
                      size: 40,
                    ),);
                }
                if(state is AllProductSuccess){
                  var allProduct = state.allProductModel.products?.data;
                  totalPage = state.allProductModel.products?.lastPage;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(top_sale == ''){
                                  top_sale = 'top_sale';
                                }else{
                                  top_sale = '';
                                }
                                context.read<AllProductBloc>().add(SortProductEvent(widget.brandListSend, widget.minPrice, widget.maxPrice, widget.ratingListSend, widget.priceListSend, widget.discountListSend, top_sale, price_sorting, page: 1, context: context));
                                sorting = true;
                                Constant.showDialogProgress(context);

                                setState(() {
                                  print('tapSale::: $top_sale');
                                });
                              },
                              child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    border: Border.all(color: top_sale == 'top_sale' ? Constant.bgOrangeLite : Constant.bgGrey),
                                    borderRadius: BorderRadius.circular(5),
                                  color: top_sale == 'top_sale' ? Constant.bgOrangeLite : Colors.white
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                                  child: Text('Top Sale', style: TextStyle(color: top_sale == 'top_sale' ? Colors.white : Constant.bgGrey, fontSize: 12, fontWeight: FontWeight.w400),),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 25,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: price_sorting.isNotEmpty ? Constant.bgOrangeLite : Colors.grey), // Replace with Constant.bgGrey
                                borderRadius: BorderRadius.circular(5),
                                color: price_sorting.isNotEmpty ? Constant.bgOrangeLite : Colors.white
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: DropdownButtonHideUnderline( // This widget hides the underline
                                child: DropdownButton<String>(
                                  value: _selectedValue,
                                  iconEnabledColor: Colors.white,
                                  iconDisabledColor: Colors.white,
                                  hint: Center(
                                    child: Text(
                                      'Price',
                                      style: TextStyle(color: price_sorting.isNotEmpty ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.w400), // Replace with Constant.bgGrey
                                    ),
                                  ),
                                  isExpanded: true, // Makes the dropdown expand to the full width
                                  icon: Icon(Icons.arrow_drop_down, color: price_sorting.isNotEmpty ? Colors.white : Colors.grey),
                                  items: _options.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      onTap: () {
                                        // if(value == 'High to Low'){
                                        //   price_sorting = 'high';
                                        // }else{
                                        //   price_sorting = 'low';
                                        // }
                                        // // context.read<AllProductBloc>().add(AllProductRefreshEvent('', '', '', '', '', '', top_sale, price_sorting, page: 1));
                                        // sorting = true;
                                        // Constant.showDialogProgress(context);
                                        // setState(() {
                                        //
                                        // });
                                        // print('price_sorting::::$price_sorting');
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Text(
                                          value,
                                          style: TextStyle(color: price_sorting.isNotEmpty ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.w400), // Replace with your desired text style
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedValue = newValue;

                                      if(newValue == 'High to Low'){
                                        price_sorting = 'high';
                                      }else{
                                        price_sorting = 'low';
                                      }
                                      context.read<AllProductBloc>().add(SortProductEvent(widget.brandListSend, widget.minPrice, widget.maxPrice, widget.ratingListSend, widget.priceListSend, widget.discountListSend, top_sale, price_sorting, page: 1, context: context));
                                      sorting = true;
                                      Constant.showDialogProgress(context);
                                      setState(() {

                                      });
                                      print('price_sorting::::$price_sorting');
                                    });
                                  },
                                  dropdownColor: price_sorting.isNotEmpty ? Constant.bgOrangeLite : Colors.white, // Sets the background color for the dropdown items

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: _scrollController,
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
                                                  )
                                              ),
                                            ),
                                            Positioned(
                                                top: 10,
                                                right: 10,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context.read<AllProductBloc>().add(AddWishlistEvent(state.allProductModel.products!.data![index].id.toString()));
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(30)
                                                    ),
                                                    child: state.allProductModel.products!.data![index].loading == true
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
                                            Text(/*allProduct[index].productType == 'variable'
                                              ? allProduct[index].productDetails!.salePrice == null
                                              ? allProduct[index].productDetails!.regularPrice.toString()
                                              : allProduct[index].productDetails!.salePrice.toString()
                                              : */allProduct[index].salePrice == null
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
                                          /*[
                                          Text(allProduct[index].salePrice == null ? allProduct[index].regularPrice.toString() : allProduct[index].salePrice.toString(), style: const TextStyle(
                                              fontSize: 18, fontWeight: FontWeight.w700, color: Constant.bgOrangeLite
                                          ),),
                                          const SizedBox(width: 10,),
                                          const Text('2k+ sold', style: TextStyle(
                                              fontSize: 10, fontWeight: FontWeight.w400,
                                              color: Constant.bgGrey
                                          )),
                                        ],*/
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
                            ) : SizedBox(),
                          ],
                        ),
                      )
                    ],
                  );
                }
                if(state is AllProductError){
                  return Center(child: Text(state.error),);
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
