import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/AllProductBloc/all_product_bloc.dart';
import 'package:nexa/Screens/BottomScreens/home/AllProducts.dart';

import '../../../Bloc/BrandBloc/brand_bloc.dart';
import '../../../Constant.dart';
import '../../../Widget/Btn.dart';

class Sort extends StatefulWidget {
  const Sort({super.key});

  @override
  State<Sort> createState() => _SortState();
}

class _SortState extends State<Sort> {
  bool brand = false;

  List<Map<String, dynamic>> brandList = [
    {
      'isCheck': false,
      'title': 'Bajaj'
    },
    {
      'isCheck': false,
      'title': 'Sony'
    },

    {
      'isCheck': false,
      'title': 'Godrej'
    },
  ];

  List<Map<String, dynamic>> ratingList = [
    // {
    //   'isCheck': false,
    //   'rating': '5'
    // },
    {
      'isCheck': false,
      'rating': '4'
    },
    {
      'isCheck': false,
      'rating': '3'
    },
    // {
    //   'isCheck': false,
    //   'rating': '2'
    // },
    // {
    //   'isCheck': false,
    //   'rating': '1'
    // },
  ];

  List<Map<String, dynamic>> priceList = [
    {
      'isCheck': false,
      'title': 'Under \$22',
      'price': '0-22'
    },
    {
      'isCheck': false,
      'title': '\$22 - \$37',
      'price': '22-37'
    },
    {
      'isCheck': false,
      'title': '\$37 - \$52',
      'price': '37-52'
    },
    {
      'isCheck': false,
      'title': 'Over \$52',
      'price': '52-'
    },
  ];

  List<Map<String, dynamic>> discountList = [
    {
      'isCheck': false,
      'title': '0 - 25%',
      'discount': '0-25'
    },
    {
      'isCheck': false,
      'title': '25% - 50%',
      'discount': '25-50'
    },
    {
      'isCheck': false,
      'title': '50% - 75%',
      'discount': '50-75'
    },
    {
      'isCheck': false,
      'title': '75% - 100%',
      'discount': '75-100'
    },
  ];

