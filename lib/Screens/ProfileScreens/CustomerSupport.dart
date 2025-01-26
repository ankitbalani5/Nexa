import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexa/Constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Bloc/CustomerSupportBloc/customer_support_bloc.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({super.key});

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://urlsdemo.online/nexa/customer-support-page'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer support'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
  /*
  
  @override
  void initState() {
    context.read<CustomerSupportBloc>().add(CustomerSupportRefreshEvent());
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/profile/back.png', height: 30, width: 30,),
          ),
        ),
        title: const Text('Customer support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),
      ),
      body: BlocBuilder<CustomerSupportBloc, CustomerSupportState>(
        builder: (context, state) {
          if(state is CustomerSupportLoading){
            return Center(
              child: CircularProgressIndicator(color: Constant.bgOrangeLite,),
            );
          }
          if(state is CustomerSupportSuccess){
            var customerSupportData = state.customerSupportModel.customerSupport;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 240,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(imageUrl: customerSupportData!.image1.toString(), fit: BoxFit.cover,)),
                          ),
                          const SizedBox(height: 20,),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 20.0),
                          //   child: Text(customerSupportData.heading1.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold) ,),
                          // ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          // const SizedBox(height: 10,),
                          Text(customerSupportData.description1.toString()),
                          const SizedBox(height: 20,),

                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 240,
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                child: CachedNetworkImage(imageUrl: customerSupportData.image2.toString(), fit: BoxFit.cover,)),
                          ),
                          const SizedBox(height: 20,),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 20.0),
                          //   child: Text(customerSupportData.heading2.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold) ,),
                          // ),
                          Text(customerSupportData.description2.toString()),

                          const SizedBox(height: 20,),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          if(state is CustomerSupportError){
            return Center(child: Text(state.error),);
          }
          return SizedBox();
        },
      ),
    );
  }*/
}
