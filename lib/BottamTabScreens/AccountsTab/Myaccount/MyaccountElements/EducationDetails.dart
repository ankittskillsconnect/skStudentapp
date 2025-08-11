import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sk_loginscreen1/Model/EducationDetail_Model.dart';
import 'SectionHeader.dart';
import 'ShimmerWidgets.dart';

class EducationSection extends StatelessWidget {
  final List<EducationDetailModel> educationDetails;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(EducationDetailModel, int) onEdit;
  final Function(int) onDelete;

  const EducationSection({
    super.key,
    required this.educationDetails,
    required this.isLoading,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: "Education Details",
          showAdd: true,
        ),
        if (isLoading)
          Padding(
            padding: EdgeInsets.all(14.w),
            child: const EducationShimmer(),
          )
        else if (educationDetails.isNotEmpty)
          ...educationDetails.asMap().entries.map((entry) {
            final index = entry.key;
            final edu = entry.value;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBCD8DB)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF6F7),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.school_outlined,
                          size: 22.w,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          edu.degreeName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: const Color(0xFF005E6A),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                        iconSize: 16.w,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => onEdit(edu, index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        iconSize: 16.w,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => onDelete(index),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Degree : ${edu.courseName}\nSpecialization : ${edu.specializationName}\nMarks : ${edu.marks}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF003840),
                    ),
                  ),
                  Text(
                    'College : ${edu.collegeMasterName}\n${edu.passingYear}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF003840),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          })
        else
          Padding(
            padding: EdgeInsets.only(top: 7.h),
            child: Text(
              "No education details found.",
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF003840),
              ),
            ),
          ),
      ],
    );
  }
}