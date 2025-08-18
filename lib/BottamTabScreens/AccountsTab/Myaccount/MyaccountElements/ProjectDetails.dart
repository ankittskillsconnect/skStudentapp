import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sk_loginscreen1/Model/Internship_Projects_Model.dart';
import 'SectionHeader.dart';
import 'ShimmerWidgets.dart';

class ProjectsSection extends StatelessWidget {
  final List<InternshipProjectModel> projects;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(InternshipProjectModel, int) onEdit;
  final Function(int) onDelete;

  const ProjectsSection({
    super.key,
    required this.projects,
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
          title: "Project/Internship Details",
          showAdd: true,
          onAdd: onAdd,
        ),
        if (isLoading)
          Padding(
            padding: EdgeInsets.all(14.w),
            child: const ProjectShimmer(),
          )
        else if (projects.isEmpty)
          Center(
            child: Text(
              'No projects available',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Column(
            children: List.generate(projects.length, (i) {
              final proj = projects[i];
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
                            Icons.work_history,
                            size: 22.w,
                            color: const Color(0xFF005E6A),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "[ ${proj.type} ]",
                            style: TextStyle(
                              color: const Color(0xFF004C5C),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Color(0xFF005E6A)),
                          iconSize: 16.w,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => onEdit(proj, i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          iconSize: 18.w,
                          onPressed: () async {
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: const Text('Confirm Delete'),
                                content: Text(
                                    'Are you sure you want to delete this ${proj.type}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true) {
                              onDelete(i); // Trigger your delete logic
                            }
                          },
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Project Name : ${proj.projectName}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: const Color(0xFF005E6A),
                      ),
                    ),
                    Text(
                      'Company Name : ${proj.companyName}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF003840),
                      ),
                    ),
                    Text(
                      'Duration : ${proj.duration} - ${proj.durationPeriod}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF003840),
                      ),
                    ),
                    Text(
                      'Skills : ${proj.skills}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF003840),
                      ),
                    ),
                    Text(
                      'Details : ${proj.details}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF003840),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}
