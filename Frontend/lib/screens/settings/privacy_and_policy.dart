import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy and Policy",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: rootBundle.loadString('assets/markdown/privacy_policy.md'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return MarkdownWidget(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                data: snapshot.data!,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
