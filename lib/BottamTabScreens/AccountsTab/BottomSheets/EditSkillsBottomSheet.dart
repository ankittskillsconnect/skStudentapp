import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
    skills = List.from(widget.initialSkills);
  }

  void _addSkill() {
    final text = _controller.text.trim();
    if (text.isNotEmpty &&
        !skills.any((skill) => skill.skills.toLowerCase() == text.toLowerCase())) {
      setState(() {
        skills.add(SkillsModel(skills: text));
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Skills',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF005E6A)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: skills.map((skill) {
                            return Chip(
                              label: Text(skill.skills),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () => setState(() => skills.remove(skill)),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                decoration: const InputDecoration(
                                  labelText: 'Add a skill',
                                  border: OutlineInputBorder(),
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _addSkill(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _addSkill,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005E6A),
                                padding: const EdgeInsets.all(14),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                ElevatedButton(

                  onPressed: () {
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
                        Navigator.of(context).pop();
                      },
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005E6A),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Save", style: TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 20),
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

  try {
    final url = Uri.parse("https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-skills");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
      'Cookie': connectSid,
    };
    final body = jsonEncode({"skills": cleanedSkills.join(', ')});


    print("📤 Sending skills update...");
    print("👉 URL: $url");
    print("👉 Headers: $headers");
    print("👉 Body: $body");

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print("📩 Response Status: ${response.statusCode}");
    print("📩 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      print("✅ Skills updated successfully!");
      onSuccess();
    } else {
      print("❌ Failed to update skills. Server responded with status ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update skills")),
      );
    }
  } catch (e) {
    print("❌ Error updating skills: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong")),
    );
  }
}
