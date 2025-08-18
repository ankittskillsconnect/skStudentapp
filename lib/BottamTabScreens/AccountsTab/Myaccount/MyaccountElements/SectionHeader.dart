import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onEdit;
  final VoidCallback? onAdd;
  final bool showEdit;
  final bool showAdd;

  const SectionHeader({
    super.key,
    required this.title,
    this.onEdit,
    this.onAdd,
    this.showEdit = false,
    this.showAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF003840),
          ),
        ),
        Row(
          children: [
            if (showEdit && onEdit != null)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: const Color(0xFF005E6A),
                  size: 18.w,
                ),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
              ),
            if (showAdd && onAdd != null)
              SizedBox(
                width: 80.w,
                child: TextButton.icon(
                  onPressed: onAdd,
                  icon: Icon(Icons.add, size: 18.w, color: const Color(0xFF005E6A)),
                  label: Text(
                    "Add",
                    style: TextStyle(
                      color: const Color(0xFF005E6A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    side: BorderSide(color: const Color(0xFF005E6A), width: 1.1.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    minimumSize: Size(10.w, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}


class ProfileHeaderShimmer extends StatelessWidget {
  final double profileSize;

  const ProfileHeaderShimmer({super.key, required this.profileSize});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: profileSize,
            height: profileSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: 160,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          const SizedBox(height: 2),

          Container(
            width: 100,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}