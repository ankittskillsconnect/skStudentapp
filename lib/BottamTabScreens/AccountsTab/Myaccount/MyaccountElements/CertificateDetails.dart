import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sk_loginscreen1/Model/CertificateDetails_Model.dart';
import 'SectionHeader.dart';

class CertificatesSection extends StatelessWidget {
  final List<CertificateModel> certificatesList;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(CertificateModel, int) onEdit;
  final Function(int) onDelete;

  const CertificatesSection({
    super.key,
    required this.certificatesList,
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
          title: "Certificate Details",
          showAdd: true,
           onAdd: onAdd,
        ),
        for (var i = 0; i < certificatesList.length; i++)
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF6F7),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.file_copy_outlined,
                        size: 22.w,
                        color: const Color(0xFF005E6A),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        certificatesList[i].certificateName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                      iconSize: 16.w,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onEdit(certificatesList[i], i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      iconSize: 16.w,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onDelete(i),
                    ),
                  ],
                ),
                SizedBox(height: 7.h),
                Text(
                  'Organization : ${certificatesList[i].issuedOrgName}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Issue Date : ${certificatesList[i].issueDate}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Expiry Date : ${certificatesList[i].expiryDate}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Details : ${certificatesList[i].description}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}