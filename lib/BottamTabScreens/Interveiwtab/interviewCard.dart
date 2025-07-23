import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sk_loginscreen1/Pages/BlinkAnimatedStatus.dart';
import '../../Model/InterviewScreen_Model.dart';

class InterviewCard extends StatelessWidget {
  final InterviewModel model;
  final VoidCallback onJoinTap;

  const InterviewCard({
    super.key,
    required this.model,
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
        border: Border.all(color: const Color(0xFFBCD8DB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.jobTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF003840),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
                        const Icon(Icons.maps_home_work_outlined, size: 18, color: Color(0xFF003840)),
                        const SizedBox(width: 8),
                        Text(
                          model.company,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF003840),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    LiveSlidingText(status: model.isActive ? 'Active' : 'Inactive'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 18, color: Color(0xFF003840)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        model.date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF003840),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time_outlined, size: 18, color: Color(0xFF003840)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${model.startTime} - ${model.endTime}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF003840),
                          fontWeight: FontWeight.w500,
                        ),
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
                        const Icon(Icons.person_outline_outlined, size: 18, color: Color(0xFF003840)),
                        const SizedBox(width: 8),
                        Text(
                          model.moderator,
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
                          model.meetingMode,
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
