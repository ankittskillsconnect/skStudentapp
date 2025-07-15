class JobModel {
  final String jobToken;
  final String jobTitle;
  final String company;
  final String location;
  final String salary;
  final String postTime;
  final String expiry;
  final List<String> tags;
  final String? logoUrl;

  JobModel({
    required this.jobToken,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.salary,
    required this.postTime,
    required this.expiry,
    required this.tags,
    this.logoUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobModel &&
              runtimeType == other.runtimeType &&
              jobToken == other.jobToken;

  @override
  int get hashCode => jobToken.hashCode;

  // Optional: for saving to SharedPreferences or API integration
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      jobToken: json['jobToken'],
      jobTitle: json['jobTitle'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      postTime: json['postTime'],
      expiry: json['expiry'],
      tags: List<String>.from(json['tags'] ?? []),
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobToken': jobToken,
      'jobTitle': jobTitle,
      'company': company,
      'location': location,
      'salary': salary,
      'postTime': postTime,
      'expiry': expiry,
      'tags': tags,
      'logoUrl': logoUrl,
    };
  }
}
