import 'package:WellCareBot/constant/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({super.key, this.text, this.press, this.icon});
  final String? text;
  final Function? press;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(0, 33, 35, 1),
                  Color.fromRGBO(3, 226, 246, 1)
                ]),
            borderRadius: BorderRadius.circular(13.0)),
        child: TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.transparent,
          ),
          onPressed: press as void Function()?,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null ? Icon(icon!, color: Colors.white) : Container(),
              icon != null ? const SizedBox(width: 10) : Container(),
              Text(text!,
                  style: GoogleFonts.nunitoSans(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
