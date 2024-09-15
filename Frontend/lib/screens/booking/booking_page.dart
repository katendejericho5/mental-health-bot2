import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/screens/booking/booking_details.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Appointments',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
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
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Please try again later.',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
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
                      'No appointments found.',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      'You don’t have any appointments scheduled.',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(booking.userProfilePictureUrl),
                      radius: 30,
                    ),
                    title: Text(
                      booking.userName,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      '${booking.appointmentDate} at ${booking.time}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
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
    );
  }
}
