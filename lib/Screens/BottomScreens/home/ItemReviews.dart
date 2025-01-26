import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Screens/AddReview.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Bloc/ProductReviewBloc/product_review_bloc.dart';
import '../../../Bloc/SingleProductBloc/single_product_bloc.dart';
import '../../../Constant.dart';
import '../../../Widget/ThumbsUpAnimation.dart';
import '../../../Widget/VideoPlayer.dart';
import 'ProductDetails.dart';

class ItemReviews extends StatefulWidget {
  String itemId;
  ItemReviews(this.itemId, {super.key});

  @override
  State<ItemReviews> createState() => _ItemReviewsState();
}

class _ItemReviewsState extends State<ItemReviews> {
  SampleItem? selectedItem;

  @override
  void initState() {
    context.read<ProductReviewBloc>().add(ProductReviewLoadEvent(widget.itemId.toString()));
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

      context.read<SingleProductBloc>().add(SingleProductRefreshEvent(widget.itemId.toString()));
      return true;
    },
      child: Scaffold(
          appBar: AppBar(
            leadingWidth: 80,
            leading: InkWell(
              onTap: (){
                context.read<SingleProductBloc>().add(SingleProductRefreshEvent(widget.itemId.toString()));
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/profile/back.png', height: 30, width: 30,),
              ),
            ),
            title: const Text('Item Reviews', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BlocBuilder<ProductReviewBloc, ProductReviewState>(
              builder: (context, state) {
                if(state is ProductReviewLoading){
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Constant.bgOrangeLite,
                      size: 40,
                    ),);
                }
                if(state is ProductReviewSuccess){
                  var productReview = state.productReviewModel.reviews;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(state.productReviewModel.averageRating.toString(), style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(width: 10,),
                              RatingBar.readOnly(
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border,
                                initialRating: double.parse(state.productReviewModel.averageRating.toString()),
                                maxRating: 5,
                                size: 18,
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddReview(widget.itemId, '')));
                              },
                              child: Image.asset('assets/images/addReviewBtn.png', height: 35, width: 125,))
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.productReviewModel.reviews?.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.network(productReview![index].userImage.toString()/*'assets/profile/my account.png'*/, height: 40, width: 40,)),
                                    ),
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(12),
                                    //   child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                                    // ),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(productReview![index].userName.toString()/*'Ronald Richards'*/, style: TextStyle(fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, color: Constant.bgGrey, size: 15,),
                                            SizedBox(width: 5, ),
                                            Text(productReview![index].date.toString()/*'13 June, 2024'*/, style: TextStyle(fontWeight: FontWeight.w400,
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
                                  initialRating: double.parse(productReview![index].rating.toString()),
                                  maxRating: 5,
                                  size: 18,
                                ),
                                SizedBox(height: 10,),
                                Text(productReview![index].description.toString()/*'Lorem ipsum dolor sit amet, consectetur adipiscing elit, Pellentesque malesuada eget vitae Lorem ipsum dolor sit amet, consectetur'*/,
                                  style: TextStyle(color: Constant.bgGrey),),
                                SizedBox(height: 10,),
                                productReview[index].media!.isEmpty
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
                                          itemCount: productReview![index].media?.length ?? 0,
                                          itemBuilder: (context, mediaIndex) {
                                            String mediaUrl = productReview[index].media![mediaIndex].toString();
                        
                                            // Check if the media is an image or a video
                                            bool isVideo = mediaUrl.endsWith('.mp4');
                        
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
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
                                        )/*ListView.builder(
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
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     SizedBox(
                                //       height: 100,
                                //       width: 260,
                                //       child: ListView.builder(
                                //         shrinkWrap: true,
                                //         scrollDirection: Axis.horizontal,
                                //         itemCount: 3,
                                //         itemBuilder: (context, index) {
                                //           return ClipRRect(
                                //             borderRadius: BorderRadius.circular(12),
                                //             child: Container(
                                //                 margin: const EdgeInsets.all(5),
                                //                 height: 80,
                                //                 width: 80,
                                //                 child: Image.asset('assets/home/zoomlenc.png')
                                //             ),
                                //           );
                                //         },),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        ThumbsUpAnimation(
                                          tapped: productReview[index].helpful!,
                                          onTap: () {
                                            context.read<ProductReviewBloc>().add(ReviewHelpfulTapEvent(productReview[index].productId.toString(), productReview[index].id.toString()));
                                            print('Thumbs up tapped!');
                                          },
                                        ),
                                        const SizedBox(width: 5,),
                                        Text('Helpful (${productReview[index].helpfulVotesCount.toString()})', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
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
                                        //       child: Text('Item 2'),
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
                          },),
                      ),

                      // // SizedBox(height: 30,),
                      // // Row(
                      // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // //   children: [
                      // //     Row(
                      // //       children: [
                      // //         const Text('4.8', style: TextStyle(
                      // //             fontWeight: FontWeight.bold, fontSize: 18)),
                      // //         const SizedBox(width: 10,),
                      // //         RatingBar.readOnly(
                      // //           filledIcon: Icons.star,
                      // //           emptyIcon: Icons.star_border,
                      // //           initialRating: 4,
                      // //           maxRating: 5,
                      // //           size: 18,
                      // //         ),
                      // //       ],
                      // //     ),
                      // //     Image.asset('assets/images/addReviewBtn.png', height: 35, width: 125,)
                      // //   ],
                      // // ),
                      // SizedBox(height: 20,),
                      // Row(
                      //   children: [
                      //     CircleAvatar(
                      //       child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                      //     ),
                      //     // ClipRRect(
                      //     //   borderRadius: BorderRadius.circular(12),
                      //     //   child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                      //     // ),
                      //     SizedBox(width: 20,),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text('Ronald Richards', style: TextStyle(fontWeight: FontWeight.bold,
                      //             fontSize: 15
                      //         ),),
                      //         Row(
                      //           children: [
                      //             Icon(Icons.access_time, color: Constant.bgGrey, size: 15,),
                      //             SizedBox(width: 5, ),
                      //             Text('13 June, 2024', style: TextStyle(fontWeight: FontWeight.w400,
                      //                 fontSize: 11,
                      //                 color: Constant.bgGrey),),
                      //           ],
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // ),
                      // SizedBox(height: 20,),
                      // RatingBar.readOnly(
                      //   filledIcon: Icons.star,
                      //   emptyIcon: Icons.star_border,
                      //   initialRating: 4,
                      //   maxRating: 5,
                      //   size: 18,
                      // ),
                      // SizedBox(height: 10,),
                      // Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, Pellentesque malesuada eget vitae Lorem ipsum dolor sit amet, consectetur',
                      //   style: TextStyle(color: Constant.bgGrey),),
                      // SizedBox(height: 10,),
                      // // Row(
                      // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // //   children: [
                      // //     SizedBox(
                      // //       height: 100,
                      // //       width: 260,
                      // //       child: ListView.builder(
                      // //         shrinkWrap: true,
                      // //         scrollDirection: Axis.horizontal,
                      // //         itemCount: 3,
                      // //         itemBuilder: (context, index) {
                      // //           return ClipRRect(
                      // //             borderRadius: BorderRadius.circular(12),
                      // //             child: Container(
                      // //                 margin: const EdgeInsets.all(5),
                      // //                 height: 80,
                      // //                 width: 80,
                      // //                 child: Image.asset('assets/home/zoomlenc.png')
                      // //             ),
                      // //           );
                      // //         },),
                      // //     ),
                      // //   ],
                      // // ),
                      // // SizedBox(height: 10,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         ThumbsUpAnimation(
                      //           onTap: () {
                      //             print('Thumbs up tapped!');
                      //           },
                      //         ),
                      //         const SizedBox(width: 5,),
                      //         const Text('Helpful (2)', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                      //         PopupMenuButton<SampleItem>(
                      //           child: Container(
                      //             height: 36,
                      //             // width: 48,
                      //             alignment: Alignment.centerRight,
                      //             child: Icon(
                      //               Icons.more_vert,
                      //             ),
                      //           ),
                      //           initialValue: selectedItem,
                      //           onSelected: (SampleItem item) {
                      //             setState(() {
                      //               selectedItem = item;
                      //             });
                      //           },
                      //           itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                      //             const PopupMenuItem<SampleItem>(
                      //               value: SampleItem.itemOne,
                      //               child: Text('Item 1'),
                      //             ),
                      //             const PopupMenuItem<SampleItem>(
                      //               value: SampleItem.itemTwo,
                      //               child: Text('Item 2'),
                      //             ),
                      //             const PopupMenuItem<SampleItem>(
                      //               value: SampleItem.itemThree,
                      //               child: Text('Item 3'),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // ),
                      // Divider(color: Color(0xff272727).withOpacity(.10)),
                      // SizedBox(height: 20,),
                      // Row(
                      //   children: [
                      //     CircleAvatar(
                      //       child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                      //     ),
                      //     // ClipRRect(
                      //     //   borderRadius: BorderRadius.circular(12),
                      //     //   child: Image.asset('assets/profile/my account.png', height: 40, width: 40,),
                      //     // ),
                      //     SizedBox(width: 20,),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text('Ronald Richards', style: TextStyle(fontWeight: FontWeight.bold,
                      //             fontSize: 15
                      //         ),),
                      //         Row(
                      //           children: [
                      //             Icon(Icons.access_time, color: Constant.bgGrey, size: 15,),
                      //             SizedBox(width: 5, ),
                      //             Text('13 June, 2024', style: TextStyle(fontWeight: FontWeight.w400,
                      //                 fontSize: 11,
                      //                 color: Constant.bgGrey),),
                      //           ],
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // ),
                      // SizedBox(height: 20,),
                      // RatingBar.readOnly(
                      //   filledIcon: Icons.star,
                      //   emptyIcon: Icons.star_border,
                      //   initialRating: 4,
                      //   maxRating: 5,
                      //   size: 18,
                      // ),
                      // SizedBox(height: 10,),
                      // Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, Pellentesque malesuada eget vitae Lorem ipsum dolor sit amet, consectetur',
                      //   style: TextStyle(color: Constant.bgGrey),),
                      // SizedBox(height: 10,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //       height: 100,
                      //       width: 260,
                      //       child: ListView.builder(
                      //         shrinkWrap: true,
                      //         scrollDirection: Axis.horizontal,
                      //         itemCount: 3,
                      //         itemBuilder: (context, index) {
                      //           return ClipRRect(
                      //             borderRadius: BorderRadius.circular(12),
                      //             child: Container(
                      //                 margin: const EdgeInsets.all(5),
                      //                 height: 80,
                      //                 width: 80,
                      //                 child: Image.asset('assets/home/zoomlenc.png')
                      //             ),
                      //           );
                      //         },),
                      //     ),
                      //   ],
                      // ),
                      // // SizedBox(height: 5,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         ThumbsUpAnimation(
                      //           onTap: () {
                      //             print('Thumbs up tapped!');
                      //           },
                      //         ),
                      //         const SizedBox(width: 5,),
                      //         const Text('Helpful (2)', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                      //         PopupMenuButton<SampleItem>(
                      //           child: Container(
                      //             height: 36,
                      //             // width: 48,
                      //             alignment: Alignment.centerRight,
                      //             child: Icon(
                      //               Icons.more_vert,
                      //             ),
                      //           ),
                      //           initialValue: selectedItem,
                      //           onSelected: (SampleItem item) {
                      //             setState(() {
                      //               selectedItem = item;
                      //             });
                      //           },
                      //           itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                      //             const PopupMenuItem<SampleItem>(
                      //               value: SampleItem.itemOne,
                      //               child: Text('Item 1'),
                      //             ),
                      //             const PopupMenuItem<SampleItem>(
                      //               value: SampleItem.itemTwo,
                      //               child: Text('Item 2'),
                      //             ),
                      //             const PopupMenuItem<SampleItem>(
                      //               value: SampleItem.itemThree,
                      //               child: Text('Item 3'),
                      //             ),
                      //           ],
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // )
                    ],
                  );
                }
                if(state is ProductReviewError){
                  return Center(
                      child: Text(state.error)
                  );
                }
                return SizedBox();
              },
            ),
          )
      ),
    );

  }
}
