

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../Bloc/AllWishlistBloc/all_wishlist_bloc.dart';
import '../../Constant.dart';
import 'package:nexa/Screens/BottomScreens/home/ProductDetails.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    context.read<AllWishlistBloc>().add(WishlistRefreshEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 5,
        title: const Text('Wishlist', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: Image.asset('assets/navbar/sort.png', height: 40, width: 40,),
        //   )
        // ],
      ),
      body: RefreshIndicator(
        color: Constant.bgOrange,
        onRefresh: () async{
          context.read<AllWishlistBloc>().add(WishlistLogoutEvent());
          context.read<AllWishlistBloc>().add(WishlistRefreshEvent());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocBuilder<AllWishlistBloc, AllWishlistState>(
            builder: (context, state) {
              if(state is AllWishlistLoading){
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Constant.bgOrangeLite,
                    size: 40,
                  ),);
              }
              if(state is AllWishlistSuccess){
                var wishlistData = state.allWishlistModel.wishlistProducts;
                return wishlistData!.isEmpty
                    ? Center(
                  child: Image.asset('assets/home/empty_wishlist.png', width: 250,),
                )
                    : ListView(
                  controller: listScrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 15,),
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              // controller: listScrollController,
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, crossAxisSpacing: 15,
                                  mainAxisExtent: 240, mainAxisSpacing: 10),
                              itemCount: wishlistData?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails('wishlist', wishlistData[index].id.toString())));
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
                                                    imageUrl: wishlistData![index].featureImage.toString(),
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
                                                    height: double.infinity,)
                                              ),
                                            ),
                                            Positioned(
                                                top: 10,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: state.allWishlistModel.wishlistProducts![index].loadinglike == true
                                                      ? (){}
                                                      : (){
                                                    context.read<AllWishlistBloc>().add(RemoveWishlistEvent(state.allWishlistModel.wishlistProducts![index]));
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(30)
                                                    ),
                                                    child: state.allWishlistModel.wishlistProducts![index].loadinglike == true
                                                        ? Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1,),
                                                    )
                                                        : Icon(Icons.favorite_outlined,size: 15, color: Constant.bgOrangeLite,),
                                                  ),
                                                )
                                            ),
                                            Positioned(
                                                bottom: 10,
                                                right: 10,
                                                child: InkWell(
                                                  onTap: state.allWishlistModel.wishlistProducts![index].loadingcart == true
                                                      ? (){}
                                                      : (){
                                                    context.read<AllWishlistBloc>().add(AddToCartWishlistEvent(state.allWishlistModel.wishlistProducts![index]));
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(30)
                                                    ),
                                                    child: state.allWishlistModel.wishlistProducts![index].loadingcart == true
                                                        ? Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: CircularProgressIndicator(color: Constant.bgOrangeLite, strokeWidth: 1, ),
                                                    )
                                                        : Image.asset('assets/home/cart.png'),
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(wishlistData[index].productName.toString(), maxLines: 2, overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.bold
                                          ),),
                                        Row(
                                          children: [
                                            Text(
                                              /*wishlistData[index].productType == 'variable'
                                                  ? wishlistData[index].productDetails!.salePrice == null
                                                      ? wishlistData[index].productDetails!.regularPrice.toString()
                                                      : wishlistData[index].productDetails!.salePrice.toString()
                                                  :*/ wishlistData[index].salePrice == null
                                                ? '\$${wishlistData[index].regularPrice.toString()}'
                                                : '\$${wishlistData[index].salePrice.toString()}'
                                              , style: const TextStyle(
                                                  fontSize: 18, fontWeight: FontWeight.w700, color: Constant.bgOrangeLite
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
                          ],
                        ),
                      ],
                    );
              }
              if(state is AllWishlistError){
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
          tooltip: 'Scroll to Top',
          onPressed: () {
            if(listScrollController.hasClients){
              final position = listScrollController.position.minScrollExtent;
              listScrollController.animateTo(
                  position,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeOut);
            }
          },
          isExtended: true,
          child: Icon(Icons.keyboard_arrow_up, color: Constant.bgOrangeLite,),
        ),
      ),
    );
  }
}
