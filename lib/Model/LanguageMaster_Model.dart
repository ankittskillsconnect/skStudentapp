class LanguageMasterModel {
  final int languageId;
  final String languageName;

  LanguageMasterModel({
    required this.languageId,
    required this.languageName,
  });

  factory LanguageMasterModel.fromJson(Map<String, dynamic> json) {
    return LanguageMasterModel(
      languageId: json['id'] ?? 0,
      languageName: json['language_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': languageId,
      'language_name': languageName,
    };
  }
}
