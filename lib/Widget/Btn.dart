import 'package:flutter/material.dart';

class Btn extends StatefulWidget {
  double height;
  double width;
  Color linearColor1;
  Color linearColor2;
  double fontSize;
  Color borderColor = Colors.transparent;
  String name;
  String? image;
  VoidCallback callBack;
  final Widget? child;
  Btn(borderColor,{required this.height,
    required this.width, required this.linearColor1,
    required this.linearColor2,
    this.fontSize = 18,
    required this.name,
    this.image,
    required this.callBack,
    this.child, super.key});

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.callBack,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors:
            [widget.linearColor1!, widget.linearColor2!]),
            border: Border.all(color: widget.borderColor)
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.image != null ? Image.asset(widget.image.toString(), height: 20, width: 20) : SizedBox(),
              widget.image != null ? SizedBox(width: 10,) : SizedBox(),
              widget.child ?? Text(widget.name!, style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700,
                  fontSize: widget.fontSize, fontFamily: 'Roboto'),),
            ],
          ),
        ),
      ),
    );
  }
}
