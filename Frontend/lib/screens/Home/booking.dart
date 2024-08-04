import 'package:flutter/material.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Physical Therapy Bookings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          BookingCard(
            title: 'Physical Therapy Session',
            therapist: 'Dr. John Doe',
            date: '2024-08-01',
            time: '10:00 AM',
            location: 'Wellness Center, Room 101',
            status: 'Confirmed',
          ),
          BookingCard(
            title: 'Physical Therapy Session',
            therapist: 'Dr. Jane Smith',
            date: '2024-08-05',
            time: '2:00 PM',
            location: 'Health Clinic, Room 203',
            status: 'Pending',
          ),
          BookingCard(
            title: 'Physical Therapy Session',
            therapist: 'Dr. Alice Brown',
            date: '2024-08-10',
            time: '4:00 PM',
            location: 'Wellness Center, Room 101',
            status: 'Cancelled',
          ),
          // Add more BookingCard widgets here as needed
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String title;
  final String therapist;
  final String date;
  final String time;
  final String location;
  final String status;

  BookingCard({
    required this.title,
    required this.therapist,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Therapist: $therapist',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: $date',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Time: $time',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Location: $location',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(
                fontSize: 16,
                color: _getStatusColor(status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
