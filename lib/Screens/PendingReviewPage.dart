import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/Model/OrderListModel.dart';
import 'package:nexa/Screens/AddReview.dart';
import 'package:nexa/Widget/Btn.dart';

class Pendingreviewpage extends StatefulWidget {
  List<ProductsToReview>? productsToReview;
  Pendingreviewpage(this.productsToReview, {super.key});

  @override
  State<Pendingreviewpage> createState() => _PendingreviewpageState();
}

class _PendingreviewpageState extends State<Pendingreviewpage> {
  @override
  Widget build(BuildContext context) {
    var data = widget.productsToReview;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/profile/back.png',
              height: 30,
              width: 30,
            ),
          ),
        ),
        title: const Text(
          'Pending Reviews',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 95,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Constant.bgBlue,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(imageUrl: data![index].featureImage.toString())),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width*.60,
                                child: Text(data![index].productName.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),),
                            SizedBox(
                              width: MediaQuery.of(context).size.width*.60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$${data[index].purchasePrice.toString() }', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  // orange button
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddReview(data[index].productId.toString(), 'order')));
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Constant
                                                .bgOrangeLite),
                                        borderRadius:
                                        BorderRadius.circular(
                                            5),
                                        gradient:
                                        const LinearGradient(
                                          colors: [
                                            Constant.bgLinearColor1,
                                            Constant.bgLinearColor2
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Text('Review',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
            },
            ),
          ),
        ],
      ),
    );
  }
}
