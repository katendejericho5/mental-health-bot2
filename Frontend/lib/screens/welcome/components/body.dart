import "package:WellCareBot/components/default_button.dart";
import "package:WellCareBot/constant/size_config.dart";
import "package:WellCareBot/screens/Home/introduction.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Image(
        image: AssetImage('assets/images/onboarding/welcome.png'),
        height: getProportionateScreenHeight(350),
      ),
      Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 0,
            color: Colors.white
                .withOpacity(0.35), //Colors.redAccent.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      "Welcome to WellCareBot",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "The starting point for your journey\ntowards emotional well being Together",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DefaultButton(
                        text: "Get Started",
                        press: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IntroductionPage(), // Replace with your target screen
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))
    ]));
  }
}
