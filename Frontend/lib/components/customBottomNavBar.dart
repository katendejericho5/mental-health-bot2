// import 'package:baraza/screens/chat/chat_page.dart';
// import 'package:baraza/screens/emr/emr_page.dart';
// import 'package:baraza/screens/posts/post_page.dart';
// import 'package:baraza/screens/tasks/tasks_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CustomBottomNavBar extends ConsumerStatefulWidget {
//   const CustomBottomNavBar(
//       {super.key, required this.onChange, required this.newIndex});
//   final ValueChanged<int> onChange;
//   final int newIndex;
//   @override
//   CustomBottomNavBarState createState() => CustomBottomNavBarState();
// }

// class CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
//   late int currentIndex = widget.newIndex;

//   @override
//   Widget build(BuildContext context) {
//     double displayWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         //margin: EdgeInsets.all(displayWidth * .05),
//         height: displayWidth * .175,
//         decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 33, 94, 36),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.1),
//                 blurRadius: 30,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//             borderRadius: BorderRadius.circular(50),
//             border: Border.all(color: Colors.transparent, width: 10)),
//         child: ListView.builder(
//           itemCount: 4,
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
//           itemBuilder: (context, index) => InkWell(
//             onTap: () {
//               setState(() {
//                 currentIndex = index;
//                 HapticFeedback.lightImpact();
//               });
//               Navigator.pushNamed(context, NavigationScreen[index],
//                   arguments: index);
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: Stack(
//               children: [
//                 AnimatedContainer(
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   width: index == currentIndex
//                       ? displayWidth * .32
//                       : displayWidth * .18,
//                   alignment: Alignment.center,
//                   child: AnimatedContainer(
//                     duration: const Duration(seconds: 1),
//                     curve: Curves.fastLinearToSlowEaseIn,
//                     height: index == currentIndex ? displayWidth * .12 : 0,
//                     width: index == currentIndex ? displayWidth * .32 : 0,
//                     decoration: BoxDecoration(
//                       color: index == currentIndex
//                           ? Colors.white
//                           : Colors.transparent,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                 ),
//                 AnimatedContainer(
//                   duration: const Duration(seconds: 1),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   width: index == currentIndex
//                       ? displayWidth * .31
//                       : displayWidth * .18,
//                   alignment: Alignment.center,
//                   child: Stack(
//                     children: [
//                       Row(
//                         children: [
//                           AnimatedContainer(
//                             duration: const Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             width:
//                                 index == currentIndex ? displayWidth * .13 : 0,
//                           ),
//                           AnimatedOpacity(
//                             opacity: index == currentIndex ? 1 : 0,
//                             duration: const Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             child: Text(
//                               index == currentIndex ? listOfStrings[index] : '',
//                               // ignore: prefer_const_constructors
//                               style: TextStyle(
//                                 color: const Color.fromARGB(235, 7, 2, 66),
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           AnimatedContainer(
//                             duration: const Duration(seconds: 1),
//                             curve: Curves.fastLinearToSlowEaseIn,
//                             width:
//                                 index == currentIndex ? displayWidth * .03 : 20,
//                           ),
//                           Icon(
//                             listOfIcons[index],
//                             size: displayWidth * .072,
//                             color: index == currentIndex
//                                 ? const Color.fromARGB(235, 7, 2, 66)
//                                 : Colors.black,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<IconData> listOfIcons = [
//     FontAwesomeIcons.newspaper,
//     FontAwesomeIcons.comment,
//     FontAwesomeIcons.fileMedical,
//     FontAwesomeIcons.listCheck,
//   ];

//   List<String> listOfStrings = [
//     'Posts',
//     'Chat',
//     'Emr',
//     'Tasks',
//   ];

//   // ignore: non_constant_identifier_names
//   List<String> NavigationScreen = [
//     PostsPage.routeName,
//     ChatPage.routeName,
//     EmrPage.routeName,
//     TasksPage.routeName
//   ];
// }
