class ResumeModel {
  final String resume;

  ResumeModel({
    required this.resume,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      resume: json['resume'] ?? '',
    );
  }
}
