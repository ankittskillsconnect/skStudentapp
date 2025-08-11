import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sk_loginscreen1/AllFilters/JobListFilters.dart';
import '../../blocpage/jobFilterBloc/jobFilter_event.dart';
import '../../blocpage/jobFilterBloc/jobFilter_logic.dart';
import '../../blocpage/jobFilterBloc/jobFilter_state.dart';

class Appbarjobscreen extends StatefulWidget implements PreferredSizeWidget {
  const Appbarjobscreen({super.key});

  @override
  State<Appbarjobscreen> createState() => _AppbarjobscreenState();

  @override
  Size get preferredSize => Size.fromHeight(65.h);
}

class _AppbarjobscreenState extends State<Appbarjobscreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<JobFilterBloc, JobFilterState>(
      listener: (context, state) async {
        if (state is JobFilterSheetVisible) {
          final selectedFilters =
          await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const Joblistfilters(
              jobType: '',
              jobTitle: '',
              workCulture: '',
              courses: '',
              cities: '',
              states: '',
            ),
          );
          if (selectedFilters != null) {
            context.read<JobFilterBloc>().add(ShowJobFilterSheet());
          }
        }
      },
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
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
                SizedBox(width: 4.w),
                iconCircleButton(
                  Icons.filter_list,
                  onTap: () {
                    context.read<JobFilterBloc>().add(ShowJobFilterSheet());
                  },
                ),
                iconCircleButton(Icons.notifications_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget iconCircleButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          color: Colors.transparent,
        ),
        child: Icon(icon, size: 18.sp, color: Colors.black),
      ),
    );
  }
}
