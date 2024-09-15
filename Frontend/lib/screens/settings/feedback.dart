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
            content:
                Text('Failed to send feedback', style: GoogleFonts.poppins()),
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
      appBar: AppBar(
        title: Text('Feedback', style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We value your feedback!',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Please let us know how we can improve or if you have any suggestions.',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
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
                          labelText: 'Your Feedback',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          hintText: 'Enter your feedback here...',
                          hintStyle: GoogleFonts.poppins(),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 16.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _isSubmitting
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submitFeedback,
                              child: Text('Submit Feedback',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueGrey[800],
                                padding: EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 40.0,
                                ),
                                textStyle: TextStyle(fontSize: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                              ),
                            ),
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
