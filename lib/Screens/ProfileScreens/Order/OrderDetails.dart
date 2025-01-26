import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/NavBar.dart';

import '../../../Constant.dart';
import '../../../Model/OrderDetailModel.dart';
import '../../../Widget/Btn.dart';
import '../../../Widget/Btn2.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class OrderDetails extends StatefulWidget {
  String orderId;
  Color color;
  OrderDetails(this. orderId, this.color, {super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderDetailModel? orderDetailModel;

  // Future<void> fetchOrderDetails(String orderId) async {
  //   const String apiUrl = 'https://urlsdemo.online/nexa/api/single-order-details';
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       h
  //       body: {
  //         'order_id': widget.orderId, // Replace with the actual key for order_id
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Parse the response body
  //       final Map<String, dynamic> data = jsonDecode(response.body);
  //       print('Order Details: $data');
  //     } else {
  //       print('Failed to load order details. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    // fetchOrderDetails(widget.orderId);
  }

  void fetchData() async{
     orderDetailModel = await Api.orderDetailsApi(widget.orderId);
     setState(() {

     });
     print(orderDetailModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/profile/back.png',
                height: 30,
                width: 30,
              )),
        ),
        title: const Text('Order Details',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
      ),
      body: orderDetailModel == null ? Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Constant.bgOrangeLite,
          size: 40,
        ),) : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Constant.bgOrangeLite),
                    ),
                    child: Column(
                      children: [
                        Container(height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFFFFA31F).withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order no:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                    orderDetailModel!.orderInformation!.orderId.toString()  ,                 style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
               //     orderDetailModel!.orderInformation!.amount.toString()//
          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       'Tracking number: ',
                              //       style: TextStyle(
                              //         color: Constant.textGrey,
                              //         fontWeight: FontWeight.w400,
                              //         fontSize: 14,
                              //       ),
                              //     ),
                              //     Text(
                              //       'IW3475453455',
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 14,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quantity: ',
                                    style: TextStyle(
                                      color: Constant.textGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    orderDetailModel!.orderInformation!.quantity.toString()  ,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Status: ',
                                    style: TextStyle(
                                      color: Constant.textGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                      orderDetailModel!.orderInformation!.orderStatus.toString()   ,
                                    style: TextStyle(
                                      color: widget.color,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Amount: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    orderDetailModel!.orderInformation!.totalAmount.toString(),
                                    style: TextStyle(
                                      color: Constant.bgOrangeLite,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                thickness: 1,
                                color: Constant.textGrey.withOpacity(.1),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Shipping Address',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18)),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Service Type',
                                    style: TextStyle(
                                      color: Constant.textGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    orderDetailModel!.shippingAddress!.serviceType.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date: ',
                                    style: TextStyle(
                                      color: Constant.textGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    orderDetailModel!.shippingAddress!.shipingDate.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       'Time:',
                              //       style: TextStyle(
                              //         color: Constant.textGrey,
                              //         fontWeight: FontWeight.w400,
                              //         fontSize: 14,
                              //       ),
                              //     ),
                              //     Text(
                              //       '12:00PM',
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 14,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(height: 10),
                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Deliver To',
                                    style: TextStyle(
                                      color: Constant.textGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: Align(alignment: Alignment.topRight,
                                      child: Text(
                                  "${orderDetailModel!.shippingAddress!.address.toString()}, ${orderDetailModel!.shippingAddress!.city.toString()}, ${ orderDetailModel!.shippingAddress!.country.toString()}, ${ orderDetailModel!.shippingAddress!.state.toString()} ",
                                      overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Constant.bgOrangeLite),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                    orderDetailModel!.orderInformation!.orderId.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount:orderDetailModel!.orderItemInformation!.length,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = orderDetailModel!.orderItemInformation![index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              // Adjust padding for spacing between items
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Divider(
                                    thickness: 1,
                                    color: Constant.textGrey.withOpacity(0.1),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        // Image border
                                        child: SizedBox.fromSize(
                                          size: Size.fromRadius(40),
                                          // Image radius
                                          child: CachedNetworkImage(imageUrl:
                                              data.featureImage.toString(),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                            data.productName.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: '\$ ${   data.salePrice != null ? data.salePrice.toString() : data.regularPrice.toString()} ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: '\$ ${   data.regularPrice.toString()} ',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16,
                                                            color:
                                                                Constant.textGrey,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  'x${ data.totalQuantity.toString()}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            )
                                            //
                                            // Text('Shipping Address',
                                            //     style: TextStyle(
                                            //         fontWeight: FontWeight.w600, fontSize: 18)),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                          color: Constant.textGrey.withOpacity(0.1),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                color: Constant.textGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '\$ ${orderDetailModel!.orderInformation!.subTotal.toString()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Tax',
                        //       style: TextStyle(
                        //         color: Constant.textGrey,
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //     Text(
                        //       '\$5.00',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w500,
                        //         fontSize: 14,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discount',
                              style: TextStyle(
                                color: Constant.textGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '\$${orderDetailModel!.orderInformation!.couponDiscount.toString()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery',
                              style: TextStyle(
                                color: Constant.textGrey,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'FREE',
                              style: TextStyle(
                                color: Color(0xFF53B175),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(
                          thickness: 1,
                          color: Constant.textGrey.withOpacity(0.1),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '\$${orderDetailModel!.orderInformation!.totalAmount.toString()}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Constant.bgOrangeLite),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payments Details',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            // Text(
                            //   '\$10.00',
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w500,
                            //     fontSize: 14,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Constant.textGrey.withOpacity(0.1),
                      ),
                     
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment method',
                                  style: TextStyle(
                                    color: Constant.textGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Credit card',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment Date',
                                  style: TextStyle(
                                    color: Constant.textGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '25 July, 2024',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total amount',
                                  style: TextStyle(
                                    color: Constant.textGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '\$195.98',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),SizedBox(height: 15,),
                Btn2(height: 50, width: MediaQuery.of(context).size.width,
                    name: 'Track Order', callBack: (){

                    }),
                SizedBox(height: 10,),
                // SizedBox(
                //   height: 50,
                //   width: MediaQuery.of(context).size.width,
                //   child: ElevatedButton(
                //     onPressed: isLoading
                //         ? null
                //         : () async {
                //       final response = await Api.downloadInvoiceApi(widget.orderId);
                //       if (response != null && response.pdfUrl != null) {
                //         await downloadAndOpenPdf(response.pdfUrl!);
                //       } else {
                //         print('Failed to get PDF URL');
                //       }
                //     },
                //     child: isLoading
                //         ? Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         CircularProgressIndicator(
                //           value: progress,
                //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                //         ),
                //         SizedBox(width: 10),
                //         Text(
                //           '${(progress * 100).toStringAsFixed(0)}%',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ],
                //     )
                //         : Text('Download Invoice'),
                //   ),
                // ),
                Btn2(height: 50, width: MediaQuery.of(context).size.width,
                    name: 'Download Invoice', callBack: () async{
                      await downloadAndOpenPdf(orderDetailModel!.pdfUrl.toString());


                    }),
                SizedBox(height: 10,),
                Btn('', height: 50, width: MediaQuery.of(context).size.width,
                    linearColor1: Constant.bgLinearColor1,
                    linearColor2: Constant.bgLinearColor2,
                    name: 'Continue Shopping', callBack: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 0,)), (route) => false,);
                      }
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // download with dio
  Future<void> downloadAndOpenPdf(String pdfUrl) async {
    try {
      // Get the directory to store the downloaded PDF
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/invoice_${widget.orderId}.pdf";

      // Download the PDF file
      final response = await Dio().download(pdfUrl, filePath);

      print('filePath:::: $filePath');

      if (response.statusCode == 200) {
        // Open the downloaded PDF
        OpenFile.open(filePath);
      } else {
        // Handle download failure
        print('Failed to download PDF');
      }
    } catch (e) {
      print('Error downloading or opening PDF: $e');
    }
  }

  // download with http
  // Future<void> downloadAndOpenPdf(String pdfUrl) async {
  //   try {
  //     // Get the directory to store the downloaded PDF
  //     final dir = await getApplicationDocumentsDirectory();
  //     final filePath = "${dir.path}/invoice_${widget.orderId}.pdf";
  //
  //     // Download the PDF file
  //     final response = await http.get(Uri.parse(pdfUrl));
  //
  //     if (response.statusCode == 200) {
  //       // Write the PDF file to the local file system
  //       final file = File(filePath);
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       // Open the downloaded PDF
  //       OpenFile.open(filePath);
  //     } else {
  //       print('Failed to download PDF');
  //     }
  //   } catch (e) {
  //     print('Error downloading or opening PDF: $e');
  //   }
  // }


  // download with progress animation

  // double progress = 0.0;
  // bool isLoading = false;
  //
  // Future<void> downloadAndOpenPdf(String pdfUrl) async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //       progress = 0.0;
  //     });
  //
  //     // Get the directory to store the downloaded PDF
  //     final dir = await getApplicationDocumentsDirectory();
  //     final filePath = "${dir.path}/invoice_${widget.orderId}.pdf";
  //
  //     // Create the file where the PDF will be saved
  //     final file = File(filePath);
  //
  //     // Start the HTTP request to download the PDF
  //     final request = http.Request('GET', Uri.parse(pdfUrl));
  //     final response = await request.send();
  //
  //     final totalBytes = response.contentLength ?? 0;
  //     int downloadedBytes = 0;
  //
  //     // Create a file sink to write the response data
  //     final fileSink = file.openWrite();
  //
  //     // Listen to the response stream
  //     response.stream.listen(
  //           (chunk) {
  //         downloadedBytes += chunk.length;
  //         fileSink.add(chunk);
  //
  //         // Update progress
  //         setState(() {
  //           progress = downloadedBytes / totalBytes;
  //         });
  //       },
  //       onDone: () async {
  //         await fileSink.close();
  //         setState(() {
  //           isLoading = false;
  //           progress = 0.0;
  //         });
  //
  //         // Open the downloaded PDF
  //         OpenFile.open(filePath);
  //       },
  //       onError: (error) {
  //         setState(() {
  //           isLoading = false;
  //           progress = 0.0;
  //         });
  //         print('Error downloading PDF: $error');
  //       },
  //       cancelOnError: true,
  //     );
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       progress = 0.0;
  //     });
  //     print('Error downloading or opening PDF: $e');
  //   }
  // }

}
