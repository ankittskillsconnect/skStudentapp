import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Model/EducationDetail_Model.dart';
import '../../../Utilities/CollegeList_Api.dart';
import '../../../Utilities/Specialization_Api.dart';
import 'package:sk_loginscreen1/Utilities/AllCourse_Api.dart';
import 'CustomDropDowns/CustomDropdownEducation.dart';

class EditEducationBottomSheet extends StatefulWidget {
  final EducationDetailModel? initialData;
  final Function(Map<String, dynamic> data) onSave;

  const EditEducationBottomSheet({
    super.key,
    required this.onSave,
    this.initialData,
  });

  @override
  State<EditEducationBottomSheet> createState() => _EditEducationBottomSheetState();
}

class _EditEducationBottomSheetState extends State<EditEducationBottomSheet> {
  late TextEditingController _marksController;
  late String degreeName;
  late String collegeName;
  late String courseName;
  late String specializationName;
  late String passingYear;
  late String passingMonth;
  late String courseType;
  late String gradingSystem;
  late String gradeName;
  late String grade;
  bool isLoading = true;
  final GlobalKey _marksFieldKey = GlobalKey();
  final FocusNode _marksFocusNode = FocusNode();

  List<String> collegeList = [];
  List<String> courseList = [];
  List<String> specializationList = [];
  List<String> courseTypeList = ['Full-Time', 'Part-Time', 'Corresponding/Distance'];
  List<String> gradingSystemList = ['GPA out of 10', 'GPA out of 4', 'Percentage'];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    print('Initial data: $data');

    _marksController = TextEditingController(text: data?.marks ?? '');
    degreeName = data?.degreeName ?? 'UnderGrad';
    collegeName = data?.collegeMasterName ?? '';
    courseName = data?.courseName ?? '';
    specializationName = data?.specializationName ?? '';
    passingYear = data?.passingYear ?? '';
    passingMonth = 'Jan';
    courseType = data?.courseType ?? 'Full-Time';
    gradingSystem = 'Percentage';
    gradeName = '';
    grade = '';
    _marksFocusNode.addListener(_handleMarksFocusChange);
    _initData();
  }

  void _handleMarksFocusChange() {
    if (_marksFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          _marksFieldKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _initData() async {
    try {
      await Future.wait([
        _fetchCollegeList(),
        _fetchCourseList(),
        _fetchSpecializationList(),
      ]);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _fetchCollegeList() async {
    final colleges = await ApiService.fetchCollegeList();
    if (!mounted) return;
    setState(() {
      collegeList = colleges.isNotEmpty ? colleges : ['No Colleges Available'];
      if (!collegeList.contains(collegeName)) {
        collegeName = collegeList[0];
      }
    });
  }

  Future<void> _fetchCourseList() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final results = await CourseListApi.fetchCourses(
      courseName: '',
      authToken: authToken,
      connectSid: connectSid,
    );
    if (!mounted) return;
    setState(() {
      courseList = results.isNotEmpty ? results : ['No Courses Available'];
      if (!courseList.contains(courseName)) {
        courseName = courseList[0];
      }
    });
  }

  Future<void> _fetchSpecializationList() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    final courseId = await _resolveCourseId(courseName);
    final specs = await SpecializationListApi.fetchSpecializations(
      specializationName: '',
      courseId: courseId,
      authToken: authToken,
      connectSid: connectSid,
    );
    if (!mounted) return;
    setState(() {
      specializationList = specs.isNotEmpty
          ? specs
          : ['No Specializations Available'];
      if (!specializationList.contains(specializationName)) {
        specializationName = specializationList[0];
      }
    });
  }

  Future<String> _resolveCourseId(String courseName) async {
    if (courseName.isEmpty || courseName == 'No Courses Available') return '';
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    final connectSid = prefs.getString('connectSid') ?? '';
    try {
      final response = await http
          .post(
        Uri.parse(
          'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/course/list',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
        },
        body: jsonEncode({"course_name": courseName}),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true &&
            data['data'] is List &&
            data['data'].isNotEmpty) {
          return data['data'][0]['id'].toString();
        }
      }
    } catch (_) {}
    return '';
  }

  @override
  void dispose() {
    _marksFocusNode.removeListener(_handleMarksFocusChange);
    _marksFocusNode.dispose();
    _marksController.dispose();
    super.dispose();
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
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Education Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _buildLabel("Degree Type"),
                      SearchableDropdownField(
                        value: degreeName,
                        items: const ["UnderGrad", "Graduate", "PostGraduate"],
                        onChanged: (val) => setState(() => degreeName = val ?? ''),
                      ),
                      _buildLabel("College"),
                      SearchableDropdownField(
                        value: collegeName,
                        items: collegeList,
                        onChanged: (val) => setState(() => collegeName = val ?? ''),
                      ),
                      _buildLabel("Course"),
                      SearchableDropdownField(
                        value: courseName,
                        items: courseList,
                        onChanged: (val) {
                          setState(() => courseName = val ?? '');
                          _fetchSpecializationList();
                        },
                      ),
                      _buildLabel("Specialization"),
                      SearchableDropdownField(
                        value: specializationName,
                        items: specializationList,
                        onChanged: (val) => setState(() => specializationName = val ?? ''),
                      ),
                      _buildLabel("Course Type"),
                      SearchableDropdownField(
                        value: courseType,
                        items: courseTypeList,
                        onChanged: (val) => setState(() => courseType = val ?? ''),
                      ),
                      _buildLabel("Grading System"),
                      SearchableDropdownField(
                        value: gradingSystem,
                        items: gradingSystemList,
                        onChanged: (val) => setState(() => gradingSystem = val ?? ''),
                      ),
                      _buildLabel("Marks"),
                      _buildTextField(
                        "Enter percentage or grade",
                        _marksController,
                        keyboardType: TextInputType.number,
                        key: _marksFieldKey,
                        focusNode: _marksFocusNode,
                      ),
                      _buildLabel("Year of Passing"),
                      SearchableDropdownField(
                        value: passingYear,
                        items: const ["2023", "2024", "2025", "2026", "2027", "2028", "2029"],
                        onChanged: (val) => setState(() => passingYear = val ?? ''),
                      ),
                      _buildLabel("Month of Passing"),
                      SearchableDropdownField(
                        value: passingMonth,
                        items: const [
                          "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                        ],
                        onChanged: (val) => setState(() => passingMonth = val ?? ''),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (collegeList[0].contains("No") ||
                              courseList[0].contains("No") ||
                              specializationList[0].contains("No")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please ensure all data is loaded",
                                ),
                              ),
                            );
                            return;
                          }
                          final data = {
                            'educationDetail': EducationDetailModel(
                              marks: _marksController.text,
                              passingYear: passingYear,
                              degreeName: degreeName,
                              courseName: courseName,
                              specializationName: specializationName,
                              collegeMasterName: collegeName,
                              courseType: courseType,
                            ),
                          };
                          widget.onSave(data);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005E6A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
  );

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        Key? key,
        FocusNode? focusNode,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      key: key,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}