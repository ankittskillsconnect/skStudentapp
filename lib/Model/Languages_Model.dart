class LanguagesModel {
  final int languageId;
  final String languageName;
  final String proficiency;

  LanguagesModel({
    required this.languageId,
    required this.languageName,
    required this.proficiency,
  });

  factory LanguagesModel.fromJson(Map<String, dynamic> json) {
    return LanguagesModel(
      languageId: json['language_id'],
      languageName: json['language_name'],
      proficiency: json['proficiency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languages': languageId.toString(),
      'proficiency': proficiency,
    };
  }
}
