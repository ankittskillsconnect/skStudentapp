import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Model/Skiils_Model.dart';
import 'SectionHeader.dart';
import 'ShimmerWidgets.dart';


class SkillsSection extends StatelessWidget {
  final List<SkillsModel> skillList;
  final bool isLoading;
  final VoidCallback onEdit;
  final VoidCallback onAdd;
  final Function(SkillsModel, String) onDeleteSkill;

  const SkillsSection({
    super.key,
    required this.skillList,
    required this.isLoading,
    required this.onEdit,
    required this.onAdd,
    required this.onDeleteSkill,
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
          title: "Skills",
          showEdit: skillList.isNotEmpty,
          onEdit: onEdit,
          showAdd: skillList.isEmpty,
          onAdd: onAdd,
        ),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SkillsShimmer(sizeScale: sizeScale, fontScale: fontScale),
          )
        else if (skillList.isNotEmpty)
          Container(
            padding: EdgeInsets.all(12 * sizeScale),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBCD8DB)),
              borderRadius: BorderRadius.circular(12 * sizeScale),
            ),
            child: Wrap(
              spacing: 8 * sizeScale,
              runSpacing: 8 * sizeScale,
              children: skillList
                  .expand((skill) => skill.skills
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .map((singleSkill) => Chip(
                label: Text(
                  singleSkill,
                  style: TextStyle(fontSize: 14 * fontScale),
                ),
                onDeleted: () => onDeleteSkill(skill, singleSkill),
                deleteIconColor: const Color(0xFF005E6A),
                backgroundColor: const Color(0xFFEBF6F7),
                labelStyle: const TextStyle(color: Color(0xFF003840)),
              )))
                  .toList(),
            ),


          ),
      ],
    );
  }
}
