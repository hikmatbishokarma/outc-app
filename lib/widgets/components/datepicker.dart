

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// Widget buildDatePickerfordate() => SizedBox(
//         height: 200,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 150,
//               child: CupertinoDatePicker(
//                 minimumYear: DateTime.now().year,

//                 // maximumDate: DateTime.now(),
//                 minimumDate: DateTime.now(),
//                 maximumYear: 2030,
//                 initialDateTime: DateTime.now(),
//                 mode: CupertinoDatePickerMode.date,
//                 onDateTimeChanged: (dateTime) => setState(() {
//                   dateTime = dateTime;
//                   datePicked = dateTime;
//                   // datePickedfortime = dateTime;

//                   // datePickedfortime == DateTime.now()
//                   //     ? selectedtime =
//                   //         DateFormat('hh:mma').format(DateTime.now())
//                   //     : DateFormat('hh:mma').format(dateTime);
//                   print("datePickedfortime" + datePickedfortime.toString());
//                   print(selectedtime);

//                   selecteddate = DateFormat('MM-dd-yyyy').format(dateTime);

//                   if (selecteddate == currentdate) {
//                     datePickedfortime = DateTime.now();
//                     selectedtime = DateFormat('hh:mm a').format(DateTime.now());
//                   } else {
//                     datePickedfortime = dateTime;
//                     selectedtime = DateFormat('hh:mm a').format(DateTime.now());
//                   }
//                 }),
//               ),
//             ),

//             ElevatedButton(
//               child: const Text(
//                 'Confirm',
//                 style: TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.white,
//                   fontFamily: 'Poppins',
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               onPressed: () async {
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   backgroundColor: Color(0xffFF6700),
//                   fixedSize: const Size(93, 28),
//                   textStyle: const TextStyle(
//                     fontSize: 12.0,
//                     color: Colors.white,
//                     fontFamily: 'Poppins-regular',
//                     fontWeight: FontWeight.w700,
//                   )),
//             ),
//             // Text(
//             //   "Selected Date: " + selecteddate,
//             //   style: TextStyle(
//             //       fontSize: 14.0,
//             //       color: Color(0xff303135),
//             //       fontFamily: 'poppins',
//             //       fontWeight: FontWeight.w700),
//             // ),
//           ],
//         ),
//       );