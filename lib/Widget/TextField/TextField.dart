
import 'package:flutter/material.dart';

import '../../Constant.dart';
import '../../core/buttons.dart';

class TextFields {
  static simpleTextField({
    required TextEditingController controller,
    String? prefixIcon,
    required String hint,
    TextInputType? textInputType,
    String Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onIconPressed,
    bool? readOnly,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      keyboardType: textInputType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIcon: prefixIcon != null
            ? IconButton(
                onPressed: onIconPressed, icon: Image.asset(prefixIcon))
            : null,
        hintText: hint,
        filled: true,
        fillColor: Constant.bgGrey,
        border: OutlineInputBorder(
          borderRadius: Buttons.commonBorderRadius(),
          borderSide: BorderSide.none,
        ),
      ),
    ) ;
  }

  static myTextField({required String hint, required TextEditingController controller, }){
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          filled: true,
          hintText: hint,
          hintStyle: const TextStyle(color: Constant.bgTextfieldHint),
          fillColor: Constant.bgTextField,
          // contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent)
          )
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return 'Enter last name';
        }
        return null;
      },
    );
  }

  static simpleTextFieldArea({
    required TextEditingController controller,
    String? prefixIcon,
    required String hint,
    String Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onIconPressed,
    bool? readOnly,
    Color? color,
    Color? hintColor,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      maxLines: 4,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIcon: prefixIcon != null
            ? IconButton(
                onPressed: onIconPressed, icon: Image.asset(prefixIcon))
            : null,
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: color != null ? color : Constant.bgGrey,
        border: OutlineInputBorder(
          borderRadius: Buttons.commonBorderRadius(),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static dobTextField({
    required TextEditingController controller,
    String? prefixIcon,
    required String hint,
    void Function()? onIconPressed,
    void Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      readOnly: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIcon: prefixIcon != null
            ? IconButton(
                onPressed: onIconPressed, icon: Image.asset(prefixIcon))
            : null,
        hintText: hint,
        filled: true,
        fillColor: Constant.bgGrey,
        border: OutlineInputBorder(
          borderRadius: Buttons.commonBorderRadius(),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static exploreSimpleTextField({
    required TextEditingController controller,
    String? prefixIcon,
    required String hint,
    String Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onIconPressed,
    bool? readOnly,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        prefixIcon: const Icon(
          Icons.search,
          color: Constant.bgGrey,
        ),
        hintText: hint,
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: Buttons.commonBorderRadius(),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static chatingSimpleTextField({
    required TextEditingController controller,
    String? prefixIcon,
    required String hint,
    String Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onIconPressed,
    bool? readOnly,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          prefixIcon: const Icon(
            Icons.attach_file,
            // color: AppColors.blueThemeColor,
          ),
          suffixIcon: OutlinedButton(
            onPressed: () {},
            child: Icon(Icons.send,
                // color: AppColors.whiteColor
            ),
            style: OutlinedButton.styleFrom(
              // backgroundColor: AppColors.blueThemeColor,
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
            ),
          ),
          hintText: hint,
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
            borderRadius: Buttons.commonBorderRadius(),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

}
