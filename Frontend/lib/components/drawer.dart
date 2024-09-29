import 'package:WellCareBot/constant/constants.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

Widget customDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 217, 239, 241),
          ),
          child: Column(
            children: [
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/illustrations/intro.png',
                    height: getProportionateScreenHeight(60),
                    width: getProportionateScreenWidth(60),
                  ),
                  Text('Business 360',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                            color: kBottomNavColor,
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(30)),
                      )),
                ],
              ),
            ],
          ),
        ),
        ListTile(
          title: Text(
            'Profile',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: const Icon(
            FontAwesomeIcons.user,
            color: kBottomNavColor,
          ),
          onTap: () {},
        ),
        // ListTile(
        //   title: Text(
        //     'Sales Returns',
        //     style: GoogleFonts.nunitoSans(
        //       textStyle: TextStyle(
        //         color: Colors.black,
        //         fontSize: getProportionateScreenWidth(18),
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        //   leading: const Icon(
        //     FontAwesomeIcons.ban,
        //     color: kBottomNavColor,
        //   ),
        //   onTap: () {},
        // ),
        // ListTile(
        //   title: Text(
        //     'Credit Memos',
        //     style: GoogleFonts.nunitoSans(
        //       textStyle: TextStyle(
        //         color: Colors.black,
        //         fontSize: getProportionateScreenWidth(18),
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        //   leading: const Icon(
        //     FontAwesomeIcons.clipboardList,
        //     color: kBottomNavColor,
        //   ),
        //   onTap: () {},
        // ),
        ListTile(
          title: Text(
            'Logout',
            style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading:
              const Icon(FontAwesomeIcons.signOutAlt, color: kBottomNavColor),
          onTap: () async {},
        ),
      ],
    ),
  );
}
