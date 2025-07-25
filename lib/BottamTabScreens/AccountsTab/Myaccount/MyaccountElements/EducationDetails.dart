import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Education Details",
          showAdd: true,
          onAdd: onAdd,
        ),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.all(16),
            child: EducationShimmer(sizeScale: sizeScale, fontScale: fontScale),
          )
        else if (educationDetails.isNotEmpty)
          ...educationDetails.asMap().entries.map((entry) {
            final index = entry.key;
            final edu = entry.value;
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(14 * sizeScale),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFBCD8DB)),
                borderRadius: BorderRadius.circular(12 * sizeScale),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(6 * sizeScale),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF6F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      size: 24,
                      color: Color(0xFF005E6A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          edu.degreeName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14 * fontScale,
                            color: const Color(0xFF005E6A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${edu.courseName} \n${edu.specializationName} \nCGPA - ${edu.marks}',
                          style: TextStyle(
                            fontSize: 14 * fontScale,
                            color: const Color(0xFF003840),
                          ),
                        ),
                        Text(
                          '${edu.collegeMasterName}\n${edu.passingYear}',
                          style: TextStyle(
                            fontSize: 14 * fontScale,
                            color: const Color(0xFF003840),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                    onPressed: () => onEdit(edu, index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => onDelete(index),
                  ),
                ],
              ),
            );
          })
        else
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "No education details found.",
              style: TextStyle(
                fontSize: 14 * fontScale,
                color: const Color(0xFF003840),
              ),
            ),
          ),
      ],
    );
  }
}