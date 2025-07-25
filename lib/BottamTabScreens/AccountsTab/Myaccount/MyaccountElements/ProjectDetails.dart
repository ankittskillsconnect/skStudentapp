import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

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
            padding: const EdgeInsets.all(16),
            child: ProjectShimmer(sizeScale: sizeScale, fontScale: fontScale),
          )
        else if (projects.isEmpty)
          const Center(
            child: Text(
              'No projects available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Column(
            children: List.generate(projects.length, (i) {
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
                        Icons.workspaces_filled,
                        size: 24,
                        color: Color(0xFF005E6A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFBCD8DB)),
                            ),
                            child: Text(
                              projects[i].type,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            projects[i].projectName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14 * fontScale,
                              color: const Color(0xFF005E6A),
                            ),
                          ),
                          Text(
                            projects[i].companyName,
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          Text(
                            '${projects[i].duration} - ${projects[i].durationPeriod}',
                            style: TextStyle(
                              fontSize: 14 * fontScale,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          Text(
                            projects[i].skills,
                            style: TextStyle(
                              fontSize: 13 * fontScale,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            projects[i].details,
                            style: TextStyle(
                              fontSize: 13 * fontScale,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                      onPressed: () => onEdit(projects[i], i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => onDelete(i),
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