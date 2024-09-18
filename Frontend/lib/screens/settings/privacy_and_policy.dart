import 'package:WellCareBot/constant/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final config = MarkdownConfig.darkConfig;
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 6, 60, 1),
          elevation: 0,
          title: Text(
            'Privacy and Policy',
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
      body: Container(
        child: FutureBuilder(
          future: rootBundle.loadString('assets/markdown/privacy_policy.md'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return MarkdownWidget(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                data: snapshot.data!,
                config: config,
              );
            }

            return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromRGBO(3, 226, 246, 1)));
          },
        ),
      ),
    );
  }
}
