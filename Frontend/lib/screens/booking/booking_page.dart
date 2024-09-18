import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/models/booking_model.dart';
import 'package:WellCareBot/models/therapist_model.dart';
import 'package:WellCareBot/screens/booking/booking_details.dart';
import 'package:WellCareBot/services/cloud_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(17, 6, 60, 1),
        elevation: 0,
        title: Text(
          'My Appointments',
          style: GoogleFonts.nunito(
              color: Colors.white,
              fontSize: getProportionateScreenWidth(22),
              fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              FontAwesomeIcons.calendarPlus,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search appointment...",
                  hintStyle: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.w700),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.blueAccent.withOpacity(0.5),
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(62, 82, 213, 1), width: 2)),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Booking>>(
                stream: FirestoreService().getUserBookings(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Color.fromRGBO(3, 226, 246, 1)));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red, size: 64),
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
                        return StreamBuilder<Therapist>(
                          stream: FirestoreService()
                              .getTherapistDetails(booking.therapistId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Color.fromRGBO(3, 226, 246, 1),
                              ));
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red, size: 64),
                                    SizedBox(height: 8),
                                    Text('Error loading therapist details.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                    Text('Please try again later.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ],
                                ),
                              );
                            } else if (!snapshot.hasData) {
                              return Center(
                                child: Text('Therapist details not found.',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              );
                            }
                            final therapist = snapshot.data!;
                            // might add calendar later
                            return Container(
                              height: getProportionateScreenHeight(180),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Color.fromRGBO(62, 82, 213, 0.8)),
                              margin: EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Image.network(
                                          therapist.image,
                                          fit: BoxFit.cover,
                                          height:
                                              getProportionateScreenHeight(140),
                                          width:
                                              getProportionateScreenWidth(100),
                                        )),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8.0),
                                            child: Text(therapist.name,
                                                style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getProportionateScreenWidth(
                                                            18),
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                          SizedBox(
                                            width:
                                                getProportionateScreenWidth(20),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, top: 8.0),
                                            child: Row(
                                              children: [
                                                Text(booking.time,
                                                    style: GoogleFonts.nunito(
                                                        color: Colors.white,
                                                        fontSize:
                                                            getProportionateScreenWidth(
                                                                16),
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                      FontAwesomeIcons
                                                          .solidClock,
                                                      color: Colors.white,
                                                      size:
                                                          getProportionateScreenWidth(
                                                              15)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                            booking.appointmentDate
                                                .split('T')[0],
                                            style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        14),
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 8.0),
                                        child: Text(
                                            '${therapist.hospital}\n${therapist.city}',
                                            style: GoogleFonts.nunito(
                                                color: Colors.white,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        12),
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height:
                                              getProportionateScreenHeight(30),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookingDetailsPage(
                                                          booking: booking),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'View',
                                              style: TextStyle(
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          12)),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              // child: ListTile(
                              //   contentPadding: EdgeInsets.symmetric(
                              //       horizontal: 16.0, vertical: 8.0),
                              //   leading: ClipRRect(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(10)),
                              //       child: Image.network(
                              //         therapist.image,
                              //         fit: BoxFit.cover,
                              //         height: getProportionateScreenHeight(300),
                              //         width: getProportionateScreenWidth(80),
                              //       )),
                              // title: Text(
                              //   therapist.name,
                              //   style: GoogleFonts.poppins(
                              //     textStyle: TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                              //   subtitle: Text(
                              //     '${booking.appointmentDate} at ${booking.time}',
                              //     style: GoogleFonts.poppins(
                              //       textStyle: TextStyle(
                              //         color: Colors.grey,
                              //         fontSize: 14,
                              //       ),
                              //     ),
                              //   ),
                              //   trailing:
                              //       Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              //   onTap: () {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) =>
                              //             BookingDetailsPage(booking: booking),
                              //       ),
                              //     );
                              //   },
                              // ),
                            );
                          },
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
