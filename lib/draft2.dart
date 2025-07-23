// old educationbottomsheet code
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../Utilities/CollegeList_Api.dart';
// import '../../../Utilities/Specialization_Api.dart';
// import 'package:sk_loginscreen1/Utilities/AllCourse_Api.dart';
//
// class EditEducationBottomSheet extends StatefulWidget {
//   final String? initialData;
//   final String degreeType;
//   final String courseName;
//   final String college;
//   final String specilization;
//   final String courseType;
//   final String gradingSystem;
//   final String percentage;
//   final String passingYear;
//   final Function(Map<String, dynamic> data) onSave;
//
//   const EditEducationBottomSheet({
//     super.key,
//     this.initialData,
//     required this.onSave,
//     required this.degreeType,
//     required this.courseName,
//     required this.college,
//     required this.specilization,
//     required this.courseType,
//     required this.percentage,
//     required this.passingYear,
//     required this.gradingSystem,
//   });
//
//   @override
//   State<EditEducationBottomSheet> createState() =>
//       _EditEducationBottomSheetState();
// }
//
// class _EditEducationBottomSheetState extends State<EditEducationBottomSheet> {
//   late TextEditingController _percentageController;
//   late String degreeType;
//   late String college;
//   late String courseName;
//   late String specilization;
//   late String courseType;
//   late String gradingSystem;
//   late String passingYear;
//   bool isLoading = true;
//   List<String> collegeList = [];
//   List<String> courseList = [];
//   List<String> specializationList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _percentageController = TextEditingController(text: widget.percentage);
//     degreeType = widget.degreeType == 'Undergrad'
//         ? 'UnderGrad'
//         : widget.degreeType;
//     college = widget.college;
//     courseName = widget.courseName;
//     specilization = widget.specilization;
//     courseType = widget.courseType;
//     gradingSystem = widget.gradingSystem;
//     passingYear = widget.passingYear;
//     _initData();
//   }
//
//   Future<void> _initData() async {
//     try {
//       await Future.wait([
//         _fetchCollegeList(),
//         _fetchCourseList(),
//         _fetchSpecializationList(),
//       ]);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
//       }
//     } finally {
//       if (mounted) {
//         setState(() => isLoading = false);
//       }
//     }
//   }
//
//   Future<void> _fetchCollegeList() async {
//     final colleges = await ApiService.fetchCollegeList();
//     if (!mounted) return;
//     setState(() {
//       collegeList = colleges.isNotEmpty ? colleges : ['No Colleges Available'];
//       if (!collegeList.contains(widget.college)) {
//         college = collegeList[0];
//       } else {
//         college = widget.college;
//       }
//     });
//   }
//
//   Future<void> _fetchCourseList() async {
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('authToken') ?? '';
//     final connectSid = prefs.getString('connectSid') ?? '';
//     final results = await CourseListApi.fetchCourses(
//       courseName: '',
//       authToken: authToken,
//       connectSid: connectSid,
//     );
//     if (!mounted) return;
//     setState(() {
//       courseList = results.isNotEmpty ? results : ['No Courses Available'];
//       if (!courseList.contains(widget.courseName)) {
//         courseName = courseList[0];
//       } else {
//         courseName = widget.courseName;
//       }
//     });
//   }
//
//   Future<void> _fetchSpecializationList() async {
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('authToken') ?? '';
//     final connectSid = prefs.getString('connectSid') ?? '';
//     final courseId = await _resolveCourseId(courseName);
//     final specs = await SpecializationListApi.fetchSpecializations(
//       specializationName: '',
//       courseId: courseId,
//       authToken: authToken,
//       connectSid: connectSid,
//     );
//     if (!mounted) return;
//     setState(() {
//       specializationList = specs.isNotEmpty
//           ? specs
//           : ['No Specializations Available'];
//       if (!specializationList.contains(widget.specilization)) {
//         specilization = specializationList[0];
//       } else {
//         specilization = widget.specilization;
//       }
//     });
//   }
//
//   Future<String> _resolveCourseId(String courseName) async {
//     if (courseName.isEmpty || courseName == 'No Courses Available') return '';
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('authToken') ?? '';
//     final connectSid = prefs.getString('connectSid') ?? '';
//     try {
//       final response = await http
//           .post(
//         Uri.parse(
//           'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/master/course/list',
//         ),
//         headers: {
//           'Content-Type': 'application/json',
//           'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
//         },
//         body: jsonEncode({"course_name": courseName}),
//       )
//           .timeout(const Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == true &&
//             data['data'] is List &&
//             data['data'].isNotEmpty) {
//           return data['data'][0]['id'].toString();
//         }
//       }
//     } catch (e) {
//       print("Error resolving course ID: $e");
//     }
//     return '';
//   }
//
//   @override
//   void dispose() {
//     _percentageController.dispose();
//     super.dispose();
//   }
//
//   String _formatEducationDetail() {
//     return '$degreeType\n$courseName ($specilization)\n$courseType - $college\n$passingYear';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       expand: false,
//       initialChildSize: 0.9,
//       maxChildSize: 0.9,
//       minChildSize: 0.9,
//       builder: (context, scrollController) {
//         return GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Add Education Details',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF003840),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.close,
//                         color: Color(0xFF005E6A),
//                       ),
//                       onPressed: () {
//                         try {
//                           Navigator.of(context).pop();
//                         } catch (e) {
//                           print("Error closing bottom sheet: $e");
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: AnimatedPadding(
//                     duration: const Duration(milliseconds: 10),
//                     padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom,
//                     ),
//                     child: ListView(
//                       controller: scrollController,
//                       children: [
//                         _buildLabel("Degree type"),
//                         _buildDropdownField(
//                           value: degreeType,
//                           items: const ["UnderGrad", "Graduate", "Open"],
//                           onChanged: (val) =>
//                               setState(() => degreeType = val ?? ''),
//                         ),
//                         _buildLabel("College name"),
//                         _buildDropdownField(
//                           value: college,
//                           items: collegeList,
//                           onChanged: (val) =>
//                               setState(() => college = val ?? ''),
//                         ),
//                         _buildLabel("Course name"),
//                         _buildDropdownField(
//                           value: courseName,
//                           items: courseList,
//                           onChanged: (val) =>
//                               setState(() => courseName = val ?? ''),
//                         ),
//                         _buildLabel("Specialization"),
//                         _buildDropdownField(
//                           value: specilization,
//                           items: specializationList,
//                           onChanged: (val) =>
//                               setState(() => specilization = val ?? ''),
//                         ),
//                         _buildLabel("Course type"),
//                         Column(
//                           children: [
//                             Row(
//                               children: [
//                                 _buildRadio("Full Time"),
//                                 _buildRadio("Part Time"),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 _buildRadio(
//                                   "Correspondences / Distance learning",
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         _buildLabel("Grading system"),
//                         _buildDropdownField(
//                           value: gradingSystem,
//                           items: const ["CGPA", "Percentage"],
//                           onChanged: (val) =>
//                               setState(() => gradingSystem = val ?? ''),
//                         ),
//                         _buildLabel("Your percentage / grade"),
//                         _buildTextField(
//                           "Please select",
//                           _percentageController,
//                           keyboardType: TextInputType.number,
//                         ),
//                         _buildLabel("Year of passing"),
//                         _buildDropdownField(
//                           value: passingYear,
//                           items: const ["2023", "2024", "2025"],
//                           onChanged: (val) =>
//                               setState(() => passingYear = val ?? ''),
//                         ),
//                         const SizedBox(height: 30),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF005E6A),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             minimumSize: const Size.fromHeight(50),
//                           ),
//                           onPressed: () {
//                             if (collegeList[0] ==
//                                 'No Colleges Available' ||
//                                 courseList[0] == 'No Courses Available' ||
//                                 specializationList[0] ==
//                                     'No Specializations Available') {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                     'Please ensure all data is loaded',
//                                   ),
//                                 ),
//                               );
//                               return;
//                             }
//                             final data = {
//                               'educationDetail': _formatEducationDetail(),
//                               'degreeType': degreeType,
//                               'courseName': courseName,
//                               'specilization': specilization,
//                               'courseType': courseType,
//                               'college': college,
//                               'gradingSystem': gradingSystem,
//                               'percentage': _percentageController.text,
//                               'passingYear': passingYear,
//                             };
//                             widget.onSave(data);
//                           },
//                           child: const Text(
//                             "Save",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildLabel(String text) => Padding(
//     padding: const EdgeInsets.only(top: 12, bottom: 6),
//     child: Text(
//       text,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w700,
//         color: Color(0xff003840),
//       ),
//     ),
//   );
//
//   Widget _buildDropdownField({
//     required String? value,
//     required List<String> items,
//     required void Function(String?) onChanged,
//   }) {
//     final displayValue = items.contains(value)
//         ? value
//         : (items.isNotEmpty ? items[0] : null);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: DropdownButtonFormField<String>(
//         isExpanded: true,
//         value: displayValue,
//         items: items
//             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//             .toList(),
//         onChanged: (newValue) {
//           if (newValue != null &&
//               newValue != 'No Courses Available' &&
//               newValue != 'No Specializations Available' &&
//               newValue != 'No Colleges Available') {
//             onChanged(newValue);
//             FocusScope.of(context).unfocus();
//             if (newValue == courseName) {
//               _fetchSpecializationList();
//             }
//           }
//         },
//         decoration: InputDecoration(
//           hintText: 'Please select',
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 10,
//             vertical: 10,
//           ),
//         ),
//         dropdownColor: Colors.white,
//         menuMaxHeight: 250,
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );
//   }
//
//   Widget _buildRadio(String value) => Row(
//     children: [
//       Radio<String>(
//         value: value,
//         groupValue: courseType,
//         onChanged: (val) => setState(() => courseType = val ?? ''),
//         activeColor: const Color(0xFF005E6A),
//       ),
//       Text(value, style: const TextStyle(fontSize: 13)),
//     ],
//   );
//
//   Widget _buildTextField(
//       String label,
//       TextEditingController controller, {
//         TextInputType keyboardType = TextInputType.text,
//       }) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 6),
//     child: TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     ),
//   );
// }
