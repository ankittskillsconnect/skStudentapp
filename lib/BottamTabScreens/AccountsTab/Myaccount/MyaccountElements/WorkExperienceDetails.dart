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
                    Icons.work_history_outlined,
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
                        workExperiences[i].jobTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        workExperiences[i].organization,
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF003840),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${workExperiences[i].workFromDate} - ${workExperiences[i].workToDate}',
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF003840),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Skills: ${workExperiences[i].skills}',
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Exp: ${workExperiences[i].totalExperienceYears} yrs ${workExperiences[i].totalExperienceMonths} months \n'
                            'Salary: ${workExperiences[i].salaryInLakhs}.${workExperiences[i].salaryInThousands} LPA',
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        workExperiences[i].jobDescription,
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                  onPressed: () => onEdit(workExperiences[i], i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => onDelete(i),
                ),
              ],
            ),
          ),
      ],
    );
  }
}