  List brandListSend = [];
  List priceListSend = [];
  List ratingListSend = [];
  List discountListSend = [];
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  String minPrice = '';
  String maxPrice = '';
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<BrandBloc>().add(BrandFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllProduct(brandListSend: brandListSend, minPrice: minPrice, maxPrice: maxPrice, ratingListSend: ratingListSend, priceListSend: priceListSend, discountListSend: discountListSend,)));
        return true;
        },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 80,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                onTap: (){
                  // Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllProduct(brandListSend: brandListSend, minPrice: minPrice, maxPrice: maxPrice, ratingListSend: ratingListSend, priceListSend: priceListSend, discountListSend: discountListSend,)));

                },
                child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
          ),
          title: const Text('Filter', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),),
        ),
        body: BlocConsumer<BrandBloc, BrandState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if(state is BrandLoading){
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Constant.bgOrangeLite,
                  size: 40,
                ),);
            }
            if(state is BrandSuccess){
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Theme(
                      //   data: ThemeData().copyWith(dividerColor: Colors.transparent),
                      //
                      //   child: const ExpansionTile(
                      //       title: Text('Category', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                      //     children: [
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             Text('Smartphones', style: TextStyle(fontWeight: FontWeight.w400,
                      //             fontSize: 14, color: Constant.bgGrey),),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(height: 5,),
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                      //         child: Row(
                      //           children: [
                      //             Text('Digital Camera', style: TextStyle(fontWeight: FontWeight.w400,
                      //                 fontSize: 14, color: Constant.bgGrey)),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(height: 5,),
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                      //         child: Row(
                      //           children: [
                      //             Text('Air Conditioner', style: TextStyle(fontWeight: FontWeight.w400,
                      //                 fontSize: 14, color: Constant.bgGrey)),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      //brand
                      Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),

                        child: ExpansionTile(tilePadding: EdgeInsets.zero,
                          title: const Text('Brand', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.brandModel.brands?.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: Checkbox(
                                          activeColor: Constant.bgOrangeLite,
                                          side: BorderSide(color: Constant.bgOrangeLite),
                                          value: state.brandModel.brands![index].check/*brandList[index]['isCheck']*/,
                                          onChanged: (value) {
                                            // if(brandList)

                                            state.brandModel.brands![index].check/*brandList[index]['isCheck']*/ = state.brandModel.brands![index].check == true ? false : true;

                                            if(state.brandModel.brands![index].check == true){
                                              brandListSend.add(state.brandModel.brands![index].id);
                                            }else{
                                              brandListSend.remove(state.brandModel.brands![index].id);
                                            }
                                            print('brandListSend::::::::::$brandListSend');
                                            setState(() {

                                            });
                                          },),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(state.brandModel.brands![index].brandName.toString()/*brandList[index]['title']*/, style: TextStyle(color: Constant.bgGrey, fontSize: 14, fontWeight: FontWeight.w400),)
                                    ],
                                  ),
                                );
                              },)
                          ],
                        ),
                      ),
                      //price
                      Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),

                        child: ExpansionTile(tilePadding: EdgeInsets.zero,
                          title: const Text('Price', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: priceList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: Checkbox(
                                          activeColor: Constant.bgOrangeLite,
                                          side: BorderSide(color: Constant.bgOrangeLite),
                                          value: priceList[index]['isCheck'],
                                          onChanged: (value) {
                                            // priceList[index]['isCheck'] = value!;

                                            priceList[index]['isCheck'] = !priceList[index]['isCheck'];

                                            if(priceList[index]['isCheck'] == true){
                                              priceListSend.add(priceList[index]['price']);
                                            }else{
                                              priceListSend.remove(priceList[index]['price']);
                                            }
                                            print('PriceListSend:::::::::$priceListSend');
                                            setState(() {

                                            });
                                          },),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(priceList[index]['title'].toString(), style: TextStyle(color: Constant.bgGrey),)
                                    ],
                                  ),
                                );
                              },)

                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      //custom price
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 70,
                              width: 90,
                              decoration: BoxDecoration(
                                // color: Constant.bgBtnGrey,
                                // borderRadius: BorderRadius.circular(12)
                              ),
                              child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: minPriceController,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Constant.bgOrangeLite,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 30, right: 12, top: 5, bottom: 10),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          // color: Constant.bgBtnGrey,
                                          borderSide: const BorderSide(color: Constant.bgBtnGrey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        fillColor: Constant.bgBtnGrey,
                                        focusedBorder: OutlineInputBorder(
                                          // color: Constant.bgBtnGrey,
                                          borderSide: const BorderSide(color: Constant.bgBtnGrey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // color: Constant.bgBtnGrey,
                                          borderSide: const BorderSide(color: Constant.bgBtnGrey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),                                    hintText: 'Min.',
                                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                      validator: (value) {
                                        if (value!.isEmpty && maxPriceController.text.isNotEmpty) {
                                          return 'Please enter minimum price';
                                        }
                                        return null;
                                      },
                                    ),
                                    const Positioned(
                                      left: 10,
                                      top: 10,
                                      child: Text(
                                        '\$',
                                        style: TextStyle(color: Constant.bgOrangeLite, fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              height: 70,
                              width: 90,
                              decoration: BoxDecoration(
                                // color: Constant.bgBtnGrey,
                                // borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: maxPriceController,
                                      cursorColor: Constant.bgOrangeLite,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 30, right: 12, top: 10, bottom: 10),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          // color: Constant.bgBtnGrey,
                                          borderSide: BorderSide(color: Constant.bgBtnGrey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        fillColor: Constant.bgBtnGrey,
                                        focusedBorder: OutlineInputBorder(
                                          // color: Constant.bgBtnGrey,
                                          borderSide: BorderSide(color: Constant.bgBtnGrey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // color: Constant.bgBtnGrey,
                                          borderSide: BorderSide(color: Constant.bgBtnGrey),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        hintText: 'Max.',
                                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                      validator: (value) {
                                        if (value!.isEmpty && minPriceController.text.isNotEmpty) {
                                          return 'Please enter maximum price';
                                        }
                                        if (value.isNotEmpty && minPriceController.text.isNotEmpty) {
                                          final min = int.tryParse(minPriceController.text);
                                          final max = int.tryParse(value);
                                          if (min != null && max != null && max <= min) {
                                            return 'Max price should be greater than Min price';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                    Positioned(
                                      left: 10,
                                      top: 10,
                                      child: Text(
                                        '\$',
                                        style: TextStyle(color: Constant.bgOrangeLite, fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            const SizedBox(width: 10,),
                            GestureDetector(
                              onTap: () {
                                if(_formKey.currentState!.validate()){
                                  FocusScope.of(context).unfocus();
                                  minPrice = minPriceController.text;
                                  maxPrice = maxPriceController.text;
                                  print('minPrice::::::::$minPrice');
                                  print('maxPrice::::::::$maxPrice');
                                }

                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Constant.bgOrangeLite,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Center(
                                  child: Text('Go', style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      //rating
                      Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),

                        child: ExpansionTile(tilePadding: EdgeInsets.zero,
                          title: const Text('Rating', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: ratingList.length,
                              itemBuilder: (context, index) {
                                // print('rating: ${double.parse(ratingList[index]['rating'].toString())}');
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: Checkbox(
                                          activeColor: Constant.bgOrangeLite,
                                          side: const BorderSide(
                                              color: Constant.bgOrangeLite
                                          ),
                                          value: ratingList[index]['isCheck'],
                                          onChanged: (value) {
                                            // ratingList[index]['isCheck'] = value!;


                                            ratingList[index]['isCheck'] = !ratingList[index]['isCheck'];

                                            if(ratingList[index]['isCheck'] == true){
                                              ratingListSend.add(ratingList[index]['rating']);
                                            }else{
                                              ratingListSend.remove(ratingList[index]['rating']);
                                            }
                                            print('ratingListSend:::::::::$ratingListSend');
                                            setState(() {

                                            });
                                          },),
                                      ),
                                      SizedBox(width: 10,),

                                      Row(
                                        children: [
                                          RatingBar.readOnly(
                                            size: 18,
                                            isHalfAllowed: true,
                                            alignment: Alignment.center,
                                            filledIcon: Icons.star,
                                            emptyIcon: Icons.star_border,
                                            halfFilledIcon: Icons.star_half,
                                            initialRating: double.parse(ratingList[index]['rating'].toString()),
                                            maxRating: 5,
                                          ),
                                          Text(' & Up', style: TextStyle(color: Constant.bgGrey, fontSize: 14, fontWeight: FontWeight.w400),),
                                        ],
                                      )                  ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      //discount
                      Theme(
                        data: ThemeData().copyWith(dividerColor: Colors.transparent),

                        child: ExpansionTile(tilePadding: EdgeInsets.zero,
                          title: const Text('Discount', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: discountList.length,
                              itemBuilder: (context, index) {
                                // print('rating: ${double.parse(ratingList[index]['rating'].toString())}');
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: Checkbox(
                                          activeColor: Constant.bgOrangeLite,
                                          side: const BorderSide(
                                              color: Constant.bgOrangeLite
                                          ),
                                          value: discountList[index]['isCheck'],
                                          onChanged: (value) {
                                            // discountList[index]['isCheck'] = value!;


                                            discountList[index]['isCheck'] = !discountList[index]['isCheck'];

                                            if(discountList[index]['isCheck'] == true){
                                              discountListSend.add(discountList[index]['discount']);
                                            }else{
                                              discountListSend.remove(discountList[index]['discount']);
                                            }
                                            print('discountListSend:::::::::$discountListSend');
                                            setState(() {

                                            });
                                          },),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(discountList[index]['title'].toString(), style: TextStyle(color: Constant.bgGrey),)
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if(state is BrandError){
              return Text(state.error.toString());
            }
            return SizedBox();
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          surfaceTintColor: Colors.white,
          height: 140,
          child: Column(
            children: [
              BlocConsumer<AllProductBloc, AllProductState>(
                listener: (context, state) {
                  if(state is AllProductLoading){
                    Constant.showDialogProgress(context);
                  }
                  if(state is AllProductSuccess){
                    Navigator.pop(context);
                    // Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllProduct(brandListSend: brandListSend, minPrice: minPrice, maxPrice: maxPrice, ratingListSend: ratingListSend, priceListSend: priceListSend, discountListSend: discountListSend,)));
                  }

                },
                builder: (context, state) {
                  return Btn('', height: 50, width: MediaQuery.of(context).size.width,
                      linearColor1: Constant.bgLinearColor1,
                      linearColor2: Constant.bgLinearColor2,
                      name: 'Apply', callBack: (){
                        context.read<AllProductBloc>().add(SortProductEvent(brandListSend, minPrice, maxPrice, ratingListSend, priceListSend, discountListSend, '', '', filter: true, context: context));
                      });
                },
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  brandListSend = [];
                  priceListSend = [];
                  ratingListSend = [];
                  discountListSend = [];
                  minPrice = '';
                  maxPrice = '';
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllProduct(brandListSend: brandListSend, minPrice: minPrice, maxPrice: maxPrice, ratingListSend: ratingListSend, priceListSend: priceListSend, discountListSend: discountListSend,)));

                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Constant.bgOrangeLite,
                          width: 2
                      )
                  ),
                  child: const Center(
                    child: Text('Reset', style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16,
                        color: Constant.bgOrangeLite),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}
