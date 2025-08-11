import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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