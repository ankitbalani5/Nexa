import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Buttons {

  static commonBorderRadius () {
    return BorderRadius.circular(12) ;
  }

  static commonBorderRadius20 () {
    return BorderRadius.circular(20) ;
  }

  static continueButton ({required void Function()? onPressed , required Color backgroundColor}) {
    return ElevatedButton(
      onPressed: onPressed ,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: Buttons.commonBorderRadius(),
        ),
      ),
      child: Center(
        child: Text(
          'continue',
          // style: TextStyles.font18Bold(AppColors.whiteColor),
        ),
      ),
    );
  }

  static borderButton({/*required double width, */required String title, required VoidCallback callback,
    double radius = 30,
    /*Color borderColor = AppColors.blueThemeColor*/}){
    return Container(
      height: 55,
    // width: width,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
      // border: Border.all(color: borderColor, width: 1.5)
    ),
      child: Center(child: Text(
        title,
        // style: TextStyles.font18SemiBold(borderColor),
      )),
    );
}

  static customButton ({ required String title , required void Function()? onPressed ,
    required Color backgroundColor }) {
    return ElevatedButton(
      onPressed: onPressed ,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: Buttons.commonBorderRadius(),
        ),
      ),
      child: Center(
        child: Text( title ,
          // style: TextStyles.font18Bold(AppColors.whiteColor),
        ),
      ),
    );
  }

}