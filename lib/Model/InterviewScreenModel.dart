class InterviewModel {
  final String jobTitle;
  final String company;
  final String date;
  final String startTime;
  final String endTime;
  final String moderator;
  final String meetingMode;
  final bool isActive;

  InterviewModel( {
    required this.jobTitle,
    required this.company,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.moderator,
    required this.meetingMode,
    required this.isActive,
  });

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
      jobTitle: json['job_title'] ?? '',
      company: json['company_name'] ?? '',
      date: json['interview_date'] ?? '',
      endTime: json['end_time'] ?? '',
      startTime: json['start_time'] ?? '',
      moderator: json['moderator'] ?? '',
      meetingMode: json['meeting_mode'] ?? '',
      isActive: json['status'] == "Active",
    );
  }
}
