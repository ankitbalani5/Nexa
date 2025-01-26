import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constant.dart';

class Btn2 extends StatefulWidget {
  double height;
  double width;
  String name;
  VoidCallback callBack;
  Btn2({required this.height,
    required this.width,
    required this.name,
    required this.callBack, super.key});

  @override
  State<Btn2> createState() => _Btn2State();
}

class _Btn2State extends State<Btn2> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.callBack,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            border: Border.all(color: Constant.bgOrangeLite, width: 2),
            borderRadius: BorderRadius.circular(12)
        ),
        child: Center(
            child: Text(widget.name, style: TextStyle(color: Constant.bgOrangeLite,
              fontWeight: FontWeight.w700, fontSize: 16
            ),)),
      ),
    );
  }
}
