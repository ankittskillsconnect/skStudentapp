import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../Model/Skiils_Model.dart';

class EditSkillsBottomSheet extends StatefulWidget {
  final List<SkillsModel> initialSkills;
  final Function(List<SkillsModel>) onSave;

  const EditSkillsBottomSheet({
    super.key,
    required this.initialSkills,
    required this.onSave,
  });

  @override
  State<EditSkillsBottomSheet> createState() => _EditSkillsBottomSheetState();
}

class _EditSkillsBottomSheetState extends State<EditSkillsBottomSheet> {
  late List<SkillsModel> skills;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print('🔍 [EditSkillsBottomSheet] Initializing');
    skills = List.from(widget.initialSkills);
    print('🔍 [EditSkillsBottomSheet] Loaded initial skills: ${skills.map((s) => s.skills).toList()}');
  }

  void _addSkill() {
    final text = _controller.text.trim();
    if (text.isNotEmpty &&
        !skills.any((skill) => skill.skills.toLowerCase() == text.toLowerCase())) {
      setState(() {
        skills.add(SkillsModel(skills: text));
        _controller.clear();
        print('🔍 [EditSkillsBottomSheet] Added skill: $text');
      });
    } else {
      print('⚠️ [EditSkillsBottomSheet] Skill not added: empty or duplicate ($text)');
    }
  }

  @override
  void dispose() {
    print('🔍 [EditSkillsBottomSheet] Disposing controller and focus node');
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);
    print('🔍 [EditSkillsBottomSheet] Rendering');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.85,
        maxChildSize: 0.85,
        builder: (_, scrollController) {
          return Container(
            padding: EdgeInsets.only(
              left: 18.1.w,
              right: 18.1.w,
              top: 18.1.h,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.1.r)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Skills',
                      style: TextStyle(fontSize: 16.2.sp, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: const Color(0xFF005E6A), size: 17.7.w),
                      onPressed: () {
                        print('🔍 [EditSkillsBottomSheet] Closing bottom sheet');
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 14.4.h),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 7.2.w,
                          runSpacing: 7.2.h,
                          children: skills.map((skill) {
                            return Chip(
                              label: Text(skill.skills, style: TextStyle(fontSize: 12.4.sp)),
                              deleteIcon: Icon(Icons.close, size: 16.2.w),
                              onDeleted: () {
                                setState(() => skills.remove(skill));
                                print('🔍 [EditSkillsBottomSheet] Removed skill: ${skill.skills}');
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 18.1.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  labelText: 'Add a skill',
                                  labelStyle: TextStyle(fontSize: 12.4.sp),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.8.r)),
                                ),
                                style: TextStyle(fontSize: 12.4.sp),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _addSkill(),
                              ),
                            ),
                            SizedBox(width: 9.w),
                            ElevatedButton(
                              onPressed: _addSkill,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005E6A),
                                padding: EdgeInsets.all(12.6.w),
                                minimumSize: Size(27.4.w, 27.4.h),
                              ),
                              child: Icon(Icons.add, color: Colors.white, size: 17.7.w),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 9.h),
                ElevatedButton(
                  onPressed: () {
                    print('🔍 [EditSkillsBottomSheet] Initiating save');
                    final updatedSkills = skills
                        .map((s) => s.skills.trim())
                        .where((s) => s.isNotEmpty)
                        .toSet()
                        .toList();
                    postUpdatedSkills(
                      context: context,
                      updatedSkills: updatedSkills,
                      onSuccess: () {
                        widget.onSave(
                          updatedSkills.map((s) => SkillsModel(skills: s)).toList(),
                        );
                        print('✅ [EditSkillsBottomSheet] Save successful');
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005E6A),
                    minimumSize: Size.fromHeight(45.1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27.1.r),
                    ),
                  ),
                  child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 13.7.sp)),
                ),
                SizedBox(height: 18.1.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<void> postUpdatedSkills({
  required BuildContext context,
  required List<String> updatedSkills,
  required VoidCallback onSuccess,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('authToken') ?? '';
  final connectSid = prefs.getString('connectSid') ?? '';

  final cleanedSkills = updatedSkills
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList();

  print('📤 [EditSkillsBottomSheet] Sending skills update: $cleanedSkills');

  try {
    final url = Uri.parse("https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-skills");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
      'Cookie': connectSid,
    };
    final body = jsonEncode({"skills": cleanedSkills.join(', ')});

    print("🔍 [EditSkillsBottomSheet] URL: $url");
    print("🔍 [EditSkillsBottomSheet] Headers: $headers");
    print("🔍 [EditSkillsBottomSheet] Body: $body");

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print("📩 [EditSkillsBottomSheet] Response Status: ${response.statusCode}");
    print("📩 [EditSkillsBottomSheet] Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("✅ [EditSkillsBottomSheet] Skills updated successfully");
      onSuccess();
    } else {
      print("⚠️ [EditSkillsBottomSheet] Failed to update skills. Status: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update skills", style: TextStyle(fontSize: 12.4.sp))),
      );
    }
  } catch (e) {
    print("❌ [EditSkillsBottomSheet] Error updating skills: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong", style: TextStyle(fontSize: 12.4.sp))),
    );
  }
}