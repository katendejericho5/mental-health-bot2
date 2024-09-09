import 'package:WellCareBot/constant/constants.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    Key? key,
    this.hintText,
    this.radiusTopLeft,
    this.radiusTopRight,
    this.radiusBottomLeft,
    this.radiusBottomRight,
    this.paddingHeight,
    this.initialValue,
    this.restorationId,
    this.prefixWidget,
    this.suffixWidget,
    this.maxLength,
    this.enabled = true,
    this.focusedColor,
    this.fillColor,
    this.hintColor,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.isObscure = false,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.textSize,
    this.maxLines,
    this.minLines,
  }) : super(key: key);

  final String? hintText;
  final double? radiusTopLeft;
  final double? radiusTopRight;
  final double? radiusBottomLeft;
  final double? textSize;
  final double? radiusBottomRight;
  final double? paddingHeight;
  final String? initialValue;
  final String? restorationId;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final int? maxLength;
  final bool enabled;
  final Color? focusedColor;
  final Color? borderColor = Colors.black.withOpacity(0.2);
  final Color? fillColor;
  final Color? hintColor;
  final VoidCallback? onTap;
  final TextAlign textAlign;
  final bool isObscure;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        key: key,
        cursorColor: kPrimaryColor,
        onChanged: onChanged,
        onSaved: onSaved,
        enabled: enabled,
        onTap: onTap,
        maxLines: isObscure ? 1 : maxLines ?? 1,
        minLines: minLines ?? 1,
        restorationId: restorationId,
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isObscure,
        // onEditingComplete: onEditingComplete,
        textAlign: textAlign,
        initialValue: initialValue,
        maxLength: maxLength,
        focusNode: focusNode,
        style: TextStyle(color: Colors.black, fontSize: textSize ?? 15),
        textInputAction: textInputAction ?? TextInputAction.done,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          counterText: '',
          filled: true,

          fillColor: fillColor ?? Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: getProportionateScreenWidth(15),
            color: hintColor,
          ),
          prefixIcon: prefixWidget,

          suffixIcon: suffixWidget,
          isDense: true, // important line
          contentPadding: EdgeInsets.fromLTRB(
              getProportionateScreenWidth(10),
              paddingHeight ?? getProportionateScreenWidth(10),
              getProportionateScreenWidth(10),
              paddingHeight ?? getProportionateScreenHeight(10)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radiusTopLeft ?? 10),
                topRight: Radius.circular(radiusTopRight ?? 10),
                bottomLeft: Radius.circular(radiusBottomLeft ?? 10),
                bottomRight: Radius.circular(radiusBottomRight ?? 10)),
            borderSide: BorderSide(
              // color: kPrimaryColor,
              color: borderColor ?? kPrimaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radiusTopLeft ?? 10),
                topRight: Radius.circular(radiusTopRight ?? 10),
                bottomLeft: Radius.circular(radiusBottomLeft ?? 10),
                bottomRight: Radius.circular(radiusBottomRight ?? 10)),
            borderSide: BorderSide(
              // color: kPrimaryColor,
              color: borderColor ?? kPrimaryColor,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radiusTopLeft ?? 10),
                topRight: Radius.circular(radiusTopRight ?? 10),
                bottomLeft: Radius.circular(radiusBottomLeft ?? 10),
                bottomRight: Radius.circular(radiusBottomRight ?? 10)),
            borderSide: BorderSide(
              // color: kPrimaryColor,
              color: borderColor ?? kPrimaryColor,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(radiusTopLeft ?? 10),
                topRight: Radius.circular(radiusTopRight ?? 10),
                bottomLeft: Radius.circular(radiusBottomLeft ?? 10),
                bottomRight: Radius.circular(radiusBottomRight ?? 10)),
            borderSide: BorderSide(
              // color: kPrimaryColor,
              color: focusedColor ?? kPrimaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
