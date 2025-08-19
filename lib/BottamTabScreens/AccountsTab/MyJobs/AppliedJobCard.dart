import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppliedJobCardBT extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String location;
  final String salary;
  final String postTime;
  final String expiry;
  final List<String> tags;
  final String? logoUrl;

  const AppliedJobCardBT({
    super.key,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.salary,
    required this.postTime,
    required this.expiry,
    required this.tags,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);
    print('🔍 [AppliedJobCardBT] Rendering card for job: $jobTitle, company: $company');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.3.w, vertical: 8.8.h),
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6F7),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: const Color(0xFFBCD8DB), width: 1.8.w),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.6.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.6.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.6.w),
                      margin: EdgeInsets.only(bottom: 0.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.r),
                        border: Border.all(color: const Color(0xFF005E6A), width: 0.9.w),
                      ),
                      child: logoUrl != null && logoUrl!.isNotEmpty
                          ? Image.network(
                        logoUrl!,
                        width: 35.2.w,
                        height: 35.2.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print('⚠️ [AppliedJobCardBT] Failed to load logo for $jobTitle: $error');
                          return Image.asset(
                            "assets/google.png",
                            width: 35.2.w,
                            height: 35.2.h,
                          );
                        },
                      )
                          : Image.asset(
                        "assets/google.png",
                        width: 35.2.w,
                        height: 35.2.h,
                      ),
                    ),
                    SizedBox(width: 10.6.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.7.sp,
                              color: const Color(0xFF003840),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.8.h),
                          Text(
                            company,
                            style: TextStyle(fontSize: 13.2.sp, color: const Color(0xFF827B7B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.8.h),
                          Text(
                            location.isNotEmpty ? location : 'NA',
                            style: TextStyle(fontSize: 13.2.sp, color: const Color(0xFF827B7B)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 7.w),
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 44.w, maxWidth: 88.w),
                      child: Text(
                        '$salary LPA',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 15.8.sp,
                          color: const Color(0xFF005E6A),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.6.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tags.map((tag) {
                      print('🔍 [AppliedJobCardBT] Processing tags: $tags');
                      if (tags.isEmpty || tags.every((tag) => tag.trim().isEmpty)) {
                        print('⚠️ [AppliedJobCardBT] No valid tags for $jobTitle');
                        return Text(
                          "No Skills listed",
                          style: TextStyle(
                            color: const Color(0xFF003840),
                            fontSize: 12.3.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return Wrap(
                        spacing: 7.w,
                        runSpacing: 7.h,
                        children: tags.where((tag) => tag.trim().isNotEmpty).map((tag) {
                          return Container(
                            margin: EdgeInsets.only(right: 8.8.w),
                            padding: EdgeInsets.symmetric(horizontal: 8.8.w, vertical: 5.3.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17.6.r),
                              border: Border.all(color: const Color(0xFF827B7B)),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: const Color(0xFF003840),
                                fontSize: 12.3.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 19.4.w,
                      color: const Color(0xFF003840),
                    ),
                    SizedBox(width: 3.5.w),
                    Text(
                      postTime,
                      style: TextStyle(
                        fontSize: 14.1.sp,
                        color: const Color(0xFF003840),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.5.h),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFFEDDDC),
                //     borderRadius: BorderRadius.circular(17.6.r),
                //     border: Border.all(color: const Color(0xFFBCD8DB)),
                //   ),
                //   child: Text(
                //     expiry,
                //     style: TextStyle(
                //       color: const Color(0xFFD03C2D),
                //       fontSize: 12.3.sp,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}