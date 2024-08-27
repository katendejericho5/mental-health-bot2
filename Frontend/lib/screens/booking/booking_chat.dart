import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/screens/booking/booking_details.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Appointments',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent, // Transparent background
      ),
      body: Stack(
        children: [
          // First full-screen SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/undraw_chat_re_re1u.svg',
              fit: BoxFit.contain,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          // Second SVG as a design element or additional background
          Positioned(
            top: 20,
            left: 20,
            width: 80,
            height: 80,
            child: SvgPicture.asset(
              'assets/undraw_mindfulness_8gqa.svg',
              fit: BoxFit.contain,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2)
                  : Colors.black.withOpacity(0.2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<List<Booking>>(
              stream: FirestoreService().getUserBookings(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 64),
                        SizedBox(height: 8),
                        Text(
                          'Error loading bookings.',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Please try again later.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, color: Colors.grey, size: 64),
                        SizedBox(height: 8),
                        Text(
                          'No bookings found.',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'You don’t have any appointments scheduled.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final bookings = snapshot.data!;

                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1,
                      margin: EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(booking.userProfilePictureUrl),
                          radius: 30,
                        ),
                        title: Text(
                          booking.userName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${booking.appointmentDate} at ${booking.time}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                          ),
                        ),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookingDetailsPage(booking: booking),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
