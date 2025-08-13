import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sk_loginscreen1/Model/WorkExperience_Model.dart';
import 'SectionHeader.dart';

class WorkExperienceSection extends StatelessWidget {
  final List<WorkExperienceModel> workExperiences;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(WorkExperienceModel, int) onEdit;
  final Function(int) onDelete;

  const WorkExperienceSection({
    super.key,
    required this.workExperiences,
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
         SectionHeader(
          title: "Work Experience",
          showAdd: true,
          onAdd: onAdd,
        ),
        for (int i = 0; i < workExperiences.length; i++)
          Container(
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
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF6F7),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.work_history_outlined,
                        size: 18.w,
                        color: const Color(0xFF005E6A),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        workExperiences[i].organization,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                      iconSize: 16.w,
                      onPressed: () => onEdit(workExperiences[i], i),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: 3.w),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      iconSize: 16.w,
                      onPressed: () => onDelete(i),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 7.h),
                Text(
                  'Project Name : ${workExperiences[i].jobTitle}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Duration : ${workExperiences[i].workFromDate} - ${workExperiences[i].workToDate}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Skills : ${workExperiences[i].skills}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Exp : ${workExperiences[i].totalExperienceYears} yrs ${workExperiences[i].totalExperienceMonths} months',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Salary : ${workExperiences[i].salaryInLakhs}.${workExperiences[i].salaryInThousands} LPA',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Details : ${workExperiences[i].jobDescription}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}