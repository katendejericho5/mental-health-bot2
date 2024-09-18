import 'package:WellCareBot/constant/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 6, 60, 1),
          elevation: 0,
          title: Text(
            'About Us',
            style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w700),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(getProportionateScreenHeight(15)),
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Divider(
                  color: Colors.white,
                ),
              ))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'About WellCareBot',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(24),
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Our Mission',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(20),
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'At WellCareBot, our mission is to provide accessible and effective mental health support through technology. We aim to assist individuals in managing their mental health by offering a companion that listens and responds empathetically.',
              style: GoogleFonts.poppins(
                textStyle: GoogleFonts.nunito(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Our Vision',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(20),
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'We envision a world where everyone has access to mental health support, regardless of their location or financial situation. Through WellCareBot, we strive to break down barriers and promote mental well-being for all.',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 20),
            Text(
              'Our Team',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(20),
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'Our team is composed of dedicated professionals with a passion for mental health and technology. We work tirelessly to improve WellCareBot and ensure it meets the needs of our users.',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Us',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(20),
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'If you have any questions, feedback, or need support, please feel free to reach out to us at wellcarebot@gmail.com. We are here to help and support you in your mental health journey.',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
