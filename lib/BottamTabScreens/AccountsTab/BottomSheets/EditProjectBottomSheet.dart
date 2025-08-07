import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Model/Internship_Projects_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utilities/MyAccount_Get_Post/InternshipProject_Api.dart';
import 'CustomDropDowns/CustomDropDownProjectIntern.dart';

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

  final GlobalKey _typeKey = GlobalKey();
  final GlobalKey _projectNameKey = GlobalKey();
  final GlobalKey _companyNameKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _durationKey = GlobalKey();
  final GlobalKey _durationPeriodKey = GlobalKey();
  final GlobalKey _detailsKey = GlobalKey();
  final FocusNode _typeFocusNode = FocusNode();
  final FocusNode _projectNameFocusNode = FocusNode();
  final FocusNode _companyNameFocusNode = FocusNode();
  final FocusNode _skillsFocusNode = FocusNode();
  final FocusNode _durationFocusNode = FocusNode();
  final FocusNode _durationPeriodFocusNode = FocusNode();
  final FocusNode _detailsFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    type = widget.initialData?.type ?? 'Project';
    durationPeriod = widget.initialData?.durationPeriod ?? 'Days';
    projectNameController = TextEditingController(text: widget.initialData?.projectName ?? '');
    companyNameController = TextEditingController(text: widget.initialData?.companyName ?? '');
    skillsController = TextEditingController(text: widget.initialData?.skills ?? '');
    durationController = TextEditingController(text: widget.initialData?.duration ?? '');
    detailsController = TextEditingController(text: widget.initialData?.details ?? '');

    _typeFocusNode.addListener(() => _handleFocusChange(_typeKey, _typeFocusNode));
    _projectNameFocusNode.addListener(() => _handleFocusChange(_projectNameKey, _projectNameFocusNode));
    _companyNameFocusNode.addListener(() => _handleFocusChange(_companyNameKey, _companyNameFocusNode));
    _skillsFocusNode.addListener(() => _handleFocusChange(_skillsKey, _skillsFocusNode));
    _durationFocusNode.addListener(() => _handleFocusChange(_durationKey, _durationFocusNode));
    _durationPeriodFocusNode.addListener(() => _handleFocusChange(_durationPeriodKey, _durationPeriodFocusNode));
    _detailsFocusNode.addListener(() => _handleFocusChange(_detailsKey, _detailsFocusNode));
  }

  void _handleFocusChange(GlobalKey key, FocusNode focusNode) {
    if (focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    projectNameController.dispose();
    companyNameController.dispose();
    skillsController.dispose();
    durationController.dispose();
    detailsController.dispose();
    _typeFocusNode.dispose();
    _projectNameFocusNode.dispose();
    _companyNameFocusNode.dispose();
    _skillsFocusNode.dispose();
    _durationFocusNode.dispose();
    _durationPeriodFocusNode.dispose();
    _detailsFocusNode.dispose();
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
        const SnackBar(content: Text('Error: Please log in again.')),
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
        widget.onSave(newData);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save project. Please try again.')),
        );
      }
    } catch (e) {
      print("❌ Error saving project: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
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
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
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
                  CustomFieldProjectDropdown(
                    ['Internship', 'Project'],
                    type,
                        (val) => setState(() => type = val ?? 'Project'),
                    key: _typeKey,
                    label: 'Please select',
                  ),
                  _buildLabel("Project Name"),
                  _buildTextField("Project Name", projectNameController, key: _projectNameKey, focusNode: _projectNameFocusNode),
                  _buildLabel("Company Name"),
                  _buildTextField("Company Name", companyNameController, key: _companyNameKey, focusNode: _companyNameFocusNode),
                  _buildLabel("Skills (comma-separated)"),
                  _buildTextField("Add Skills", skillsController, key: _skillsKey, focusNode: _skillsFocusNode),
                  _buildLabel("Duration (number only)"),
                  _buildTextField("Numbers only", durationController, keyboardType: TextInputType.number, key: _durationKey, focusNode: _durationFocusNode),
                  _buildLabel("Duration Period"),
                  CustomFieldProjectDropdown(
                    ['Days', 'Weeks', 'Month'],
                    durationPeriod,
                        (val) => setState(() => durationPeriod = val ?? 'Days'),
                    key: _durationPeriodKey,
                    label: 'Please select',
                  ),
                  _buildLabel("Project Details"),
                  _buildTextField("Add Details", detailsController, maxLines: 4, key: _detailsKey, focusNode: _detailsFocusNode),
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
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1, Key? key, FocusNode? focusNode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        key: key,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}