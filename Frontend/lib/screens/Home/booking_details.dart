import 'package:WellCareBot/models/booking_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsPage extends StatelessWidget {
  final Booking booking;

  BookingDetailsPage({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(booking.userProfilePictureUrl),
                ),
                SizedBox(width: 16),
                Text(
                  booking.userName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Appointment Date: ${booking.appointmentDate}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Time: ${booking.time}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Therapist ID: ${booking.therapistId}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Status: ${booking.status}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Notes: ${booking.notes}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
