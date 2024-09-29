import 'package:WellCareBot/components/default_button.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/screens/Home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  void _submitFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      final Email email = Email(
        body: _feedbackController.text,
        subject: 'User Feedback',
        recipients: [
          'katendejericho5@gmail.com',
          'ssekyanzijoel0@gmail.com',
          'baketpaulo@gmail.com',
          'marvinrusoke@gmail.com'
        ],
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Feedback sent successfully!',
                style: GoogleFonts.poppins()),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );

        _feedbackController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send feedback',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Color.fromRGBO(3, 226, 246, 1),
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(17, 6, 60, 1),
          elevation: 0,
          title: Text(
            'Feedback',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'We value your feedback!',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(24),
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Please let us know how we can improve or if you have any suggestions.',
              style: GoogleFonts.nunito(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _feedbackController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Enter your feedback",
                          hintStyle: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(18),
                              fontWeight: FontWeight.w600),
                          filled: true,
                          fillColor: Colors.blueAccent.withOpacity(0.5),
                          contentPadding: const EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(62, 82, 213, 1),
                                  width: 2)),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _isSubmitting
                          ? CircularProgressIndicator(
                              color: Color.fromRGBO(3, 226, 246, 1))
                          : DefaultButton(
                              press: _submitFeedback, text: 'Submit Feedback'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Ensures the content is resized to avoid bottom overflow
    );
  }
}
