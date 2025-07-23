class EducationDetailModel {
  // final int userId;
  final String marks;
  // final int gradingType;
  //final String passingMonth;
  final String passingYear;
  //final int educationId;
  //final String? customCollegeName;
  final String degreeName;
  final String courseName;
 // final String gradeName;
  //final String grade;
  final String specializationName;
  final String collegeMasterName;

  EducationDetailModel({
    // required this.userId,
    required this.marks,
    required this.passingYear,
    required this.degreeName,
    required this.courseName,
    required this.specializationName,
    required this.collegeMasterName,
  });

  factory EducationDetailModel.fromJson(Map<String, dynamic> json) {
    return EducationDetailModel(
      // userId: json['user_id'],
      marks: json['marks'],
      // gradingType: json['grading_type'],
      // passingMonth: json['passing_month'],
      passingYear: json['passing_year'],
      // educationId: json['educationid'],
      // customCollegeName: json['custom_college_name'],
      degreeName: json['degree_name'],
      courseName: json['course_name'],
      // gradeName: json['grade_name'],
      // grade: json['grade'],
      specializationName: json['specilization_name'],
      collegeMasterName: json['clgmastername'],
    );
  }
}
