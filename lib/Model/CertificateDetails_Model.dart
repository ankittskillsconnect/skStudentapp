class CertificateModel {
  final String certificateName;
  final String issuedOrgName;
  final String credId;
  final String issueDate;
  final String expiryDate;
  final String description;

  CertificateModel({
    required this.certificateName,
    required this.issuedOrgName,
    required this.credId,
    required this.issueDate,
    required this.expiryDate,
    required this.description,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json){
    return CertificateModel(
        certificateName: json['certification_name'] ?? '',
        issuedOrgName: json['issued_org_name'] ?? '',
        credId: json['cred_id'] ?? '',
        issueDate: json['issue_date'] ?? '',
        expiryDate: json['expire_date'] ?? '',
        description: json['description'] ?? ''
    );
  }
}