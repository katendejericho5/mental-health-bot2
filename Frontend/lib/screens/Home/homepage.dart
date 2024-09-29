import 'package:WellCareBot/components/default_button.dart';
import 'package:WellCareBot/constant/size_config.dart';
import 'package:WellCareBot/screens/groups/group_list.dart';
import 'package:WellCareBot/screens/modes/companion_chatbot.dart';
import 'package:WellCareBot/screens/modes/therapist_chatbot.dart';
import 'package:WellCareBot/screens/booking/booking_page.dart';
import 'package:WellCareBot/screens/settings/profile_page.dart';
import 'package:WellCareBot/screens/settings/settings.dart';
import 'package:WellCareBot/services/api_service.dart';
import 'package:WellCareBot/services/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<Widget> _pages() => [
        HomeScreen(),
        BookingsPage(),
        GroupListScreen(),
        ProfilePage(),
      ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(17, 6, 60, 1),
                Color.fromRGBO(37, 14, 132, 1)
              ]),
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: _pages(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Theme(
              data: Theme.of(context)
                  .copyWith(canvasColor: Color.fromRGBO(166, 174, 236, 1)),
              child: BottomNavigationBar(
                selectedFontSize: getProportionateScreenWidth(25),
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
                items: [
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.house,
                    label: 'Home',
                    index: 0,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.calendarCheck,
                    label: 'Bookings',
                    index: 1,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.layerGroup,
                    label: 'Groups',
                    index: 2,
                  ),
                  _buildBottomNavigationBarItem(
                    icon: FontAwesomeIcons.user,
                    label: 'Profile',
                    index: 3,
                  ),
                ],
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Color.fromRGBO(17, 6, 60, 0.8),
                unselectedItemColor: Colors.black,
                selectedLabelStyle: GoogleFonts.nunito(
                    color: Color.fromRGBO(17, 6, 60, 1),
                    fontSize: getProportionateScreenWidth(12),
                    fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 10, // Reduced font size
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
                elevation: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: FaIcon(
          icon,
          size: 20,
          color: isSelected ? const Color.fromRGBO(17, 6, 60, 1) : Colors.black,
        ),
      ),
      label: label,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _darkMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();
  String? therapistThreadId;
  String? companionThreadId;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _darkMode = Provider.of<ThemeNotifier>(context, listen: false).themeMode ==
        ThemeMode.dark;
  }

  Future<void> _initializeData() async {
    try {
      await _getOrSetThreadIdTherapist();
      await _getOrSetThreadIdCompanion();
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _getOrSetThreadIdTherapist() async {
    therapistThreadId = await _apiService.getThreadId('therapist');
  }

  Future<void> _getOrSetThreadIdCompanion() async {
    companionThreadId = await _apiService.getThreadId('companion');
  }

  Future<String> _fetchProfilePictureURL() async {
    final User user = _auth.currentUser!;
    final storageRef = _storage
        .ref()
        .child('userProfilePictures/${user.uid}/profilePicture.jpg');

    try {
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching profile picture: $e');
      return '';
    }
  }

  // Future<void> _selectFeelingsDialogue() async {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Padding(
  //           padding: EdgeInsets.only(bottom: getProportionateScreenHeight(170)),
  //           child: AlertDialog(
  //             backgroundColor: Color.fromRGBO(37, 14, 132, 1),
  //             clipBehavior: Clip.hardEdge,
  //             title: Column(
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'How do you feel today?',
  //                       style: GoogleFonts.nunito(
  //                           color: Colors.white,
  //                           fontSize: getProportionateScreenWidth(18),
  //                           fontWeight: FontWeight.w700),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () => Navigator.pop(context),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(6.0),
  //                         child: Icon(Icons.cancel, color: Colors.white),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text(
  //                     'If you are feeling unsure, don\'t worry, our AI can still learn what you feel as you are talking to it ☺️.',
  //                     style: GoogleFonts.nunito(
  //                         color: Colors.white,
  //                         fontSize: getProportionateScreenWidth(15),
  //                         fontWeight: FontWeight.normal),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             content: Column(
  //               children: [
  //                 SizedBox(
  //                   width: getProportionateScreenWidth(270),
  //                   child: Expanded(
  //                     child: CarouselSlider(
  //                       options: CarouselOptions(
  //                           height: getProportionateScreenHeight(170.0)),
  //                       items: [
  //                         'assets/images/home/emotions/happy.png',
  //                         'assets/images/home/emotions/bored.png',
  //                         'assets/images/home/emotions/cool.png',
  //                         'assets/images/home/emotions/expressionless.png',
  //                         'assets/images/home/emotions/funny.png',
  //                         'assets/images/home/emotions/irritated.png',
  //                         'assets/images/home/emotions/sad.png',
  //                         'assets/images/home/emotions/sleepy.png',
  //                         'assets/images/home/emotions/special.png'
  //                       ].map((i) {
  //                         return Builder(
  //                           builder: (BuildContext context) {
  //                             return Container(
  //                                 width: MediaQuery.of(context).size.width,
  //                                 margin: EdgeInsets.symmetric(horizontal: 5.0),
  //                                 child: Column(
  //                                   children: [
  //                                     Image.asset(
  //                                       i,
  //                                       height:
  //                                           getProportionateScreenHeight(130),
  //                                     ),
  //                                     Text(
  //                                       i.split('/')[4].split('.')[0],
  //                                       style: GoogleFonts.nunito(
  //                                           color: Colors.white,
  //                                           fontSize:
  //                                               getProportionateScreenWidth(18),
  //                                           fontWeight: FontWeight.bold),
  //                                     )
  //                                   ],
  //                                 ));
  //                           },
  //                         );
  //                       }).toList(),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //             actions: [
  //               DefaultButton(text: 'Continue'),
  //             ],
  //           ),
  //         );
  //       });
  // }

  Future<String> _fetchUserName() async {
    final User user = _auth.currentUser!;
    // Check if the user has a displayName (Google Sign-In)
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }

    // Fallback to Firestore data for email/password sign-in
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    return userDoc['fullName'] ?? 'User';
  }

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
      Provider.of<ThemeNotifier>(context, listen: false).setThemeMode(
        _darkMode ? ThemeMode.dark : ThemeMode.light,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 6, 60, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 14, 132, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfilePicture(
                profilePictureUrlFuture: _fetchProfilePictureURL()),
          ),
        ),
        title: FutureBuilder<String>(
            future: _fetchUserName(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome!",
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        snapshot.data!,
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(23),
                            fontWeight: FontWeight.w700),
                      )
                    ]);
              } else {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome!",
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Our Dear',
                        style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(23),
                            fontWeight: FontWeight.w700),
                      )
                    ]);
              }
            }),
        actions: [
          // IconButton(
          //   icon: FaIcon(
          //     _darkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.cloudMoon,
          //     color: _darkMode ? Colors.lightBlue : Colors.blue.shade700,
          //   ),
          //   onPressed: _toggleTheme,
          // ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.solidBell,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => SettingsPage()),
              // );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(17, 6, 60, 1),
                Color.fromRGBO(37, 14, 132, 1)
              ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: getProportionateScreenHeight(200),
                      width: getProportionateScreenWidth(340),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/home/home/zebra.jpg"),
                            opacity: 0.04,
                            fit: BoxFit.cover,
                          ),
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(75, 117, 159, 1),
                                Color.fromRGBO(138, 44, 230, 1)
                              ]),
                          borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  Positioned(
                      top: getProportionateScreenHeight(-70),
                      right: -70,
                      child: SizedBox(
                        width: getProportionateScreenWidth(250),
                        height: getProportionateScreenHeight(350),
                        child: Image.asset(
                          'assets/images/home/home/mental.png',
                        ),
                      )),
                  Positioned(
                    left: getProportionateScreenWidth(10),
                    bottom: getProportionateScreenHeight(18),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(20),
                        vertical: getProportionateScreenWidth(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Start a conversation\n',
                          style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: getProportionateScreenWidth(18),
                              fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'with\n',
                              style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: 'WellCarebot\n',
                              style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(22),
                                  fontWeight: FontWeight.w800),
                            ),
                            TextSpan(
                              text: 'right now!\n',
                              style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: getProportionateScreenWidth(18),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //     left: getProportionateScreenWidth(20),
                  //     bottom: getProportionateScreenHeight(15),
                  //     child: SizedBox(
                  //       width: getProportionateScreenWidth(150),
                  //       height: getProportionateScreenHeight(65),
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: DefaultButton(
                  //           text: 'Start',
                  //           press: _selectFeelingsDialogue,
                  //         ),
                  //       ),
                  //     ),
                  // ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0, bottom: 8.0),
                    child: Text(
                      'Start your mindfulness\njourney',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(23),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: getProportionateScreenHeight(250),
                      width: getProportionateScreenWidth(150),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(75, 117, 159, 1),
                                Color.fromRGBO(217, 237, 235, 0.5)
                              ]),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/home/modes/companion.png',
                            height: getProportionateScreenHeight(180),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: getProportionateScreenHeight(40),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CompanionChatBot(
                                        threadId: 'companion_thread_id',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Companion',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(12)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: getProportionateScreenHeight(250),
                      width: getProportionateScreenWidth(150),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(75, 117, 159, 1),
                                Color.fromRGBO(217, 237, 235, 0.5)
                              ]),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: [
                          Image.asset('assets/images/home/modes/therapist.png',
                              height: getProportionateScreenHeight(180)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: getProportionateScreenHeight(40),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.greenAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TherapistChatBot(
                                        threadId: 'therapist_thread_id',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Therapist',
                                  style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(12)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePicture extends StatelessWidget {
  final Future<String> profilePictureUrlFuture;

  ProfilePicture({required this.profilePictureUrlFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: profilePictureUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            backgroundImage: AssetImage('assets/relaxation-7282116_1280.jpg'),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return CircleAvatar(
            backgroundImage: AssetImage('assets/relaxation-7282116_1280.jpg'),
          );
        } else {
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
          );
        }
      },
    );
  }
}
