class InternshipProjectModel {
  final String type;
  final String projectName;
  final String companyName;
  final String skills;
  final int duration;
  final String durationPeriod;
  final String details;

  InternshipProjectModel({
    required this.type,
    required this.projectName,
    required this.companyName,
    required this.skills,
    required this.duration,
    required this.durationPeriod,
    required this.details,
  });

  factory InternshipProjectModel.fromJson(Map<String, dynamic> json) {
    return InternshipProjectModel(
      type: json['type'] ?? '',
      companyName: json['company_name'] ?? '',
      projectName: json['project_name'] ?? '',
      duration: json['duration'] ?? 0,
      durationPeriod: json['duration_period'] ?? '',
      details: json['details'] ?? '',
      skills: json['skills'] ?? '',
    );
  }
}
