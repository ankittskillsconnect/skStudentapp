import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    print('🔍 [EditProjectDetailsBottomSheet] Initializing');
    type = widget.initialData?.type ?? 'Project';
    durationPeriod = widget.initialData?.durationPeriod ?? 'Days';
    projectNameController = TextEditingController(text: widget.initialData?.projectName ?? '');
    companyNameController = TextEditingController(text: widget.initialData?.companyName ?? '');
    skillsController = TextEditingController(text: widget.initialData?.skills ?? '');
    durationController = TextEditingController(text: widget.initialData?.duration ?? '');
    detailsController = TextEditingController(text: widget.initialData?.details ?? '');

    _typeFocusNode.addListener(() => _handleFocusChange(_typeKey, _typeFocusNode, 'Type'));
    _projectNameFocusNode.addListener(() => _handleFocusChange(_projectNameKey, _projectNameFocusNode, 'Project Name'));
    _companyNameFocusNode.addListener(() => _handleFocusChange(_companyNameKey, _companyNameFocusNode, 'Company Name'));
    _skillsFocusNode.addListener(() => _handleFocusChange(_skillsKey, _skillsFocusNode, 'Skills'));
    _durationFocusNode.addListener(() => _handleFocusChange(_durationKey, _durationFocusNode, 'Duration'));
    _durationPeriodFocusNode.addListener(() => _handleFocusChange(_durationPeriodKey, _durationPeriodFocusNode, 'Duration Period'));
    _detailsFocusNode.addListener(() => _handleFocusChange(_detailsKey, _detailsFocusNode, 'Details'));

    print('🔍 [EditProjectDetailsBottomSheet] Loaded initial data: ${widget.initialData?.projectName ?? 'N/A'}');
  }

  void _handleFocusChange(GlobalKey key, FocusNode focusNode, String field) {
    if (focusNode.hasFocus) {
      print('🔍 [EditProjectDetailsBottomSheet] Focus changed to: $field');
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
    print('🔍 [EditProjectDetailsBottomSheet] Disposing controllers and focus nodes');
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
      print("❌ [EditProjectDetailsBottomSheet] Error decoding authToken: $e");
      return null;
    }
  }

  void _handleSave() async {
    if (saving || !_formKey.currentState!.validate()) {
      print("⚠️ [EditProjectDetailsBottomSheet] Form is not valid or already saving");
      return;
    }

    print('🔍 [EditProjectDetailsBottomSheet] Initiating save');
    setState(() => saving = true);

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final userId = getUserIdFromToken(authToken) ?? prefs.getString('user_id') ?? '';

    if (authToken.isEmpty || connectSid.isEmpty) {
      print('⚠️ [EditProjectDetailsBottomSheet] Missing authToken or connectSid');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Please log in again.', style: TextStyle(fontSize: 12.4.sp))),
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

    // print('📤 [EditProjectDetailsBottomSheet] Submitting Internship/Project:');
    // print('📦 internshipId: ${newData.internshipId}');
    // print('📦 userId: ${newData.userId}');
    // print('📦 type: ${newData.type}');
    // print('📦 projectName: ${newData.projectName}');
    // print('📦 companyName: ${newData.companyName}');
    // print('📦 skills: ${newData.skills}');
    // print('📦 duration: ${newData.duration}');
    // print('📦 durationPeriod: ${newData.durationPeriod}');
    // print('📦 details: ${newData.details}');

    try {
      final success = await InternshipProjectApi.saveInternshipProject(
        model: newData,
        authToken: authToken,
        connectSid: connectSid,
      );
      if (success) {
        print('✅ [EditProjectDetailsBottomSheet] Save successful');
        widget.onSave(newData);
        Navigator.pop(context);
      } else {
        print('⚠️ [EditProjectDetailsBottomSheet] Save failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save project. Please try again.', style: TextStyle(fontSize: 12.4.sp))),
        );
      }
    } catch (e) {
      print("❌ [EditProjectDetailsBottomSheet] Error saving project: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e', style: TextStyle(fontSize: 12.4.sp))),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);
    print('🔍 [EditProjectDetailsBottomSheet] Rendering');

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
              left: 14.4.w,
              right: 14.4.w,
              top: 9.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 9.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.1.r)),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Project Details',
                        style: TextStyle(
                          fontSize: 16.2.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF003840),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: const Color(0xFF005E6A), size: 17.7.w),
                        onPressed: () {
                          print('🔍 [EditProjectDetailsBottomSheet] Closing bottom sheet');
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  _buildLabel("Project Type"),
                  CustomFieldProjectDropdown(
                    ['Internship', 'Project'],
                    type,
                        (val) {
                      setState(() => type = val ?? 'Project');
                      print('🔍 [EditProjectDetailsBottomSheet] Project type changed to: $val');
                    },
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
                        (val) {
                      setState(() => durationPeriod = val ?? 'Days');
                      print('🔍 [EditProjectDetailsBottomSheet] Duration period changed to: $val');
                    },
                    key: _durationPeriodKey,
                    label: 'Please select',
                  ),
                  _buildLabel("Project Details"),
                  _buildTextField("Add Details", detailsController, maxLines: 4, key: _detailsKey, focusNode: _detailsFocusNode),
                  SizedBox(height: 27.1.h),
                  ElevatedButton(
                    onPressed: saving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005E6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.1.r),
                      ),
                      minimumSize: Size.fromHeight(45.1.h),
                    ),
                    child: saving
                        ? SizedBox(
                      height: 18.1.h,
                      width: 18.1.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.8.w,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 13.7.sp),
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
    padding: EdgeInsets.only(top: 10.8.h, bottom: 5.4.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.4.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xff003840),
      ),
    ),
  );

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1, Key? key, FocusNode? focusNode}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.4.h),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        key: key,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12.4.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.8.r)),
        ),
        style: TextStyle(fontSize: 12.4.sp),
        validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}