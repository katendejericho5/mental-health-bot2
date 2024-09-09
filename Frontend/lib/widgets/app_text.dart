import 'package:WellCareBot/constant/constants.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final Color? color;
  final double fontSize;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final int? maxLines;

  const AppText(this.text,
      {super.key,
      this.color = kPrimaryLightColor,
      this.fontSize = 15,
      this.textAlign,
      this.maxLines,
      this.fontFamily,
      this.fontWeight});
  const AppText.medium(this.text,
      {super.key,
      this.color = kPrimaryLightColor,
      this.fontSize = 19,
      this.textAlign,
      this.maxLines,
      this.fontFamily,
      this.fontWeight});
  const AppText.large(this.text,
      {super.key,
      this.color = kPrimaryLightColor,
      this.fontSize = 24,
      this.textAlign,
      this.maxLines,
      this.fontFamily,
      this.fontWeight = FontWeight.w700});
  const AppText.small(this.text,
      {super.key,
      this.color = kPrimaryLightColor,
      this.fontFamily,
      this.fontSize = 12,
      this.textAlign,
      this.maxLines,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color,
          fontSize: getProportionateScreenWidth(fontSize),
          fontWeight: fontWeight,
          fontFamily: fontFamily),
    );
  }
}
