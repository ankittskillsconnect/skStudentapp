import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(17.w, 17.h, 17.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 13.sp),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5.h),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search,
                              size: 18.sp, color: Colors.black),
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  iconCircleButton(Icons.notifications_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconCircleButton(IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.withOpacity(0.4)),
        color: Colors.transparent,
      ),
      child: Icon(icon, size: 18.w, color: Colors.black),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64.h);
}