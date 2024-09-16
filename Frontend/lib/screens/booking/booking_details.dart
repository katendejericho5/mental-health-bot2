import 'package:WellCareBot/constant/size_config.dart';
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
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 6, 60, 1),
        elevation: 0,
        title: Text(
          'Booking Details',
          style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(22),
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Image.network(
                            therapist.image,
                            fit: BoxFit.cover,
                            height: getProportionateScreenHeight(230),
                            width: getProportionateScreenWidth(340),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(therapist.name,
                          style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(22),
                              fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text('${therapist.hospital} - ${therapist.city}',
                          style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(18),
                              fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    // Appointment Details Card
                    Card(
                      elevation: 3,
                      color: Colors.blueAccent.withOpacity(0.5),
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
                              style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w700),
                            ),
                            Divider(height: 24),
                            _buildDetailRow(context, Icons.calendar_today,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Availability',
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: therapist.availability
                          .map(
                            (slot) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                '- $slot',
                                style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontSize: getProportionateScreenWidth(15),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
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
          Icon(icon, color: Color.fromRGBO(108, 104, 250, 1), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
