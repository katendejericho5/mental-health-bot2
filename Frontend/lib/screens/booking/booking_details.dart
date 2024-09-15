import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/models/therapist_model.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingDetailsPage extends StatelessWidget {
  final Booking booking;

  BookingDetailsPage({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Booking Details',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            // Section Title: Bookings

            // User Details Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(booking.userProfilePictureUrl),
                      radius: 40,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.userName,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            booking.userEmail,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Appointment Details Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Details',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                    Divider(height: 24),
                    _buildDetailRow(context, Icons.calendar_today_outlined,
                        'Date: ${booking.appointmentDate}'),
                    _buildDetailRow(context, Icons.access_time_outlined,
                        'Time: ${booking.time}'),
                    _buildDetailRow(context, Icons.info_outline,
                        'Status: ${booking.status}'),
                    _buildDetailRow(context, Icons.notes_outlined,
                        'Notes: ${booking.notes}'),
                  ],
                ),
              ),
            ),

            // Therapist Details StreamBuilder
            StreamBuilder<Therapist>(
              stream:
                  FirestoreService().getTherapistDetails(booking.therapistId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 64),
                        SizedBox(height: 8),
                        Text('Error loading therapist details.',
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text('Please try again later.',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text('Therapist details not found.',
                        style: Theme.of(context).textTheme.bodyLarge),
                  );
                }

                final therapist = snapshot.data!;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Therapist Details',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Divider(height: 24),
                        _buildDetailRow(context, Icons.person_outline,
                            'Name: ${therapist.name}'),
                        _buildDetailRow(context, Icons.local_hospital_outlined,
                            'Hospital: ${therapist.hospital}'),
                        _buildDetailRow(context, Icons.location_city_outlined,
                            'City: ${therapist.city}'),
                        SizedBox(height: 16),
                        Text(
                          'Availability',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: therapist.availability
                              .map(
                                (slot) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    '- $slot',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
