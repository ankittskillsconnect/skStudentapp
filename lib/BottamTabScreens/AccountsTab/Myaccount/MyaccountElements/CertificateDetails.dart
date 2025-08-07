import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Model/CertificateDetails_Model.dart';
import 'SectionHeader.dart';

class CertificatesSection extends StatelessWidget {
  final List<CertificateModel> certificatesList;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(CertificateModel, int) onEdit;
  final Function(int) onDelete;

  const CertificatesSection({
    super.key,
    required this.certificatesList,
    required this.isLoading,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: "Certificate Details",
          showAdd: true,
          onAdd: onAdd,
        ),
        for (var i = 0; i < certificatesList.length; i++)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14 * sizeScale),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBCD8DB)),
              borderRadius: BorderRadius.circular(12 * sizeScale),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6 * sizeScale),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF6F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.file_copy_outlined,
                        size: 24,
                        color: Color(0xFF005E6A),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        certificatesList[i].certificateName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onEdit(certificatesList[i], i),
                    ),

                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      iconSize: 18,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => onDelete(i),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'Organization : ${certificatesList[i].issuedOrgName}',
                  style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  'Issue Date : ${certificatesList[i].issueDate}',
                  style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  'Expiry Date : ${certificatesList[i].expiryDate}',
                   style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  'Details : ${certificatesList[i].description}',
                  style: TextStyle(
                    fontSize: 13 * fontScale,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF003840),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
