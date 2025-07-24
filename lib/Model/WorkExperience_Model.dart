class WorkExperienceModel {
  final String jobTitle;
  final String organization;
  final String skills;
  final String workFromDate;
  final String workToDate;
  final String totalExperienceYears;
  final String totalExperienceMonths;
  final String salaryInLakhs;
  final String salaryInThousands;
  final String jobDescription;

  WorkExperienceModel({
    required this.jobTitle,
    required this.organization,
    required this.skills,
    required this.workFromDate,
    required this.workToDate,
    required this.totalExperienceYears,
    required this.totalExperienceMonths,
    required this.salaryInLakhs,
    required this.salaryInThousands,
    required this.jobDescription,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json){
    return WorkExperienceModel(
        jobTitle: json['job_title'] ?? '',
        organization:json['organization'] ?? '',
        skills: json['skills'] ?? '',
        workFromDate: json['work_from_date'] ?? '',
        workToDate: json['work_to_date'] ?? '',
        totalExperienceYears: json['total_experience_year'] ?? '',
        totalExperienceMonths: json['total_experience_months'] ?? '',
        salaryInLakhs: json['salary_in_lacs'] ?? '',
        salaryInThousands: json['salary_in_thousands'] ?? '',
        jobDescription: json['job_description'] ?? '',
    );
  }
}