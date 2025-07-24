class LanguagesModel {
  final String languageName;
  final String proficiency;

  LanguagesModel({
    required this.languageName,
    required this.proficiency,
  });

  factory LanguagesModel.fromJson(Map<String, dynamic> json){
    return LanguagesModel(
        languageName: json['language_name'],
        proficiency: json['proficiency'],
    );
  }
}