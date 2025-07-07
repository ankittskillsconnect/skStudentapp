// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class Interviewscreenappbar extends StatelessWidget implements PreferredSizeWidget {
//   const Interviewscreenappbar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final width = mq.size.width;
//     final height = mq.size.height;
//
//     final double horizontalPadding = width * 0.05; // ~18
//     final double verticalPadding = height * 0.015; // ~12
//     final double iconSize = width * 0.05; // ~20
//     final double radius = width * 0.13; // ~46
//     final double titleFontSize = width * 0.045; // ~16–18
//     final double subtitleFontSize = width * 0.04; // ~14–16
//
//     return SafeArea(
//       child: Container(
//         height: preferredSize.height,
//         color: const Color(0xFFEBF6F7),
//         padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: radius / 2,
//               backgroundColor: Colors.white,
//               child: Padding(
//                 padding: EdgeInsets.all(width * 0.015),
//                 child: SvgPicture.asset(
//                   "assets/tata.svg",
//                   fit: BoxFit.contain,
//                   colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.lighten),
//                 ),
//               ),
//             ),
//             SizedBox(width: width * 0.04), // ~16
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'TATA Group',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: titleFontSize,
//                       color: const Color(0xFF25282B),
//                     ),
//                   ),
//                   SizedBox(height: height * 0.004),
//                   Text(
//                     'Global Conglomerate',
//                     style: TextStyle(
//                       fontSize: subtitleFontSize,
//                       color: const Color(0xFF6A8E92),
//                       fontWeight: FontWeight.w400,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: width * 0.015),
//             iconCircleButton(iconSize, Icons.search),
//             iconCircleButton(iconSize, Icons.notifications_active_outlined),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget iconCircleButton(double iconSize, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       padding: EdgeInsets.all(iconSize * 0.5),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: const Color(0xFFBCD8DB)),
//         color: Colors.transparent,
//       ),
//       child: Icon(icon, size: iconSize, color: const Color(0xFF003840)),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(90); // Controlled height
// }
