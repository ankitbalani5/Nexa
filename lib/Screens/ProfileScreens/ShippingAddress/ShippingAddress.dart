import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:nexa/Bloc/AllShippingAddressBloc/all_shipping_address_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:nexa/NavBar.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/AddShippingAddress.dart';
import 'package:nexa/Screens/ProfileScreens/ShippingAddress/EditShippingAddress.dart';
import 'package:nexa/Widget/Btn.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  bool check = true;

  @override
  void initState() {
    context.read<AllShippingAddressBloc>().add(FetchShippingAddressEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: (){
                // Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 4,)), (route) => false,);
              },
              child: Image.asset('assets/profile/back.png', height: 30, width: 30,)),
        ),
        title: const Text('Shipping Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NavBar(i: 4,)), (route) => false,);
          return Future.value(false);
        },
        child: RefreshIndicator(
          color: Constant.bgOrangeLite,
          onRefresh: () async{
            context.read<AllShippingAddressBloc>().add(ClearShippingAddressEvent());
            context.read<AllShippingAddressBloc>().add(FetchShippingAddressEvent());
          },
          child: BlocBuilder<AllShippingAddressBloc, AllShippingAddressState>(
            builder: (context, state) {
              if(state is AllShippingAddressLoading){
                return Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    size: 40,
                  ),);
              }
              if(state is AllShippingAddressSuccess){
                var shippingAddress = state.allShippingAddressModel.shippingAddress;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: shippingAddress?.length,
                    itemBuilder: (context, index) {
                      return Column(
                          children: [
                            const SizedBox(height: 20,),
                            Container(
                              // height: 160,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Constant.bgOrangeLite
                                  )
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(shippingAddress![index].name.toString(),style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                                        const SizedBox(height: 10,),
                                        Text('${shippingAddress[index].address.toString()}, '
                                            '${shippingAddress[index].city.toString()}, '
                                            '${shippingAddress[index].country.toString()}, ${shippingAddress[index].state.toString()}',
                                            maxLines: 2,
                                            style: TextStyle(color: Constant.bgGrey,
                                                fontWeight: FontWeight.w400, fontSize: 16)),
                                        const SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // Row(
                                            //   children: [
                                            //     SizedBox(
                                            //       width: 24,
                                            //       height: 24,
                                            //       child: Checkbox(
                                            //         value: check,
                                            //         side: const BorderSide(color: Constant.bgOrangeLite),
                                            //         activeColor: Constant.bgOrangeLite,
                                            //         onChanged: (value) {
                                            //           check = !check;
                                            //           setState(() {
                                            //
                                            //           });
                                            //         },),
                                            //     ),
                                            //     const SizedBox(width: 10,),
                                            //     const Text('use as the address')
                                            //   ],
                                            // ),
                                            InkWell(
                                                onTap: (){
                                                  context.read<AllShippingAddressBloc>().add(DeleteShippingAddressEvent(state.allShippingAddressModel.shippingAddress![index]));
                                                },
                                                child: Image.asset('assets/profile/delete.png', height: 20, width: 20,))

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditShippingAddress(
                                              shippingAddress[index].id.toString(),
                                              shippingAddress[index].name.toString(), shippingAddress[index].address.toString(),
                                              shippingAddress[index].country.toString(), shippingAddress[index].state.toString(),
                                              shippingAddress[index].city.toString(), shippingAddress[index].zipCode.toString(),
                                              shippingAddress[index].countryCode.toString(), shippingAddress[index].phone.toString(),
                                              shippingAddress[index].primaryAddress.toString(), shippingAddress[index].countryId.toString(),
                                              shippingAddress[index].stateId.toString()
                                          )));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),

                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(12),
                                                  bottomLeft: Radius.circular(15)),
                                              color: Constant.bgOrangeLite
                                          ),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.edit, color: Colors.white, size: 12,),
                                              Text('Edit', style: TextStyle(color: Colors.white, fontSize: 12),),
                                            ],
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            )
                          ]
                      );
                    },),
                );
              }
              if(state is AllShippingAddressError){
                return Center(
                  child: Text(state.error),
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        color: Colors.transparent,
        child: Btn('', height: 50, width: MediaQuery.of(context).size.width,
            linearColor1: Constant.bgLinearColor1,
            linearColor2: Constant.bgLinearColor2,
            name: 'Add new address', callBack: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddShippingAddress(path: 'shipping',)));
            }),
      ),
    );
  }
}
