import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/screens/booking/booking_details.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('My Appointments'),
        ),
      ),
      body: StreamBuilder<List<Booking>>(
        stream: FirestoreService().getUserBookings(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(booking.userProfilePictureUrl),
                ),
                title: Text('${booking.userName} - ${booking.status}'),
                subtitle: Text('${booking.appointmentDate} at ${booking.time}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookingDetailsPage(booking: booking),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
