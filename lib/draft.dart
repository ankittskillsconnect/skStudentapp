// import 'package:flutter/material.dart';
// import 'DescriptionTabContent.dart';
// import 'JobDetailHeader.dart';
// import 'CompanyTabContent.dart';
// import 'SummaryTabContent.dart';
//
// class JobDetailPage2 extends StatefulWidget {
//   const JobDetailPage2({super.key});
//
//   @override
//   State<JobDetailPage2> createState() => _JobDetailPage2State();
// }
//
// class _JobDetailPage2State extends State<JobDetailPage2> {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final double widthScale = size.width / 360;
//     final double heightScale = size.height / 640;
//
//     final double fontScale = (widthScale * 0.8).clamp(0.8, 1.2);
//
//     final double sizeScale = (widthScale * 0.9).clamp(0.9, 1.3);
//
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(50 * heightScale),
//           child: Padding(
//             padding: EdgeInsets.all(1 * sizeScale),
//             child: AppBar(
//               backgroundColor: Colors.white,
//               elevation: 0,
//               centerTitle: true,
//               titleSpacing: 0,
//               title: Text(
//                 "Job Detail",
//                 style: TextStyle(
//                   fontSize: 25 * fontScale,
//                   color: const Color(0xFF003840),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               leading: Padding(
//                 padding: EdgeInsets.only(left: 12 * sizeScale),
//                 child: Center(
//                   child: Container(
//                     width: 46 * sizeScale,
//                     height: 46 * sizeScale,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.grey.shade300,
//                         width: 1 * sizeScale,
//                       ),
//                     ),
//                     child: IconButton(
//                       padding: EdgeInsets.all(12),
//                       icon: Icon(
//                         Icons.arrow_back_ios,
//                         size: 22 * sizeScale,
//                         color: const Color(0xFF003840),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                 ),
//               ),
//               actions: [
//                 Padding(
//                   padding: EdgeInsets.only(right: 12 * sizeScale),
//                   child: Center(
//                     child: Container(
//                       width: 46 * sizeScale,
//                       height: 46 * sizeScale,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.grey.shade300,
//                           width: 1 * sizeScale,
//                         ),
//                       ),
//                       child: IconButton(
//                         padding: EdgeInsets.zero,
//                         icon: Icon(
//                           Icons.share,
//                           size: 22 * sizeScale,
//                           color: const Color(0xFF003840),
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             const JobHeaderSection(),
//             Container(
//               margin: EdgeInsets.symmetric(
//                 horizontal: 16 * sizeScale,
//                 vertical: 12 * sizeScale,
//               ),
//               padding: EdgeInsets.all(4 * sizeScale),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEBF6F7),
//                 borderRadius: BorderRadius.circular(30 * sizeScale),
//               ),
//               child: TabBar(
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 indicator: BoxDecoration(
//                   color: const Color(0xFF005E6A),
//                   borderRadius: BorderRadius.circular(30 * sizeScale),
//                 ),
//                 labelColor: Colors.white,
//                 indicatorColor: Colors.white,
//                 unselectedLabelColor: const Color(0xFF003840),
//                 dividerColor: Colors.transparent,
//                 tabs: [
//                   Tab(
//                     child: Text(
//                       'Description',
//                       style: TextStyle(fontSize: 16 * fontScale),
//                     ),
//                   ),
//                   Tab(
//                     child: Text(
//                       'Company',
//                       style: TextStyle(fontSize: 16 * fontScale),
//                     ),
//                   ),
//                   Tab(
//                     child: Text(
//                       'Summary',
//                       style: TextStyle(fontSize: 16 * fontScale),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Expanded(
//               child: TabBarView(
//                 children: [
//                   DescriptionTabContent(),
//                   Companytabcontent(),
//                   Summarytabcontent(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: Container(
//           padding: EdgeInsets.symmetric(
//             vertical: 12 * sizeScale,
//             horizontal: 140 * sizeScale,
//           ),
//           color: const Color(0xFFEFF8F9),
//           child: Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF005E6A),
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: 16 * sizeScale),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30 * sizeScale),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     "Apply Now",
//                     style: TextStyle(
//                       fontSize: 16 * fontScale,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
