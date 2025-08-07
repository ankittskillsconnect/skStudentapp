import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

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
            padding: EdgeInsets.all(14 * sizeScale),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBCD8DB)),
              borderRadius: BorderRadius.circular(12 * sizeScale),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6 * sizeScale),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF6F7),
                        borderRadius: BorderRadius.circular(12 * sizeScale),
                      ),
                      child: Icon(
                        Icons.work_history_outlined,
                        size: 20 * sizeScale,
                        color: const Color(0xFF005E6A),
                      ),
                    ),
                    SizedBox(width: 10 * sizeScale),
                    Expanded(
                      child: Text(
                        workExperiences[i].organization,
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                      iconSize: 18 * sizeScale,
                      onPressed: () => onEdit(workExperiences[i], i),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: 4 * sizeScale),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      iconSize: 18 * sizeScale,
                      onPressed: () => onDelete(i),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                SizedBox(height: 8 * sizeScale),
                Text(
                  'Project Name : ${workExperiences[i].jobTitle}',
                 style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),

                SizedBox(height: 4 * sizeScale),
                Text(
                  'Duration : ${workExperiences[i].workFromDate} - ${workExperiences[i].workToDate}',
                 style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),

                SizedBox(height: 4 * sizeScale),
                Text(
                  'Skills : ${workExperiences[i].skills}',
                 style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),

                SizedBox(height: 4 * sizeScale),
                Text(
                  'Exp : ${workExperiences[i].totalExperienceYears} yrs ${workExperiences[i].totalExperienceMonths} months',
                 style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),

                SizedBox(height: 4 * sizeScale),

                Text(
                  'Salary : ${workExperiences[i].salaryInLakhs}.${workExperiences[i].salaryInThousands} LPA',
                 style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),

                SizedBox(height: 4 * sizeScale),

                Text(
                  'Details : ${workExperiences[i].jobDescription}',
                   style: TextStyle(
                    fontSize: 13 * fontScale,
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
