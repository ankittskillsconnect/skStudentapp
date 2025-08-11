import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6F7),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFBCD8DB), width: 0.8.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.jobTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: const Color(0xFF003840),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.maps_home_work_outlined,
                              size: 16.w, color: const Color(0xFF003840)),
                          SizedBox(width: 7.w),
                          Expanded(
                            child: Text(
                              model.company,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF003840),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LiveSlidingText(status: model.isActive ? 'Active' : 'Inactive'),
                  ],
                ),
                SizedBox(height: 7.h),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        size: 16.w, color: const Color(0xFF003840)),
                    SizedBox(width: 7.w),
                    Flexible(
                      child: Text(
                        model.date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF003840),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.access_time_outlined,
                        size: 16.w, color: const Color(0xFF003840)),
                    SizedBox(width: 7.w),
                    Expanded(
                      child: Text(
                        "${model.startTime} - ${model.endTime}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF003840),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline_outlined,
                            size: 16.w, color: const Color(0xFF003840)),
                        SizedBox(width: 7.w),
                        Text(
                          model.moderator,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF003840),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          model.meetingMode,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF003840),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Brand(Brands.zoom, size: 20.w),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Center(
            child: SizedBox(
              width: 200.w,
              child: ElevatedButton.icon(
                onPressed: onJoinTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005E6A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                ),
                icon: Text(
                  "Join Now",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                ),
                label: Icon(Icons.arrow_forward, color: Colors.white, size: 18.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}