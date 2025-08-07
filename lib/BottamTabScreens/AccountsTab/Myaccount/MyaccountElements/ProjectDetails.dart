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
              final proj = projects[i];
              return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFBCD8DB)),
                          ),
                          child: Text(
                            proj.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => onEdit(proj, i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => onDelete(i),
                        ),
                      ],
                    ),


                    const SizedBox(height: 6),

                    Text(
                      'Project Name : ${proj.projectName}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * fontScale,
                        color: const Color(0xFF005E6A),
                      ),
                    ),

                    Text(
                      'Company Name : ${proj.companyName}',
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        color: const Color(0xFF003840),
                      ),
                    ),

                    Text(
                      'Duration : ${proj.duration} - ${proj.durationPeriod}',
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        color: const Color(0xFF003840),
                      ),
                    ),

                    Text(
                      'Skills : ${proj.skills}',
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        color: const Color(0xFF003840),
                      ),
                    ),

                    Text(
                      'Details : ${proj.details}',
                      style: TextStyle(
                        fontSize: 14 * fontScale,
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
