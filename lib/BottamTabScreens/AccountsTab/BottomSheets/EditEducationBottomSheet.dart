import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Utilities/AllCourseApi.dart';
import '../../../Utilities/CollegeListApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEducationBottomSheet extends StatefulWidget {
  final String? initialData;
  final String degreeType;
  final String courseName;
  final String college;
  final String specilization;
  final String courseType;
  final String gradingSystem;
  final String percentage;
  final String passingYear;
  final Function(Map<String, dynamic> data) onSave;

  const EditEducationBottomSheet({
    super.key,
    this.initialData,
    required this.onSave,
    required this.degreeType,
    required this.courseName,
    required this.college,
    required this.specilization,
    required this.courseType,
    required this.percentage,
    required this.passingYear,
    required this.gradingSystem,
  });

  @override
  State<EditEducationBottomSheet> createState() =>
      _EditEducationBottomSheetState();
}

class _EditEducationBottomSheetState extends State<EditEducationBottomSheet> {
  late TextEditingController _percentageController;
  late String degreeType;
  late String college;
  late String courseName;
  late String specilization;
  late String courseType;
  late String gradingSystem;
  late String passingYear;
  List<String> collegeList = [];
  List<String> courseList = [];

  @override
  void initState() {
    super.initState();
    _percentageController = TextEditingController(text: widget.percentage);
    degreeType = widget.degreeType == 'Undergrad'
        ? 'UnderGrad'
        : widget.degreeType;
    college = widget.college;
    courseName = widget.courseName;
    specilization = widget.specilization;
    courseType = widget.courseType.isEmpty ? '' : widget.courseType;
    gradingSystem = widget.gradingSystem;
    passingYear = widget.passingYear;
    _fetchCollegeList();
    _fetchCourseList();
  }

  Future<void> _fetchCollegeList() async {
    final colleges = await ApiService.fetchCollegeList();
    setState(() {
      collegeList = colleges;
      if (!collegeList.contains(college) && collegeList.isNotEmpty) {
        college = collegeList[0];
      }
    });
  }

  Future<void> _fetchCourseList() async {
    final courses = await CourseListApi.fetchCourses(courseName: courseName);
    setState(() {
      courseList = courses;
      if (!courseList.contains(courseName) && courseList.isNotEmpty) {
        courseName = courseList[0];
      }
    });
  }

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
  }

  String _formatEducationDetail() {
    return '''
   $degreeType\n$courseName ($specilization)\n$courseType - $college\n$passingYear
    ''';
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
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Education Details',
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
                Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 10),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildLabel("Degree type"),
                        _buildDropdownField(
                          value: degreeType,
                          items: const ["UnderGrad", "Graduate", "Open"],
                          onChanged: (val) =>
                              setState(() => degreeType = val ?? ''),
                        ),
                        _buildLabel("College name"),
                        _buildDropdownField(
                          value: collegeList.contains(college)
                              ? college
                              : (collegeList.isNotEmpty
                                    ? collegeList[0]
                                    : null),
                          items: collegeList.isEmpty
                              ? ['Loading...']
                              : collegeList,
                          onChanged: (val) =>
                              setState(() => college = val ?? ''),
                        ),
                        _buildLabel("Course name"),
                        _buildDropdownField(
                          value: courseList.contains(courseName)
                              ? courseName
                              : (courseList.isNotEmpty ? courseList[0] : null),
                          items: courseList.isEmpty
                              ? ['No Courses Found']
                              : courseList,
                          onChanged: (val) =>
                              setState(() => courseName = val ?? ''),
                        ),

                        _buildLabel("Specialization"),
                        _buildDropdownField(
                          value: specilization,
                          items: const ["Advertisement", "Flutter", "It"],
                          onChanged: (val) =>
                              setState(() => specilization = val ?? ''),
                        ),
                        _buildLabel("Course type"),
                        Column(
                          children: [
                            Row(
                              children: [
                                _buildRadio("Full Time"),
                                _buildRadio("Part Time"),
                              ],
                            ),
                            Row(
                              children: [
                                _buildRadio(
                                  "Correspondences / Distance learning",
                                ),
                              ],
                            ),
                          ],
                        ),
                        _buildLabel("Grading system"),
                        _buildDropdownField(
                          value: gradingSystem,
                          items: const ["CGPA", "Percentage"],
                          onChanged: (val) =>
                              setState(() => gradingSystem = val ?? ''),
                        ),
                        _buildLabel("Your percentage / grade"),
                        _buildTextField(
                          "Please select",
                          _percentageController,
                          keyboardType: TextInputType.number,
                        ),
                        _buildLabel("Year of passing"),
                        _buildDropdownField(
                          value: passingYear,
                          items: const ["2023", "2024", "2025"],
                          onChanged: (val) =>
                              setState(() => passingYear = val ?? ''),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005E6A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            final data = {
                              'educationDetail': _formatEducationDetail(),
                              'degreeType': degreeType,
                              'courseName': courseName,
                              'specilization': specilization,
                              'courseType': courseType,
                              'college': college,
                              'gradingSystem': gradingSystem,
                              'percentage': _percentageController.text,
                              'passingYear': passingYear,
                            };
                            widget.onSave(data);
                            setState(() {
                              degreeType = '';
                              college = '';
                              courseName = '';
                              specilization = '';
                              courseType = '';
                              gradingSystem = '';
                              passingYear = '';
                              _percentageController.clear();
                            });
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
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
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: items.contains(value)
              ? value
              : (items.isNotEmpty ? items[0] : null),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e, overflow: TextOverflow.ellipsis, maxLines: 1),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
              FocusScope.of(context).unfocus();
            }
          },
          decoration: InputDecoration(
            hintText: 'Please select',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
          dropdownColor: Colors.white,
          menuMaxHeight: 250,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: courseType,
          onChanged: (val) => setState(() => courseType = val ?? ''),
          activeColor: const Color(0xFF005E6A),
        ),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

//updated
