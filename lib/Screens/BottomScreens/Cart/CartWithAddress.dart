import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../Constant.dart';
import '../../../Widget/Btn.dart';

class CartWithAddress extends StatefulWidget {
  const CartWithAddress({super.key});

  @override
  State<CartWithAddress> createState() => _CartWithAddressState();
}

class _CartWithAddressState extends State<CartWithAddress> {

  List<Map<String, dynamic>> itemData = [
    {
      'banner': 'assets/home/banner.png',
      'image': 'assets/home/zoomlenc.png',
      'name': 'Smilee 8 Times Zoom mobile phone lens telephotography',
      'price': '\$99',
      'color': '0xffF8A44C',
      'quantity': 1
    },
    {
      'banner': 'assets/home/banner.png',
      'image': 'assets/home/adapter.png',
      'name': '120 USB Adapter + CABLE Charger Set Charger',
      'price': '\$99',
      'color': '0xff06844B',
      'quantity': 1
    },
    {
      'banner': 'assets/home/banner.png',
      'image': 'assets/home/cable.png',
      'name': '3 in 1 120W Fast Cable USB Charging Cord',
      'price': '\$99',
      'color': '0xffF8A44C',
      'quantity': 1
    },
    {
      'banner': 'assets/home/banner.png',
      'image': 'assets/home/airpodcover.png',
      'name': '[Sopt] Pure color soft sililcone protective cover',
      'price': '\$99',
      'color': '0xff06844B',
      'quantity': 1
    },
    {
      'banner': 'assets/home/banner.png',
      'image': 'assets/home/gorilla.png',
      'name': 'Tempered Glass for OPPO a3s a5s A7 A12E A15',
      'price': '\$99',
      'color': '0xffF8A44C',
      'quantity': 1
    },
    {
      'banner': 'assets/home/banner.png',
      'image': 'assets/home/airpodcover.png',
      'name': 'For Infinix Smart 8 7 5 Note 40 30 12 Turbo G96',
      'price': '\$99',
      'color': '0xff06844B',
      'quantity': 1
    },
  ];

  void _deleteItem(int index) {
    setState(() {
      itemData.removeAt(index);
    });
  }

  // void _addItem() {
  //   setState(() {
  //     itemData.add({
  //       'image': 'assets/item_new.png',
  //       'name': 'New Item',
  //       'price': '\$150',
  //     });
  //   });
  // }

  void _addItem(int index) {
    setState(() {
      itemData[index]['quantity'] = (itemData[index]['quantity'] ?? 1) + 1;
    });
  }

  void _subtractItem(int index) {
    setState(() {
      if (itemData[index]['quantity'] != null && itemData[index]['quantity'] > 1) {
        itemData[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 5,
        title: const Text('Cart', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: Image.asset('assets/navbar/sort.png', height: 40, width: 40,),
        //   )
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10,),
              const Text('3 items', style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 18
              )),
              const Text('in cart', style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 16,
                  color: Constant.bgGrey
              )),
              const SizedBox(height: 10,),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: itemData.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    key: ValueKey(itemData[index]['name']),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        Expanded(
                          child: Container(
                            // padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Constant.bgOrangeLite,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    child:
                                    /*icon: const */const Icon(Icons.add, color: Colors.white),
                                    onTap: () => _addItem(index),
                                  ),
                                ),
                                Text(
                                  '${itemData[index]['quantity']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    child:
                                    /*icon: const*/ const Icon(Icons.remove, color: Colors.white),
                                    onTap: () => _subtractItem(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SlidableAction(
                        //   borderRadius: BorderRadius.circular(12),
                        //   padding: EdgeInsets.only(right: 10),
                        //   onPressed: (context) => _addItem(),
                        //   backgroundColor: Constant.bgOrange,
                        //   foregroundColor: Colors.white,
                        //   // icon: ,
                        //   label: 'Delete',
                        // ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: SlidableAction(
                              borderRadius: BorderRadius.circular(12),
                              padding: const EdgeInsets.only(right: 10),
                              onPressed: (context) => _deleteItem(index),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete_forever_outlined,
                              // label: 'Add',
                            ),
                          ),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Constant.bgBtnGrey
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(itemData[index]['image']),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width*.6,
                                  child: Text(itemData[index]['name'], style: const TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14
                                  ),)),
                              Row(
                                children: [
                                  Text(itemData[index]['price'], style: const TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: 18
                                  ),),
                                  const SizedBox(width: 20,),
                                  const Text('\$1200', style: TextStyle(fontWeight: FontWeight.w700,
                                      fontSize: 16, color: Constant.bgGrey,
                                      decoration: TextDecoration.lineThrough, decorationColor: Constant.bgGrey)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 170,
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:', style: TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 16
                )),
                Text('\$991', style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16
                )),
              ],
            ),
            const SizedBox(height: 10,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18
                )),
                Text('\$991', style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 18, color: Constant.bgOrangeLite
                )),
              ],
            ),
            const SizedBox(height: 20,),
            Btn('', height: 50, width: MediaQuery.of(context).size.width,
                linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                name: 'Checkout', callBack: (){
                  showOrderDialog();
                })
          ],
        ),
      ),
    );
  }

  showOrderDialog(){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Image.asset('assets/profile/ordersuccess.png', height: 150, width: 150,),
                const SizedBox(height: 40,),
                const Text('Order Confirm', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),),
                const SizedBox(height: 10,),
                const Text('Your order has been placed successfully. ',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Btn('', height: 50, width: MediaQuery.of(context).size.width,
                      linearColor1: Constant.bgLinearColor1, linearColor2: Constant.bgLinearColor2,
                      name: 'Continue', callBack: (){}),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
