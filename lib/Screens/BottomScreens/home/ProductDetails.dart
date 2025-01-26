import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/SingleProductBloc/single_product_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Model/ProductReviewModel.dart';
import 'package:nexa/NavBar.dart';
import 'package:nexa/Screens/AddReview.dart';
import 'package:nexa/Screens/BottomScreens/home/AllProducts.dart';
import 'package:nexa/Screens/BottomScreens/home/ItemReviews.dart';
import 'package:nexa/Screens/ProfileScreens/CustomerSupport.dart';
import 'package:nexa/Widget/Btn.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../../Bloc/AllProductBloc/all_product_bloc.dart';
import '../../../Bloc/AllWishlistBloc/all_wishlist_bloc.dart';
// import '../../../Bloc/CategoryBloc/category_bloc.dart';
import '../../../Bloc/CategoryWiseProduct/category_wise_product_bloc.dart';
import '../../../Bloc/HomeBloc/home_bloc.dart';
import '../../../Bloc/ProductReviewBloc/product_review_bloc.dart';
import '../../../Model/HomeModel.dart';
import '../../../Widget/ThumbsUpAnimation.dart';
import '../../../Widget/VideoPlayer.dart';
enum SampleItem { itemOne, itemTwo, itemThree }
class ProductDetails extends StatefulWidget {
  String path;
  String itemId;
  ProductDetails(this.path, this. itemId, {super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  SampleItem? selectedItem;
  int currentIndexPage = 0;
  bool galleryImageTapped = false;
  var frontImageTap;
  int? currentCounter;
  ScrollController listScrollController = ScrollController();
  // ProductReviewBloc? reviewBloc = ProductReviewBloc();
  ProductReviewBloc? reviewBloc;
  // ReviewHelpfulBloc? reviewHelpfulBloc;

  @override
  void initState() {
    context.read<SingleProductBloc>().add(SingleProductRefreshEvent(widget.itemId.toString()));
    context.read<ProductReviewBloc>().add(ProductReviewLoadEvent(widget.itemId.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white, // navigation bar color
          statusBarColor: Colors.white, // status bar color
        ));
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        // title: const Text('Product', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: (){
                if(widget.path == 'home'){
                  context.read<HomeBloc>().add(HomeRefreshEvent('', ''));
                  Navigator.pop(context);
                }else if(widget.path == 'wishlist'){

                  context.read<AllWishlistBloc>().add(WishlistRefreshEvent());
                  Navigator.pop(context);
                }else if(widget.path == 'allproduct'){

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllProduct()));
                  // context.read<AllProductBloc>().add(AllProductRefreshEvent('', '', '', '', '', '', '', '', page: 1));
                  Navigator.pop(context);
                }else if(widget.path == 'category'){
                  context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
                  context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent('',  '', context, '', page: 1, pagination: true));
                  // context.read<CategoryBloc>().add(CategoryRefreshEvent(''));
                  Navigator.pop(context);
                }else if(widget.path == 'splash'){
                  exit(0);
                }

              },
              child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
        ),
        actions: [Row(
          children: [
            InkWell(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 3,)), (route) => false,);
                },
                child: Icon(Icons.add_shopping_cart, color: Constant.bgOrangeLite, size: 20,)/*Image.asset('assets/home/customerSupport.png', height: 20, width: 20,)*/),
            SizedBox(width: 10,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerSupport()));
                },
                child: Image.asset('assets/home/customerSupport.png', height: 20, width: 20,)),
            SizedBox(width: 10,),
            BlocBuilder<SingleProductBloc, SingleProductState>(
            builder: (context, state) {
              if(state is SingleProductSuccess){
                return InkWell(
                          onTap: () async {
                            String productId = widget.itemId;
                            String link = 'https://urlsdemo.online/nexa/productDetails?productId=$productId';
                            String featureImageUrl = state.singleProductModel.product?.featureImage ?? '';

                            try {
                              // Download the feature image
                              var response = await http.get(Uri.parse(featureImageUrl));
                              final documentDirectory = await getApplicationDocumentsDirectory();
                              final file = File('${documentDirectory.path}/feature_image.png');
                              file.writeAsBytesSync(response.bodyBytes);
                              var xfile = XFile(file.path);

                              // Share the image and the link
                              await Share.shareXFiles(
                                [xfile]/*[file.path]*/,
                                text: 'Check out this product: $link',
                              );
                            } catch (e) {
                              print("Error sharing link or image: $e");
                            }
                            // String productId = widget.itemId;
                            // String link = 'https://urlsdemo.online/nexa/productDetails?productId=$productId';
                            //
                            // // Share the link using the Share package
                            // try {
                            //   await Share.share('Check out this product: $link');
                            // } catch (e) {
                            //   print("Error sharing link: $e");
                            // }
                          },
                          child: Image.asset('assets/home/share1.png', height: 20, width: 20,));
              }
              return SizedBox();
            },
          ),
            SizedBox(width: 20,)
          ],
        ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async{

          if(widget.path == 'home'){
            context.read<HomeBloc>().add(HomeRefreshEvent('', ''));
          }else if(widget.path == 'wishlist'){

            context.read<AllWishlistBloc>().add(WishlistRefreshEvent());
          }else if(widget.path == 'allproduct'){

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllProduct()));
            // context.read<AllProductBloc>().add(AllProductRefreshEvent('', '', '', '', '', '', '', '', page: 1));
          }else if(widget.path == 'category'){
            context.read<CategoryWiseProductBloc>().add(ClearModelEvent());
            context.read<CategoryWiseProductBloc>().add(CategoryWiseProductLoadEvent('',  '', context, '', page: 1, pagination: true));
            // context.read<CategoryBloc>().add(CategoryRefreshEvent(''));
          }else if(widget.path == 'splash'){
            Navigator.pop(context);
          }
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocBuilder<SingleProductBloc, SingleProductState>(
            builder: (context, state) {
              if(state is SingleProductLoading){
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Constant.bgOrangeLite,
                    size: 40,
                  ),);
              }
              if(state is SingleProductSuccess){
                var singleProduct = state.singleProductModel.product;
                currentCounter = state.counter;
                return ListView(
                    controller: listScrollController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15,),
                          SizedBox(
                              height: 334,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      height: 334,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                      imageUrl: frontImageTap ?? singleProduct!.featureImage.toString()/*frontImageTap ?? frontImage*/,
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
                                      errorWidget: (context, url, error) => Icon(Icons.error),

                                    ),
                                  )
                                // child: CarouselSlider(
                                //   items: singleProduct?.productDetails![0].colorImages.featureImage.map<Widget>((e) {
                                //     return CachedNetworkImage(imageUrl: e.image.toString());
                                //   }).toList(),
                                //   options: CarouselOptions(
                                //     height: 300,
                                //     aspectRatio: 16/9,
                                //     viewportFraction: 0.8,
                                //     initialPage: 0,
                                //     enableInfiniteScroll: true,
                                //     reverse: false,
                                //     autoPlay: true,
                                //     autoPlayInterval: const Duration(seconds: 3),
                                //     autoPlayAnimationDuration: const Duration(milliseconds: 800),
                                //     autoPlayCurve: Curves.fastOutSlowIn,
                                //     enlargeCenterPage: true,
                                //     enlargeFactor: 0.3,
                                //     // onPageChanged: callbackFunction,
                                //     scrollDirection: Axis.horizontal,
                                //     onPageChanged: (index, reason) {
                                //       currentIndexPage = index ;
                                //       setState(() {
                                //
                                //       });
                                //     },
                                //   ),
                                //
                                // ),
                              )
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width*.58,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: /*singleProduct!.productType == 'variable'
                                  && singleProduct.productDetails![0].colorImages!.featureImage != null
                                  ? singleProduct!.productDetails![0].colorImages!.colorGallery?.length
                                  : */singleProduct?.galleryImage?.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        galleryImageTapped = true;

                                        frontImageTap = /*singleProduct.productType == 'variable'
                                        && singleProduct.productDetails![0].colorImages!.featureImage != null
                                        ? singleProduct!.productDetails!.first.colorImages!.colorGallery![index].toString()
                                        : */singleProduct?.galleryImage![index].toString();
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        height: 48,
                                        width: 48,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                              imageUrl: /*singleProduct.productType == 'variable'
                                              && singleProduct.productDetails![0].colorImages!.featureImage != null
                                              ? singleProduct!.productDetails!.first.colorImages!.colorGallery![index]
                                              : */singleProduct!.galleryImage![index],
                                              placeholder: (context, url) => Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor: Colors.grey[100]!,
                                                child: Container(
                                                  // width: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )
                                          ),
                                        ),
                                      ),
                                    );
                                  },),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.read<SingleProductBloc>().add(AddWishlistSingleEvent(state.singleProductModel.product!.productId.toString()));
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5.0,
                                        ),]
                                    ),
                                    child: singleProduct!.loading == true
                                        ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,),
                                        ))
                                        : Icon(singleProduct?.like == true ? Icons.favorite : Icons.favorite_border, color: Constant.bgOrangeLite,),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          Text(singleProduct!.productName.toString(), style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18
                          ),),
                          Text(singleProduct.description.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14, color: Constant.bgGrey
                              )
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*singleProduct.availableQuantity == 0
                                  ? SizedBox()
                                  :*/Container(
                                height: 24,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: singleProduct.availableQuantity == 0 ? Constant.bgBtnGrey : Constant.bgOrangeLite
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                        onTap: singleProduct.counter! <= 1 || singleProduct.availableQuantity == 0 || singleProduct.counter! <= int.parse(singleProduct.minOrder.toString())
                                            ? (){}
                                            : (){
                                          context.read<SingleProductBloc>().add(DecreaseItemEvent(currentCounter!));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: const Icon(Icons.remove, color: Colors.white, size: 18,),
                                        )),
                                    Text(singleProduct.counter.toString(), style: const TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.w600, fontSize: 16),),
                                    InkWell(
                                        onTap: singleProduct.availableQuantity == 0
                                            ? (){}
                                            : (){
                                          context.read<SingleProductBloc>().add(IncreaseItemEvent(currentCounter!));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: const Icon(Icons.add, color: Colors.white, size: 18,),
                                        )),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(/*singleProduct.productType == 'variable'
                                  ? singleProduct.productDetails![0].salePrice != null
                                    ? singleProduct.productDetails![0].salePrice.toString()
                                    : singleProduct.productDetails![0].regularPrice.toString()
                                  : */singleProduct.salePrice != null
                                      ? '\$${singleProduct.salePrice.toString()}'
                                      : '\$${singleProduct.regularPrice.toString()}',
                                      // singleProduct.salePrice == null ? singleProduct.regularPrice.toString() : singleProduct.salePrice.toString(),
                                      style: const TextStyle(color: Constant.bgOrangeLite,
                                          fontWeight: FontWeight.w700, fontSize: 24)
                                  ),
                                  /*singleProduct.salePrice != null ? */Text(' \$${/*singleProduct.productType == 'variable'
                                  ? singleProduct.productDetails![0].regularPrice.toString()
                                  : */singleProduct.regularPrice.toString()}',
                                      style: const TextStyle(color: Constant.bgGrey,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Constant.bgGrey,
                                          fontWeight: FontWeight.w700, fontSize: 16))/* : const SizedBox()*/,
                                  // singleProduct.salePrice != null ? Text(' \$${singleProduct.regularPrice.toString()}', style: const TextStyle(color: Constant.bgGrey,
                                  //     fontWeight: FontWeight.w700, fontSize: 16)) : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          const Text('Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(singleProduct.description.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14, color: Constant.bgGrey
                              )
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Product Ratings', style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18),),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ItemReviews(widget.itemId)));
                                        },
                                        child: const Text('See All', style: TextStyle(color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.bold, fontSize: 14),),
                                      ),
                                      const Icon(Icons.arrow_forward_ios, color: Constant.bgOrangeLite, size: 14,)
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(singleProduct.averageRating.toString(), style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 18)),
                                  SizedBox(width: 10,),
                                  RatingBar.readOnly(
                                    isHalfAllowed: true,
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    halfFilledIcon: Icons.star,
                                    initialRating: double.parse(singleProduct.averageRating.toString()),
                                    maxRating: 5,
                                    size: 18,
                                  ),
                                ],
                              ),


                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: singleProduct.reviews?.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                                          ),
                                          // ClipRRect(
                                          //   borderRadius: BorderRadius.circular(12),
                                          //   child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                                          // ),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(singleProduct.reviews![index].userName.toString(), style: TextStyle(fontWeight: FontWeight.bold,
                                                  fontSize: 15
                                              ),),
                                              Row(
                                                children: [
                                                  Icon(Icons.access_time, color: Constant.bgGrey, size: 15,),
                                                  SizedBox(width: 5, ),
                                                  Text(singleProduct.reviews![index].date.toString(), style: TextStyle(fontWeight: FontWeight.w400,
                                                      fontSize: 11,
                                                      color: Constant.bgGrey),),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      RatingBar.readOnly(
                                        filledIcon: Icons.star,
                                        emptyIcon: Icons.star_border,
                                        initialRating: double.parse(singleProduct.reviews![index].rating.toString()),
                                        maxRating: 5,
                                        size: 18,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(singleProduct.reviews![index].description.toString(),
                                        style: TextStyle(color: Constant.bgGrey),),
                                      SizedBox(height: 10,),
                                      singleProduct.reviews![index].media!.isEmpty
                                          ? SizedBox()
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                              height: 100,
                                              width: 260,
                                              child:
                                              ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemCount: singleProduct.reviews![index].media?.length ?? 0,
                                                itemBuilder: (context, mediaIndex) {
                                                  String mediaUrl = singleProduct.reviews![index].media![mediaIndex].toString();

                                                  // Check if the media is an image or a video
                                                  bool isVideo = mediaUrl.endsWith('.mp4');

                                                  return Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Container(
                                                        // margin: const EdgeInsets.all(5),
                                                        height: 85,
                                                        width: 85,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(10)
                                                        ),
                                                        child: isVideo
                                                            ? VideoPlayerWidget(videoUrl: mediaUrl)
                                                            : CachedNetworkImage(
                                                          imageUrl: mediaUrl,
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
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            /*ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: productReview.reviews![index].media?.length,
                                                  itemBuilder: (context, index) {
                                                    return ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Container(
                                                        margin: const EdgeInsets.all(5),
                                                        height: 80,
                                                        width: 80,
                                                        child: CachedNetworkImage(
                                                            imageUrl: productReview.reviews![index].media![index].toString()),
                                                      ),
                                                    );
                                                  },),*/
                                          ),
                                        ],
                                      ),
                                      // SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              ThumbsUpAnimation(
                                                tapped: singleProduct.reviews![index].helpful!,
                                                onTap: () {
                                                  context.read<ProductReviewBloc>().add(ReviewHelpfulTapEvent(singleProduct.reviews![index].productId.toString(), singleProduct.reviews![index].id.toString()));
                                                  print('Thumbs up tapped!');
                                                },
                                              ),
                                              //   BlocBuilder<ReviewHelpfulBloc, ReviewHelpfulState>(
                                              //   bloc: reviewHelpfulBloc,
                                              //   builder: (context, state) {
                                              //     return
                                              //   },
                                              // ),
                                              const SizedBox(width: 5,),
                                              BlocBuilder<ProductReviewBloc, ProductReviewState>(
                                                builder: (context, state) {
                                                  if(state is ProductReviewSuccess){
                                                    var productReview = state.productReviewModel.reviews;
                                                    return Text('Helpful (${productReview?[index].helpfulVotesCount.toString()})', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),);
                                                  }
                                                  return SizedBox();
                                                },
                                              ),
                                              // PopupMenuButton<SampleItem>(
                                              //   child: Container(
                                              //     height: 36,
                                              //     // width: 48,
                                              //     alignment: Alignment.centerRight,
                                              //     child: Icon(
                                              //       Icons.more_vert,
                                              //     ),
                                              //   ),
                                              //   initialValue: selectedItem,
                                              //   onSelected: (SampleItem item) {
                                              //     setState(() {
                                              //       selectedItem = item;
                                              //     });
                                              //   },
                                              //   itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                                              //     const PopupMenuItem<SampleItem>(
                                              //       value: SampleItem.itemOne,
                                              //       child: Text('Item 1'),
                                              //     ),
                                              //     const PopupMenuItem<SampleItem>(
                                              //       value: SampleItem.itemTwo,
                                              //       child: Text('Item ReviewHelpful'),
                                              //     ),
                                              //     const PopupMenuItem<SampleItem>(
                                              //       value: SampleItem.itemThree,
                                              //       child: Text('Item 3'),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          )
                                        ],
                                      ),

                                      Divider(color: Color(0xff272727).withOpacity(.10)),
                                    ],
                                  );
                                },
                              ),
                            ],
                          )


                          // BlocBuilder<ProductReviewBloc, ProductReviewState>(
                          //   bloc: reviewBloc,
                          //   builder: (context, state) {
                          //     if(state is ProductReviewLoading){
                          //       return Center(
                          //         child: LoadingAnimationWidget.fourRotatingDots(
                          //           color: Constant.bgOrangeLite,
                          //           size: 40,
                          //         ),
                          //       );
                          //     }
                          //     if(state is ProductReviewSuccess){
                          //       var productReview = state.productReviewModel;
                          //       return Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const SizedBox(height: 20,),
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               const Text('Product Ratings', style: TextStyle(
                          //                   fontWeight: FontWeight.bold, fontSize: 18),),
                          //               Row(
                          //                 children: [
                          //                   InkWell(
                          //                     onTap: () {
                          //                       Navigator.push(context, MaterialPageRoute(builder: (context) => ItemReviews(widget.itemId)));
                          //                     },
                          //                     child: const Text('See All', style: TextStyle(color: Constant.bgOrangeLite,
                          //                         fontWeight: FontWeight.bold, fontSize: 14),),
                          //                   ),
                          //                   const Icon(Icons.arrow_forward_ios, color: Constant.bgOrangeLite, size: 14,)
                          //                 ],
                          //               ),
                          //             ],
                          //           ),
                          //           Row(
                          //             children: [
                          //               Text(productReview.averageRating.toString(), style: TextStyle(
                          //                   fontWeight: FontWeight.bold, fontSize: 18)),
                          //               SizedBox(width: 10,),
                          //               RatingBar.readOnly(
                          //                 isHalfAllowed: true,
                          //                 filledIcon: Icons.star,
                          //                 emptyIcon: Icons.star_border,
                          //                 halfFilledIcon: Icons.star,
                          //                 initialRating: double.parse(productReview.averageRating.toString()),
                          //                 maxRating: 5,
                          //                 size: 18,
                          //               ),
                          //             ],
                          //           ),
                          //
                          //
                          //           ListView.builder(
                          //             shrinkWrap: true,
                          //             physics: NeverScrollableScrollPhysics(),
                          //             itemCount: productReview.reviews?.length,
                          //             itemBuilder: (context, index) {
                          //             return Column(
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: [
                          //
                          //                 SizedBox(height: 20,),
                          //                 Row(
                          //                   mainAxisAlignment: MainAxisAlignment.start,
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     CircleAvatar(
                          //                       child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                          //                     ),
                          //                     // ClipRRect(
                          //                     //   borderRadius: BorderRadius.circular(12),
                          //                     //   child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                          //                     // ),
                          //                     SizedBox(width: 20,),
                          //                     Column(
                          //                       crossAxisAlignment: CrossAxisAlignment.start,
                          //                       children: [
                          //                         Text(productReview.reviews![index].userName.toString(), style: TextStyle(fontWeight: FontWeight.bold,
                          //                             fontSize: 15
                          //                         ),),
                          //                         Row(
                          //                           children: [
                          //                             Icon(Icons.access_time, color: Constant.bgGrey, size: 15,),
                          //                             SizedBox(width: 5, ),
                          //                             Text(productReview.reviews![index].date.toString(), style: TextStyle(fontWeight: FontWeight.w400,
                          //                                 fontSize: 11,
                          //                                 color: Constant.bgGrey),),
                          //                           ],
                          //                         ),
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //                 SizedBox(height: 20,),
                          //                 RatingBar.readOnly(
                          //                   filledIcon: Icons.star,
                          //                   emptyIcon: Icons.star_border,
                          //                   initialRating: double.parse(productReview.reviews![index].rating.toString()),
                          //                   maxRating: 5,
                          //                   size: 18,
                          //                 ),
                          //                 SizedBox(height: 10,),
                          //                 Text(productReview.reviews![index].description.toString(),
                          //                   style: TextStyle(color: Constant.bgGrey),),
                          //                 SizedBox(height: 10,),
                          //                 productReview.reviews![index].media!.isEmpty
                          //                     ? SizedBox()
                          //                     : Row(
                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     SizedBox(
                          //                       height: 100,
                          //                       width: 260,
                          //                       child:
                          //                       ListView.builder(
                          //                         shrinkWrap: true,
                          //                         scrollDirection: Axis.horizontal,
                          //                         itemCount: productReview.reviews![index].media?.length ?? 0,
                          //                         itemBuilder: (context, mediaIndex) {
                          //                           String mediaUrl = productReview.reviews![index].media![mediaIndex].toString();
                          //
                          //                           // Check if the media is an image or a video
                          //                           bool isVideo = mediaUrl.endsWith('.mp4');
                          //
                          //                           return ClipRRect(
                          //                             borderRadius: BorderRadius.circular(12),
                          //                             child: Container(
                          //                               margin: const EdgeInsets.all(5),
                          //                               height: 80,
                          //                               width: 80,
                          //                               decoration: BoxDecoration(
                          //                                 borderRadius: BorderRadius.circular(10)
                          //                               ),
                          //                               child: isVideo
                          //                                   ? VideoPlayerWidget(videoUrl: mediaUrl)
                          //                                   : CachedNetworkImage(
                          //                                 imageUrl: mediaUrl,
                          //                                   placeholder: (context, url) => Shimmer.fromColors(
                          //                                     baseColor: Colors.grey[300]!,
                          //                                     highlightColor: Colors.grey[100]!,
                          //                                     child: Container(
                          //                                       // width: 60,
                          //                                       decoration: BoxDecoration(
                          //                                         color: Colors.white,
                          //                                       ),
                          //                                     ),
                          //                                   ),
                          //                                 errorWidget: (context, url, error) => Icon(Icons.error),
                          //                                 fit: BoxFit.cover,
                          //                               ),
                          //                             ),
                          //                           );
                          //                         },
                          //                       )/*ListView.builder(
                          //                         shrinkWrap: true,
                          //                         scrollDirection: Axis.horizontal,
                          //                         itemCount: productReview.reviews![index].media?.length,
                          //                         itemBuilder: (context, index) {
                          //                           return ClipRRect(
                          //                             borderRadius: BorderRadius.circular(12),
                          //                             child: Container(
                          //                               margin: const EdgeInsets.all(5),
                          //                               height: 80,
                          //                               width: 80,
                          //                               child: CachedNetworkImage(
                          //                                   imageUrl: productReview.reviews![index].media![index].toString()),
                          //                             ),
                          //                           );
                          //                         },),*/
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 // SizedBox(height: 10,),
                          //                 Row(
                          //                   mainAxisAlignment: MainAxisAlignment.end,
                          //                   children: [
                          //                     Row(
                          //                       children: [
                          //                         ThumbsUpAnimation(
                          //                           tapped: productReview.reviews![index].helpful!,
                          //                           onTap: () {
                          //                             context.read<ProductReviewBloc>().add(ReviewHelpfulTapEvent(productReview.reviews![index].productId.toString(), productReview.reviews![index].id.toString()));
                          //                             print('Thumbs up tapped!');
                          //                           },
                          //                         ),
                          //                       //   BlocBuilder<ReviewHelpfulBloc, ReviewHelpfulState>(
                          //                       //   bloc: reviewHelpfulBloc,
                          //                       //   builder: (context, state) {
                          //                       //     return
                          //                       //   },
                          //                       // ),
                          //                         const SizedBox(width: 5,),
                          //                         Text('Helpful (${productReview.reviews![index].helpfulVotesCount.toString()})', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                          //                         PopupMenuButton<SampleItem>(
                          //                           child: Container(
                          //                             height: 36,
                          //                             // width: 48,
                          //                             alignment: Alignment.centerRight,
                          //                             child: Icon(
                          //                               Icons.more_vert,
                          //                             ),
                          //                           ),
                          //                           initialValue: selectedItem,
                          //                           onSelected: (SampleItem item) {
                          //                             setState(() {
                          //                               selectedItem = item;
                          //                             });
                          //                           },
                          //                           itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                          //                             const PopupMenuItem<SampleItem>(
                          //                               value: SampleItem.itemOne,
                          //                               child: Text('Item 1'),
                          //                             ),
                          //                             const PopupMenuItem<SampleItem>(
                          //                               value: SampleItem.itemTwo,
                          //                               child: Text('Item ReviewHelpful'),
                          //                             ),
                          //                             const PopupMenuItem<SampleItem>(
                          //                               value: SampleItem.itemThree,
                          //                               child: Text('Item 3'),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ],
                          //                     )
                          //                   ],
                          //                 ),
                          //                 Divider(color: Color(0xff272727).withOpacity(.10)),
                          //               ],
                          //             );
                          //           },
                          //           ),
                          //         ],
                          //       );
                          //
                          //     }
                          //     if(state is ProductReviewError){
                          //       return Center(
                          //         child: Text(state.error),
                          //       );
                          //     }
                          //     return SizedBox();
                          //   },
                          // )

                        ],
                      ),]
                );
              }
              if(state is SingleProductError){
                return Center(
                  child: Text(state.error),
                );
              }
              return const SizedBox();
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
      bottomNavigationBar: BlocBuilder<SingleProductBloc, SingleProductState>(
        builder: (context, state) {
          if(state is SingleProductSuccess){
            var singleProduct = state.singleProductModel.product!;
            return BottomAppBar(
              surfaceTintColor: Colors.white,
              color: Colors.transparent,
              child: singleProduct.availableQuantity == 0
                  ? Btn('borderColor', height: 50, width: MediaQuery.of(context).size.width, linearColor1: Constant.bgBtnGrey, linearColor2: Constant.bgBtnGrey,
                name: 'Out Of Stock', callBack: () {
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 3,)), (route) => false,);
                  },)
                  :
              Btn('', height: 50, width: MediaQuery.of(context).size.width,
                image: state.singleProductModel.product!.cartloading == true ? null : 'assets/images/cart.png',
                linearColor1: Constant.bgLinearColor1,
                linearColor2: Constant.bgLinearColor2,
                fontSize: 16,
                name: state.singleProductModel.product!.cartloading == true ? '' : 'Add to Cart', callBack: state.singleProductModel.product!.cartloading == true
                    ? (){}
                    : (){
                  context.read<SingleProductBloc>().add(AddCartEvent(singleProduct.productId.toString(), singleProduct.counter.toString(),
                      singleProduct.salePrice != null
                          ? singleProduct.salePrice.toString()
                          : singleProduct.regularPrice.toString() ));
                },
                child: state.singleProductModel.product!.cartloading == true ? CircularProgressIndicator(color: Colors.white,) : null,
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
