import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/models/therapist_model.dart';
import 'package:WellCareBot/services/cloud_service.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 5, 5, 10),
        child: ListView(
          children: [
            // User Details
            Card(
              elevation: 1,
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16,left: 16,top: 16,right: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(booking.userProfilePictureUrl),
                      radius: 30,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.userName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${booking.userEmail}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Appointment Details
            Card(
              elevation: 1,
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    _buildDetailRow(context, Icons.calendar_today,
                        'Date: ${booking.appointmentDate}'),
                    _buildDetailRow(
                        context, Icons.access_time, 'Time: ${booking.time}'),
                    _buildDetailRow(
                        context, Icons.info, 'Status: ${booking.status}'),
                    _buildDetailRow(
                        context, Icons.notes, 'Notes: ${booking.notes}'),
                  ],
                ),
              ),
            ),
            // Therapist Details
            StreamBuilder<Therapist>(
              stream:
                  FirestoreService().getTherapistDetails(booking.therapistId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('Therapist details not found.'));
                }

                final therapist = snapshot.data!;

                return Card(
                  elevation: 1,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Therapist Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 8),
                        _buildDetailRow(
                            context, Icons.person, 'Name: ${therapist.name}'),
                        _buildDetailRow(context, Icons.local_hospital,
                            'Hospital: ${therapist.hospital}'),
                        _buildDetailRow(context, Icons.location_city,
                            'City: ${therapist.city}'),
                        SizedBox(height: 8),
                        Text(
                          'Availability:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ...therapist.availability
                            .map(
                              (slot) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  '- $slot',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a row with an icon and text
  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
