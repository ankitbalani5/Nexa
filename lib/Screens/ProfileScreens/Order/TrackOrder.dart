import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:nexa/Constant.dart';


class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  int activeStep = 0;

  List<Map<String, dynamic>> stepperList = [
    {
      'type': 'check',
      'address': 'a-16 laxminagar jaipur, rajasthan, india',
      'time': '7:00 PM',
      'arrive': true
    },
    {
      'type': 'sub',
      'address': 'a-17 laxmanpura, gandhi nagar jaipur, rajasthan, india',
      'time': '7:00 PM',
      'arrive': true
    },
    {
      'type': 'check',
      'address': 'RamNagar bhavani choraha jaipur, rajasthan, india',
      'time': '7:00 PM',
      'arrive': true
    },
    {
      'type': 'sub',
      'address': 'Murlipura bus stand jaipur, rajasthan, india',
      'time': '7:00 PM',
      'arrive': true
    },
    {
      'type': 'sub',
      'address': 'jhotwara canta chauraha jaipur, rajasthan, india',
      'time': '7:00 PM',
      'arrive': false
    },
    {
      'type': 'check',
      'address': 'a-16 laxminagar jaipur, rajasthan, india',
      'time': '7:00 PM',
      'arrive': false
    }
  ];

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
        title: const Text('Track Order', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22)),

      ),
      body: ListView.builder(
        itemCount: stepperList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
            child: Column(children: <Widget>[
              Row(
                children: [
                  Text(stepperList[index]['time']),
                  const SizedBox(width: 10,),
                  stepperList[index]['type'] == 'check'
                      ? Row(
                        children: [
                          Container(
                            // margin: EdgeInsets.only(top: 16),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: stepperList[index]['arrive'] == false ? Colors.grey : Constant.bgOrangeLite,
                                border:
                                Border.all(width: 2, color: stepperList[index]['arrive'] == false ? Colors.grey : Constant.bgOrangeLite)
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 15,),
                          ),
                        ],
                      )
                      : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
                        child: Dash(
                          dashThickness: 2,
                            direction: Axis.vertical,
                            length: 100,
                            dashLength: 15,
                            dashColor: stepperList[index]['arrive'] == false ? Colors.grey : Constant.bgOrangeLite
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                      width: MediaQuery.of(context).size.width*.65,
                      child: Text(stepperList[index]['address'].toString()))
                ],
              ),


            ],
            ),
          );
      },)


    );
  }
}


// Row(
//                 children: [
//                   Container(
//                     // margin: EdgeInsets.only(top: 16),
//                     height: 25,
//                     width: 25,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Constant.bgOrangeLite,
//                         border:
//                         Border.all(width: 2, color: Constant.bgOrangeLite)
//                     ),
//                     child: Icon(Icons.check, color: Colors.white, size: 15,),
//                   ),
//                   Text('3 Newbridge Court Chino Hills, CA 91709')
//                 ],
//               ),
//               /*Container(
//             height: 25,
//             width: 25,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 border: Border.all(width: 2, color: Colors.red)),
//             child: Container(
//               height: 20,
//             ),
//           ),*/


// EasyStepper(
//   direction: Axis.vertical,
//   activeStep: activeStep,
//   // lineLength: 70,
//   // lineSpace: 0,
//   // lineType: LineType.normal,
//   // defaultLineColor: Colors.white,
//   // finishedLineColor: Colors.orange,
//   activeStepTextColor: Colors.black87,
//   finishedStepTextColor: Colors.black87,
//   internalPadding: 0,
//   showLoadingAnimation: false,
//   stepRadius: 8,
//   showStepBorder: false,
//   // lineDotRadius: 1.5,
//   steps: [
//     EasyStep(
//       customStep: CircleAvatar(
//         radius: 8,
//         backgroundColor: Colors.white,
//         child: CircleAvatar(
//           radius: 7,
//           backgroundColor:
//           activeStep >= 0 ? Colors.orange : Colors.white,
//         ),
//       ),
//       title: 'Waiting',
//     ),
//     EasyStep(
//       customStep: CircleAvatar(
//         radius: 8,
//         backgroundColor: Colors.white,
//         child: CircleAvatar(
//           radius: 7,
//           backgroundColor:
//           activeStep >= 1 ? Colors.orange : Colors.white,
//         ),
//       ),
//       title: 'Order Received',
//       topTitle: true,
//     ),
//     EasyStep(
//       customStep: CircleAvatar(
//         radius: 8,
//         backgroundColor: Colors.white,
//         child: CircleAvatar(
//           radius: 7,
//           backgroundColor:
//           activeStep >= 2 ? Colors.orange : Colors.white,
//         ),
//       ),
//       title: 'Preparing',
//     ),
//     EasyStep(
//       customStep: CircleAvatar(
//         radius: 8,
//         backgroundColor: Colors.white,
//         child: CircleAvatar(
//           radius: 7,
//           backgroundColor:
//           activeStep >= 3 ? Colors.orange : Colors.white,
//         ),
//       ),
//       title: 'On Way',
//       topTitle: true,
//     ),
//     EasyStep(
//       customStep: CircleAvatar(
//         radius: 8,
//         backgroundColor: Colors.white,
//         child: CircleAvatar(
//           radius: 7,
//           backgroundColor:
//           activeStep >= 4 ? Colors.orange : Colors.white,
//         ),
//       ),
//       title: 'Delivered',
//     ),
//   ],
//   onStepReached: (index) =>
//       setState(() => activeStep = index),
// ),