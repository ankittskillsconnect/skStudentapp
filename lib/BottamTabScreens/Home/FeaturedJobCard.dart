import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedJobCard extends StatelessWidget {
  final String title;
  final String location;
  final String salary;
  final String applications;
  final String timeLeft;
  final String registered;
  final String jobType;
  final String imageAsset;
  final VoidCallback? onTap;

  const FeaturedJobCard({
    super.key,
    required this.title,
    required this.location,
    required this.salary,
    required this.applications,
    required this.timeLeft,
    required this.registered,
    required this.jobType,
    required this.imageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = 210.w; // ~0.55 * 390.w, reduced by ~10%
    final imageHeight = 110.h; // ~0.14 * 844.h, reduced by ~12%
    final iconSize = 18.w; // ~0.05 * 390.w, reduced by ~10%

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 280.h, // ~0.36 * 844.h, reduced by ~12%
        maxHeight: 330.h, // ~0.42 * 844.h, reduced by ~12%
      ),
      child: Card(
        margin: EdgeInsets.only(right: 13.w, bottom: 4.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.r)),
        elevation: 3.4,
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7.r),
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8.5.r,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(7.r)),
                  child: Image.asset(
                    imageAsset,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 9.h),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            "$salary • $applications Applications",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Row(
                            children: [
                              Icon(
                                Icons.group,
                                size: iconSize,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 3.w),
                              Flexible(
                                child: Text(
                                  registered,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF003840),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: iconSize,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 3.w),
                              Flexible(
                                child: Text(
                                  timeLeft,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF003840),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            jobType,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}