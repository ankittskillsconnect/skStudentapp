import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Model/Internship_Projects_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/MyAccount_Get_Post/Get/InternshipProject_Api.dart';

class EditProjectDetailsBottomSheet extends StatefulWidget {
  final InternshipProjectModel? initialData;
  final Function(InternshipProjectModel) onSave;

  const EditProjectDetailsBottomSheet({
    Key? key,
    this.initialData,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditProjectDetailsBottomSheet> createState() => _EditProjectDetailsBottomSheetState();
}

class _EditProjectDetailsBottomSheetState extends State<EditProjectDetailsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String type;
  late TextEditingController projectNameController;
  late TextEditingController companyNameController;
  late TextEditingController skillsController;
  late TextEditingController durationController;
  late String durationPeriod;
  late TextEditingController detailsController;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    type = widget.initialData?.type ?? 'Project';
    durationPeriod = widget.initialData?.durationPeriod ?? 'Days';
    projectNameController = TextEditingController(text: widget.initialData?.projectName ?? '');
    companyNameController = TextEditingController(text: widget.initialData?.companyName ?? '');
    skillsController = TextEditingController(text: widget.initialData?.skills ?? '');
    durationController = TextEditingController(
      text: widget.initialData?.duration ?? '',
    );
    detailsController = TextEditingController(text: widget.initialData?.details ?? '');
  }

  @override
  void dispose() {
    projectNameController.dispose();
    companyNameController.dispose();
    skillsController.dispose();
    durationController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  String? getUserIdFromToken(String authToken) {
    try {
      final parts = authToken.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final decoded = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
      final payloadMap = jsonDecode(decoded) as Map<String, dynamic>;
      return payloadMap['id']?.toString();
    } catch (e) {
      print("❌ Error decoding authToken: $e");
      return null;
    }
  }

  void _handleSave() async {
    if (saving || !_formKey.currentState!.validate()) {
      print("⚠️ Form is not valid or already saving. Aborting save.");
      return;
    }

    setState(() => saving = true);

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final userId = getUserIdFromToken(authToken) ?? prefs.getString('user_id') ?? '';

    if (authToken.isEmpty || connectSid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Please log in again.')),
      );
      setState(() => saving = false);
      return;
    }

    final newData = InternshipProjectModel(
      internshipId: widget.initialData?.internshipId,
      userId: userId.isNotEmpty ? userId : null,
      type: type,
      projectName: projectNameController.text.trim(),
      companyName: companyNameController.text.trim(),
      skills: skillsController.text.trim(),
      duration: durationController.text.trim(),
      durationPeriod: durationPeriod,
      details: detailsController.text.trim(),
    );

    print('📤 Submitting Internship/Project:');
    print('📦 internshipId: ${newData.internshipId}');

    print('📤 Submitting Internship/Project:');
    print('📦 internshipId: ${newData.internshipId}');
    print('📦 userId: ${newData.userId}');
    print('📦 type: ${newData.type}');
    print('📦 projectName: ${newData.projectName}');
    print('📦 companyName: ${newData.companyName}');
    print('📦 skills: ${newData.skills}');
    print('📦 duration: ${newData.duration}');
    print('📦 durationPeriod: ${newData.durationPeriod}');
    print('📦 details: ${newData.details}');

    try {
      final success = await InternshipProjectApi.saveInternshipProject(
        model: newData,
        authToken: authToken,
        connectSid: connectSid,
      );
      if (success) {
        widget.onSave(newData); // Notify parent once
        Navigator.pop(context); // Close bottom sheet
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save project. Please try again.')),
        );
      }
    } catch (e) {
      print("❌ Error saving project: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.9,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Project Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003840),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF005E6A)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  _buildLabel("Project Type"),
                  _dropdownField(value: type, items: ['Internship', 'Project'], onChanged: (val) => setState(() => type = val!)),
                  _buildLabel("Project Name"),
                  _buildTextField("Project Name", projectNameController),
                  _buildLabel("Company Name"),
                  _buildTextField("Company Name", companyNameController),
                  _buildLabel("Skills (comma-separated)"),
                  _buildTextField("Add Skills", skillsController),
                  _buildLabel("Duration (number only)"),
                  _buildTextField("Numbers only", durationController, keyboardType: TextInputType.number),
                  _buildLabel("Duration Period"),
                  _dropdownField(value: durationPeriod, items: ['Days', 'Weeks', 'Month'], onChanged: (val) => setState(() => durationPeriod = val!)),
                  _buildLabel("Project Details"),
                  _buildTextField("Add Details", detailsController, maxLines: 4),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: saving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005E6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: saving
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value.isNotEmpty && items.contains(value) ? value : items.first,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Please select',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xff003840),
      ),
    ),
  );

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) =>
        (value == null || value.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}