import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sk_loginscreen1/Pages/BlinkAnimatedStatus.dart';

class DiscussionCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String status;
  final String time;
  final String date;
  final String hrName;
  final String platform;

  // final int invitedCount;
  // final List<String> profileImageUrls;
  final VoidCallback onJoinTap;

  const DiscussionCard({
    super.key,
    required this.title,
    required this.companyName,
    required this.status,
    required this.time,
    required this.date,
    required this.hrName,
    required this.platform,
    // required this.invitedCount,
    // required this.profileImageUrls,
    required this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6F7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFBCD8DB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF003840),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // const Icon(Icons.circle, size: 8, color: Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.maps_home_work_outlined,
                          size: 18,
                          color: Color(0xFF003840),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          companyName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF003840),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 8,
                    //     vertical: 4,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFEA4D4D),
                    //     borderRadius: BorderRadius.circular(18),
                    //     border: Border.all(color: Color(0xFFBCD8DB)),
                    //   ),
                    //   child: Text(
                    //     status,
                    //     style: const TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    //
                    LiveSlidingText(status: status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: Color(0xFF003840),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$date | $time",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF003840),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline_outlined,
                          size: 18,
                          color: Color(0xFF003840),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hrName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF003840),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          platform,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF003840),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Brand(Brands.zoom, size: 23),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(height: 8),
                //
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //       decoration: BoxDecoration(
                //         color: const Color(0xFFEFF6F6),
                //         borderRadius: BorderRadius.circular(20),
                //         border: Border.all(color: const Color(0xFFBCD8DB)),
                //       ),
                //       child: Row(
                //         children: const [
                //           Icon(Icons.groups, size: 18, color: Color(0xFF003840)),
                //           SizedBox(width: 6),
                //           Text(
                //             '15 Invited',
                //             style: TextStyle(
                //               fontWeight: FontWeight.w500,
                //               color: Color(0xFF003840),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //
                //     // Overlapping Profile Images
                //     // buildOverlappingAvatars(
                //     //  profileImageUrls
                //     // ),
                //   ],
                // )
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onJoinTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005E6A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Text(
                "Join Now",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              label: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget buildOverlappingAvatars(List<String> imageUrls) {
//   double overlap = 20;
//
//   List<Widget> avatars = [];
//   for (int i = 0; i < imageUrls.length; i++) {
//     avatars.add(Positioned(
//       left: i * overlap,
//       child: CircleAvatar(
//         radius: 16,
//         backgroundColor: Colors.white,
//         child: CircleAvatar(
//           radius: 14,
//           backgroundImage: AssetImage(imageUrls[i]),
//         ),
//       ),
//     ));
//   }
//
//   avatars.add(Positioned(
//     left: imageUrls.length * overlap,
//     child: CircleAvatar(
//       radius: 16,
//       backgroundColor: Colors.white,
//       child: CircleAvatar(
//         radius: 14,
//         backgroundColor: Color(0xFF003840),
//         child: Icon(Icons.add, size: 16, color: Colors.white),
//       ),
//     ),
//   ));
//
//   return SizedBox(
//     height: 32,
//     width: (imageUrls.length + 1) * overlap + 12, // adjust for spacing
//     child: Stack(
//       children: avatars,
//     ),
//   );
// }
// Text(
//   _calculateAge(state.dob),
//   style: TextStyle(
//     fontSize: media.width * 0.04,
//     color: const Color(0xFF6A8E92),
//   ),
// ),