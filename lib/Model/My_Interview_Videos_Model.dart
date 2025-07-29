class VideoIntroModel {
  final String aboutYourself;
  final String organizeYourDay;
  final String yourStrength;
  final String taughtYourselfLately;

  VideoIntroModel({
    required this.aboutYourself,
    required this.organizeYourDay,
    required this.yourStrength,
    required this.taughtYourselfLately,
  });

  factory VideoIntroModel.fromJson(Map<String, dynamic> json) {
    return VideoIntroModel(
      aboutYourself: json['about_yourself'] ?? '',
      organizeYourDay: json['organize_your_day'] ?? '',
      yourStrength: json['your_strength'] ?? '',
      taughtYourselfLately: json['taught_yourself_tately'] ?? '',
    );
  }
}
