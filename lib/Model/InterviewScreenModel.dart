class InterviewModel {
  final String jobTitle;
  final String company;
  final String date;
  final String startTime;
  final String endTime;
  final String moderator;
  final String meetingMode;
  final bool isActive;

  InterviewModel({
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
    String rawDate = json['interview_date'] ?? '';
    String formattedDate = '';
    if (rawDate.contains('T')) {
      formattedDate = rawDate.split('T')[0];
    } else {
      formattedDate = rawDate;
    }

    return InterviewModel(
      jobTitle: json['job_title'] ?? '',
      company: json['company_name'] ?? '',
      date: formattedDate,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      moderator: json['moderator'] ?? '',
      meetingMode: json['meeting_mode'] ?? '',
      isActive: json['status'] == "Active",
    );
  }
}
