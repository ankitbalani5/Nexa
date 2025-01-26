import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Api.dart';
import 'package:nexa/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:nexa/Model/NotificationListModel.dart';
import 'package:nexa/main.dart';

import '../../Constant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // NotificationListModel? notificationList;
  @override
  void initState() {
    context.read<NotificationBloc>().add(GetNotificationEvent());
    // fetchNotification();
    super.initState();
  }

  // fetchNotification() async {
  //    notificationList = await Api.notificationListApi();
  //    setState(() {
  //
  //    });
  // }
  List selectedItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
        ),
        title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: selectedItems.isNotEmpty
                ? GestureDetector(
                onTap: () {
                  context.read<NotificationBloc>().add(DeleteNotificationEvent(context, selectedItems));
                  selectedItems = [];
                },
                child: Icon(Icons.delete_outline, color: Constant.bgOrangeLite,)) : SizedBox(),

          )
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if(state is NotificationLoading){
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Constant.bgOrangeLite,
                size: 40,
              ),);
          }
          if(state is NotificationSuccess){
            var notificationList = state.notificationListModel;
            return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView.builder(
                      itemCount: notificationList?.notification?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // Get the current notification item
                        var notification = notificationList!.notification![index].id;

                        // Check if the current item is selected
                        bool isSelected = selectedItems.contains(notification);
                        return GestureDetector(
                          onTap: () {
                            if(selectedItems.isNotEmpty)
                              {
                                setState(() {
                                  // Toggle selection of the item
                                  if (isSelected) {
                                    selectedItems.remove(notification);
                                  } else {
                                    selectedItems.add(notification);
                                  }
                                  print('selectedIndex::::$selectedItems');
                                });
                              }
                          },
                          onLongPress: () {
                            setState(() {
                              // Toggle selection of the item
                              if (isSelected) {
                                selectedItems.remove(notification);
                              } else {
                                selectedItems.add(notification);
                              }
                              print('selectedIndex::::$selectedItems');
                            });
                          },
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.symmetric(vertical: 7),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.2) : Constant.bgGreytile,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,

                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8,),
                                Image.asset('assets/images/notification.png', height: 50, width: 50,),
                                SizedBox(width: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*.65,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(notificationList!.notification![index].about.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff4D4D4D)),),
                                            Text( notificationList!.notification![index].content.toString() , style: TextStyle(
                                                fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400, color: Color(0xff4D4D4D)),),

                                          ],
                                        ),
                                      ),
                                          Text(notificationList!.notification![index].notifyTime.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff6A6E7A)),),

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                    },),
                  );
          }
          if(state is NotificationError){
            return Center(child: Text(state.error));
          }
          return SizedBox();
        },
      ),
    );
  }
}
