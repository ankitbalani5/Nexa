
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/OrderListBloc/order_list_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/NavBar.dart';
import 'package:nexa/Screens/PendingReviewPage.dart';
import 'package:nexa/Screens/ProfileScreens/Order/TrackOrder.dart';

import '../../../Bloc/ReOrderBloc/re_order_bloc.dart';
import 'OrderDetails.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool allReorder = false;
  bool completeReorder = false;
  @override
  void initState() {
    context.read<OrderListBloc>().add(OrderListLoadEvent(status: 'all'));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 8,
        child: Scaffold(
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
            title: const Text('My Order',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
            bottom: const TabBar(
              isScrollable: true,

              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              indicatorColor: Constant.bgOrangeLite,
              // Underline color
              indicatorWeight: 4.0,
              // Underline thickness
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              // Bold text for selected tab
              unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
              labelColor: Constant.bgOrangeLite,
              // Selected tab color
              // unselectedLabelColor: Colors.grey, // Unselected tab color
              tabs: [
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'To Pay',
                ),
                Tab(
                  text: 'To Ship',
                ),
                Tab(
                  text: 'To Receive',
                ),
                Tab(
                  text: 'Return/Refund',
                ),
                Tab(
                  text: 'Completed',
                ),
                Tab(text: 'To Review'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              allBuild(),
              toPayBuild(),
              toShipBuild(),
              toReceiveBuild(),
              refundBuild(),
              completedBuild(),
              toReviewBuild(),
              cancelledBuild()
            ],
          ),
        ));
  }

  // 'pending','confirm','processing','dispatch','delivered','complete','cancelled','return', "review"
  //
  // To pay : 'pending','confirm','processing','dispatch','delivered'
  // To ship : 'pending','confirm','processing'
  // To receive : 'pending','confirm','processing','dispatch'
  // Return/Refund : 'return'
  // Completed : 'complete'
  // To review : 'review'
  // Cancelled : 'cancelled'
  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Color(0xFFFFC107); // Yellow
      case 'Confirm':
        return Color(0xFF007BFF); // Blue
      case 'Processing':
        return Color(0xFFFFA500); // Orange
      case 'Dispatch':
        return Color(0xFF6F42C1); // Purple
      case 'Delivered':
        return Color(0xFF28A745); // Green
      case 'Complete':
        return Color(0xFF155724); // Dark Green
      case 'Cancelled':
        return Color(0xFFDC3545); // Red
      case 'Return':
        return Color(0xFFFF6B6B); // Light Red
      default:
        return Colors.grey; // Default color for unknown status
    }
  }
  Widget allBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(child: LoadingAnimationWidget.fourRotatingDots(color: Constant.bgOrangeLite, size: 40))
          /*Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          )*/;
        }
        if (state is OrderListSuccess) {
          return state.orderListModel.orders!.isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.orderListModel.orders?.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = state.orderListModel.orders![index];
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      // height: 160,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border:
                          Border.all(color: Constant.bgOrangeLite)),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                          color: Constant.bgGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                          color: Constant.bgGrey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      'IW3475453455',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'quantity: ',
                                          style: TextStyle(
                                              color: Constant.bgGrey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            /*color: Constant.bgGrey,*/
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                              color:
                                              Constant.bgOrangeLite,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                          color: getStatusColor(status),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // white btn
                                        status == 'Cancelled' || status == 'Dispatch'
                                            ? SizedBox()
                                            : InkWell(onTap: (){
                                          if (  status == 'Delivered' || status == 'Complete' ) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(  data.id.toString(), getStatusColor(status))));
                                          }else if (status == 'Pending' || status == 'Processing' || status == 'Confirm'){
                                            context.read<OrderListBloc>().add(CancelOrderEvent(context, data.id.toString()));
                                          }
                                        },
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Constant
                                                      .bgOrangeLite,
                                                ),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(5)),
                                            child: Center(
                                                child: Text(
                                                  status == 'Delivered' || status == 'Complete'
                                                      ? 'Details'
                                                      : status == 'Pending' || status == 'Processing' || status == 'Confirm' ? 'Cancel' : '',
                                                  style: TextStyle(
                                                      color: Constant
                                                          .bgOrangeLite,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 12),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        // orange btn
                                        BlocListener<ReOrderBloc, ReOrderState>(
                                          listenWhen: (previous, current) => allReorder == true,
                                          listener: (context, state) {
                                            if(state is ReOrderSuccess){
                                              allReorder = false;
                                              Fluttertoast.showToast(msg: state.reOrderModel.message.toString(), backgroundColor: Constant.bgOrangeLite);
                                            }
                                          },
                                          child: InkWell(
                                            onTap: () {
                                              print(
                                                state.orderListModel.orders
                                                    ?.length,
                                              );
                                              // 'pending','confirm','processing','dispatch','delivered','complete','cancelled','return', "review"
                                              //
                                              if ( status == 'Dispatch' ||status == 'Processing' ||
                                                  status == 'Pending' || status == 'Confirm' || status== 'Cancelled') {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderDetails(  data.id.toString(), getStatusColor(status))));
                                              }
                                              if(status == 'Delivered' ||
                                                  status == 'Complete'){
                                                allReorder = true;
                                                context.read<ReOrderBloc>().add(ReOrderRefreshEvent(data.id.toString()));
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Constant
                                                        .bgOrangeLite,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      5),
                                                  gradient:
                                                  const LinearGradient(
                                                      colors: [
                                                        Constant
                                                            .bgLinearColor1,
                                                        Constant
                                                            .bgLinearColor2
                                                      ])),
                                              child: Center(
                                                  child: Text(
                                                    status == 'Processing' ||
                                                        status == 'Pending' || status == 'Confirm'
                                                        ? 'Details'
                                                        : status == 'Delivered' ||
                                                        // status ==
                                                        //     'Confirm' ||
                                                        status ==
                                                            'Complete'
                                                        ? 'Re-Order'
                                                        : 'Details',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 12),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        // Btn('', height: 50, width: 100, linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2, name: 'Re-Order', callBack: (){
                                        //
                                        // })
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }

  Widget toPayBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          );
        }
        if (state is OrderListSuccess) {
          return state.orderListModel.orders!
              .where((e) =>
          e.orderStatus == 'processing' ||
              e.orderStatus == 'pending' ||
              e.orderStatus == 'confirm' ||
              e.orderStatus == 'dispatch' ||
              e.orderStatus == 'delivered')
              .toList()
              .isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.orderListModel.orders
                ?.where((e) =>
            e.orderStatus == 'processing' ||
                e.orderStatus == 'pending' ||
                e.orderStatus == 'confirm' ||
                e.orderStatus == 'dispatch' ||
                e.orderStatus == 'delivered') // Filter orders by status
                .toList()
                .length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Filter the orders based on 'processing' status
              var filteredOrders = state.orderListModel.orders
                  ?.where((e) =>
              e.orderStatus == 'processing' ||
                  e.orderStatus == 'pending' ||
                  e.orderStatus == 'confirm' ||
                  e.orderStatus == 'dispatch' ||
                  e.orderStatus == 'delivered')
                  .toList();

              // Access the order from the filtered list
              var data = filteredOrders![index];

              // Determine the order status
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constant.bgOrangeLite),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'IW3475453455',
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
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            color: Constant.bgGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                            color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: getStatusColor(status),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // White button
                                        status == 'Cancelled'|| status == 'Dispatch'
                                            ? SizedBox()
                                            : InkWell(
                                          onTap: () {
                                          if (status == 'Delivered' || status == 'Complete') {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(  data.id.toString(), getStatusColor(status))                    ),
                                            );
                                          }else if (status == 'Pending' || status == 'Processing' || status == 'Confirm'){
                                            context.read<OrderListBloc>().add(CancelOrderEvent(context, data.id.toString()));
                                          }
                                          // if(status == 'Confirm')
                                        },
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Constant
                                                      .bgOrangeLite),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                status == 'Delivered' || status == 'Complete'
                                                    ? 'Details'
                                                    : 'Cancel',
                                                style: TextStyle(
                                                  color: Constant
                                                      .bgOrangeLite,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Orange button
                                        InkWell(
                                          onTap: () {
                                            if (status == 'Processing' ||
                                                status == 'Dispatch' ||
                                                status == 'Pending'||
                                                status == 'Confirm') {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetails(  data.id.toString() , getStatusColor(status))                                              ),
                                              );
                                            }
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
                                              child: Text(
                                                status == 'Processing' ||
                                                    status ==
                                                        'Pending'
                                                    ? 'Details'
                                                    : status ==
                                                    'Delivered'
                                                    ? 'Re-Order'
                                                    : 'Details',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }

  Widget toShipBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          );
        }
        if (state is OrderListSuccess) {
          return state.orderListModel.orders!
              .where((e) =>
          e.orderStatus == 'processing' ||
              e.orderStatus == 'pending' ||
              e.orderStatus == 'confirm')
              .toList()
              .isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.orderListModel.orders
                ?.where((e) =>
            e.orderStatus == 'processing' ||
                e.orderStatus == 'pending' ||
                e.orderStatus == 'confirm')// Filter orders by status
                .toList()
                .length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Filter the orders based on 'processing' status
              var filteredOrders = state.orderListModel.orders
                  ?.where((e) =>
              e.orderStatus == 'processing' ||
                  e.orderStatus == 'pending' ||
                  e.orderStatus == 'confirm')
                  .toList();

              // Access the order from the filtered list
              var data = filteredOrders![index];

              // Determine the order status
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';


              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constant.bgOrangeLite),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'IW3475453455',
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
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            color: Constant.bgGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                            color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: getStatusColor(status),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // White button
                                        status == 'Cancelled' || status == 'Dispatch'
                                            ? SizedBox()
                                            : InkWell(      onTap: () {
                                          if (status == 'Complete' || status == 'Delivered') {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(  data.id.toString(),   getStatusColor(status)        ))                                    );
                                          }
                                          else if (status == 'Pending' || status == 'Processing' || status == 'Confirm'){
                                            context.read<OrderListBloc>().add(CancelOrderEvent(context, data.id.toString()));
                                          }
                                        },
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Constant
                                                      .bgOrangeLite),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                status == 'Delivered' || status == 'Complete'
                                                    ? 'Details'
                                                    : 'Cancel',
                                                style: TextStyle(
                                                  color: Constant
                                                      .bgOrangeLite,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Orange button
                                        InkWell(
                                          onTap: () {
                                            if (status == 'Processing' ||
                                                status == 'Pending' ||
                                                status == 'Confirm') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetails(  data.id.toString() , getStatusColor(status)      ))                                           );
                                            }
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
                                              child: Text(
                                                status == 'Processing' ||
                                                    status ==
                                                        'Pending'
                                                    ? 'Details'
                                                    : status ==
                                                    'Delivered'
                                                    ? 'Re-Order'
                                                    : 'Details',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }

  Widget toReceiveBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          );
        }
        if (state is OrderListSuccess) {
          return state.orderListModel.orders!
              .where((e) =>
          e.orderStatus == 'processing' ||
              e.orderStatus == 'pending' ||
              e.orderStatus == 'confirm' ||
              e.orderStatus == 'dispatch')
              .toList()
              .isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.orderListModel.orders
                ?.where((e) =>
            e.orderStatus == 'processing' ||
                e.orderStatus == 'pending' ||
                e.orderStatus == 'confirm' ||
                e.orderStatus == 'dispatch')// Filter orders by status
                .toList()
                .length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Filter the orders based on 'processing' status
              var filteredOrders = state.orderListModel.orders
                  ?.where((e) =>
              e.orderStatus == 'processing' ||
                  e.orderStatus == 'pending' ||
                  e.orderStatus == 'confirm' ||
                  e.orderStatus == 'dispatch')
                  .toList();

              // Access the order from the filtered list
              var data = filteredOrders![index];

              // Determine the order status
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';


              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constant.bgOrangeLite),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'IW3475453455',
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
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            color: Constant.bgGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                            color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color:getStatusColor(status),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // White button
                                        status == 'Cancelled'|| status == 'Dispatch'
                                            ? SizedBox()
                                            : InkWell(onTap: () {

                                          if (status == 'Complete' || status == 'Delivered') {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(  data.id.toString(),   getStatusColor(status)        ))                                    );
                                          }
                                          else if (status == 'Pending' || status == 'Processing' || status == 'Confirm'){
                                            context.read<OrderListBloc>().add(CancelOrderEvent(context, data.id.toString()));
                                          }
                                        },
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Constant
                                                      .bgOrangeLite),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                status == 'Delivered'
                                                    ? 'Details'
                                                    : 'Cancel',
                                                style: TextStyle(
                                                  color: Constant
                                                      .bgOrangeLite,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Orange button
                                        InkWell(
                                          onTap: () {
                                            if (status == 'Processing' || status == "Dispatch"|| status == "Confirm"||
                                                status == 'Pending') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetails(  data.id.toString(), getStatusColor(status))           )                                         );
                                            }
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
                                              child: Text(
                                                status == 'Processing' ||
                                                    status ==
                                                        'Pending'
                                                    ? 'Details'
                                                    : status ==
                                                    'Delivered'
                                                    ? 'Re-Order'
                                                    : 'Details',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }

  Widget refundBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          );
        }
        if (state is OrderListSuccess) {
          return state.orderListModel.orders!
              .where((e) => e.orderStatus == 'return')
              .toList()
              .isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.orderListModel.orders
                ?.where((e) =>
            e.orderStatus == 'return') // Filter orders by status
                .toList()
                .length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Filter the orders based on 'processing' status
              var filteredOrders = state.orderListModel.orders
                  ?.where((e) => e.orderStatus == 'return')
                  .toList();

              // Access the order from the filtered list
              var data = filteredOrders![index];

              // Determine the order status
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';



              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constant.bgOrangeLite),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'IW3475453455',
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
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            color: Constant.bgGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                            color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color:getStatusColor(status),
                                        // Replace 'Colors.black' with any default color you want.
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // White button
                                        status == 'Cancelled'|| status == 'Dispatch'
                                            ? SizedBox()
                                            : InkWell(
                                          onTap: () {

                                            if (status == 'Complete' || status == 'Delivered') {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(  data.id.toString(),   getStatusColor(status)        ))                                    );
                                            }
                                            else if (status == 'Pending' || status == 'Processing' || status == 'Confirm'){
                                              context.read<OrderListBloc>().add(CancelOrderEvent(context, data.id.toString()));
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Constant
                                                      .bgOrangeLite),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                status == 'Delivered'
                                                    ? 'Details'
                                                    : 'Cancel',
                                                style: TextStyle(
                                                  color: Constant
                                                      .bgOrangeLite,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                            ),
                                        const SizedBox(width: 10),
                                        // Orange button
                                        InkWell(
                                          onTap: () {
                                            if (status == 'Return'
                                            ) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetails(  data.id.toString(), getStatusColor(status))            )                                        );
                                            }
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
                                              child: Text(
                                                status == 'Processing' ||
                                                    status ==
                                                        'Pending'
                                                    ? 'Details'
                                                    : status ==
                                                    'Delivered'
                                                    ? 'Re-Order'
                                                    : 'Details',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }

  Widget completedBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          );
        }
        if (state is OrderListSuccess) {
          return state.orderListModel.orders!
              .where((e) => e.orderStatus == 'complete')
              .toList()
              .isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.orderListModel.orders
                ?.where((e) =>
            e.orderStatus ==
                'complete') // Filter orders by status
                .toList()
                .length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Filter the orders based on 'processing' status
              var filteredOrders = state.orderListModel.orders
                  ?.where((e) => e.orderStatus == 'complete')
                  .toList();

              // Access the order from the filtered list
              var data = filteredOrders![index];

              // Determine the order status
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constant.bgOrangeLite),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'IW3475453455',
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
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            color: Constant.bgGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                            color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: getStatusColor(status),
                                        // Replace 'Colors.black' with any default color you want.
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // White button
                                        status == 'Cancelled'|| status == 'Dispatch'
                                            ? SizedBox()
                                            : InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetails(  data.id.toString(), getStatusColor(status))      )                                              );
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Constant
                                                      .bgOrangeLite),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                status == 'Delivered' || status == 'Complete'
                                                    ? 'Details'
                                                    : 'Cancel',
                                                style: TextStyle(
                                                  color: Constant
                                                      .bgOrangeLite,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Orange button
                                        BlocListener<ReOrderBloc, ReOrderState>(
                                          listenWhen: (previous, current) => completeReorder == true,
                                        listener: (context, state) {
                                          if(state is ReOrderSuccess){

                                            completeReorder = false;
                                            Fluttertoast.showToast(msg: state.reOrderModel.message.toString(), backgroundColor: Constant.bgOrangeLite);
                                          }
                                        },
                                        child: InkWell(
                                          onTap: () {
                                            if (status == 'Complete' || status == 'Delivered'
                                            ) {

                                              completeReorder = true;
                                              context.read<ReOrderBloc>().add(ReOrderRefreshEvent(data.id.toString()));
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             OrderDetails(  data.id.toString(), getStatusColor(status))      )                                              );
                                            }
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
                                              child: Text(
                                                status == 'Processing' ||
                                                    status ==
                                                        'Pending'
                                                    ? 'Details'
                                                    : status ==
                                                    'Delivered' || status == 'Complete'
                                                    ? 'Re-Order'
                                                    : 'Details',
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
),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }

  Widget toReviewBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          );
        }
        if (state is OrderListSuccess) {
          return state.reviewModel.orders!/*
              .where((e) => e.orderStatus == 'review')
              .toList()*/
              .isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.reviewModel.orders?.length,
            //     ?.where((e) =>
            // e.orderStatus == 'review') // Filter orders by status
            //     .toList()
            //     .length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var data = state.reviewModel.orders![index];
              // Filter the orders based on 'processing' status
              // var filteredOrders = state.reviewModel.orders
              //     ?.where((e) => e.orderStatus == 'review')
              //     .toList();
              //
              // // Access the order from the filtered list
              // var data = filteredOrders![index];
              //
              // // Determine the order status
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'review'
                  ? 'Review'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constant.bgOrangeLite),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'IW3475453455',
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
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            color: Constant.bgGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                            color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(/*data.orderStatus.toString(),*/
                                      status,
                                      style: TextStyle(
                                        color:getStatusColor(status),
                                        // Replace 'Colors.black' with any default color you want.
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // White button
                                        // status == 'Cancelled'|| status == 'Dispatch'
                                        //     ? SizedBox()
                                        //     : Container(
                                        //   height: 30,
                                        //   width: 80,
                                        //   decoration: BoxDecoration(
                                        //     border: Border.all(
                                        //         color: Constant
                                        //             .bgOrangeLite),
                                        //     borderRadius:
                                        //     BorderRadius
                                        //         .circular(5),
                                        //   ),
                                        //   child: Center(
                                        //     child: Text(
                                        //       status == 'Delivered'
                                        //           ? 'Details'
                                        //           : 'Cancel',
                                        //       style: TextStyle(
                                        //         color: Constant
                                        //             .bgOrangeLite,
                                        //         fontWeight:
                                        //         FontWeight.bold,
                                        //         fontSize: 12,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        const SizedBox(width: 10),
                                        // Orange button
                                        InkWell(
                                          onTap: () {
                                            // if (status == 'Review' ) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Pendingreviewpage(data.productsToReview)));
                                            //   Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               OrderDetails(  data.id.toString(), getStatusColor(status))     )                                               );
                                            // }
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
                                              child: Text(
                                                status == 'Processing' ||
                                                    status ==
                                                        'Pending'
                                                    ? 'Details'
                                                    : status ==
                                                    'Delivered'
                                                    ? 'Re-Order'
                                                    : 'Details',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }

  Widget cancelledBuild() {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        if (state is OrderListLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Constant.bgOrangeLite,
            ),
          );
        }
        if (state is OrderListSuccess) {
          return state.orderListModel.orders!
              .where((e) => e.orderStatus == 'cancelled')
              .toList()
              .isEmpty
              ? Center(
              child: Image.asset(
                'assets/profile/no_orders.png',
                height: 142,
                width: 148,
              ))
              : ListView.builder(
            itemCount: state.orderListModel.orders
                ?.where((e) =>
            e.orderStatus ==
                'cancelled') // Filter orders by status
                .toList()
                .length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Filter the orders based on 'processing' status
              var filteredOrders = state.orderListModel.orders
                  ?.where((e) => e.orderStatus == 'cancelled')
                  .toList();

              // Access the order from the filtered list
              var data = filteredOrders![index];

              // Determine the order status
              var status = data.orderStatus == 'processing'
                  ? 'Processing'
                  : data.orderStatus == 'delivered'
                  ? 'Delivered'
                  : data.orderStatus == 'cancelled'
                  ? 'Cancelled'
                  : data.orderStatus == 'complete'
                  ? 'Complete'
                  : data.orderStatus == 'dispatch'
                  ? 'Dispatch'
                  : data.orderStatus == 'return'
                  ? 'Return'
                  : data.orderStatus == 'review'
                  ? 'Review'
                  : data.orderStatus == 'confirm'
                  ? 'Confirm'
                  : 'Pending';

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Constant.bgOrangeLite),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no: ${data.orderId.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      data.orderDate.toString(),
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text(
                                      'Tracking number: ',
                                      style: TextStyle(
                                        color: Constant.bgGrey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'IW3475453455',
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
                                    Row(
                                      children: [
                                        Text(
                                          'Quantity: ',
                                          style: TextStyle(
                                            color: Constant.bgGrey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          data.quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          data.netAmount.toString(),
                                          style: TextStyle(
                                            color: Constant.bgOrangeLite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      status,
                                      style: TextStyle(
                                        color: getStatusColor(status),
                                        // Replace 'Colors.black' with any default color you want.
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // White button
                                        status == 'Cancelled'|| status == 'Dispatch'
                                            ? SizedBox()
                                            : InkWell(
                                          child: Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Constant
                                                      .bgOrangeLite),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                status == 'Delivered'
                                                    ? 'Details'
                                                    : 'Cancel',
                                                style: TextStyle(
                                                  color: Constant
                                                      .bgOrangeLite,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Orange button
                                        InkWell(
                                          onTap: () {
                                            if (status == 'Cancelled'
                                            ) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OrderDetails(  data.id.toString(), getStatusColor(status))                           )                         );
                                            }
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
                                              child: Text(
                                                status == 'Processing' ||
                                                    status ==
                                                        'Pending'
                                                    ? 'Details'
                                                    : status ==
                                                    'Delivered'
                                                    ? 'Re-Order'
                                                    : 'Details',
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (state is OrderListError) {
          return Center(child: Text(state.error));
        }
        return SizedBox();
      },
    );
  }
}
