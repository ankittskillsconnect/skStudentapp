class EducationDetailModel {
  // final int userId;
  final String marks;
  // final int gradingType;
  // final String passingMonth;
  final String passingYear;
  // final int? educationId;
  final String degreeName;
  final String courseName;
  // final String gradeName;
  // final String grade;
  final String specializationName;
  final String collegeMasterName;
  final String? courseType;

  EducationDetailModel({
    // required this.userId,
    // this.educationId,
    // required this.gradingType,
    // required this.passingMonth,
    // required this.gradeName,
    // required this.grade,
    required this.marks,
    required this.passingYear,
    required this.degreeName,
    required this.courseName,
    required this.specializationName,
    required this.collegeMasterName,
    this.courseType,
  });

  factory EducationDetailModel.fromJson(Map<String, dynamic> json) {
    return EducationDetailModel(
      // userId: json['user_id'],
      marks: json['marks'],
      // gradingType: json['grading_type'],
      // passingMonth: json['passing_month'],
      passingYear: json['passing_year'],
      // educationId: json['educationid'],
      degreeName: json['degree_name'] ?? '',
      courseName: json['course_name'],
      // gradeName: json['grade_name'],
      // grade: json['grade'],
      specializationName: json['specilization_name'],
      collegeMasterName: json['clgmastername'],
      courseType: json['course_type'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'user_id': userId,
  //     'educationid': educationId,
  //     'degreeType': _mapDegreeNameToType(degreeName),
  //     'college_id': collegeMasterName, // Raw name; ID will be resolved later
  //     'course': courseName, // Raw name; ID will be resolved later
  //     'specialization': specializationName, // Raw name; ID will be resolved later
  //     'course_type': courseType,
  //     'grading_system': gradingType,
  //     'marks': marks,
  //     'month': passingMonth,
  //     'year': passingYear,
  //   };
  // }
  //
  // static String _mapDegreeTypeToName(int type) {
  //   switch (type) {
  //     case 1:
  //       return 'UnderGrad';
  //     case 2:
  //       return 'Graduate';
  //     case 3:
  //       return 'PostGraduate';
  //     default:
  //       return 'UnderGrad';
  //   }
  // }
  //
  // static int _mapDegreeNameToType(String name) {
  //   switch (name) {
  //     case 'UnderGrad':
  //       return 1;
  //     case 'Graduate':
  //       return 2;
  //     case 'PostGraduate':
  //       return 3;
  //     default:
  //       return 1;
  //   }
  // }
}