import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/base/theme/theme.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool enabled;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final int? maxLines;

  const FormTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled ? Colors.white : getColorSkin().lightGrey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: getColorSkin().lightGrey400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: getColorSkin().lightGrey400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: getColorSkin().primaryRed650),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: getColorSkin().errorRed),
        ),
        labelStyle: TextStyle(
          color: getColorSkin().darkGrey,
          fontSize: 16.sp,
        ),
        hintStyle: TextStyle(
          color: getColorSkin().grey,
          fontSize: 14.sp,
        ),
        errorStyle: TextStyle(
          color: getColorSkin().errorRed,
          fontSize: 12.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      style: TextStyle(
        color: getColorSkin().darkGrey,
        fontSize: 16.sp,
      ),
    );
  }
}