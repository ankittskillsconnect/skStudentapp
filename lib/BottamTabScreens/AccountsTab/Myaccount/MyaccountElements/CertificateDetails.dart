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
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBCD8DB)),
              borderRadius: BorderRadius.circular(12 * sizeScale),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificatesList[i].certificateName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF005E6A),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        certificatesList[i].issuedOrgName,
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF003840),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${certificatesList[i].issueDate} - ${certificatesList[i].expiryDate}',
                        style: TextStyle(
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF003840),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        certificatesList[i].description,
                        style: TextStyle(
                          fontSize: 13 * fontScale,
                          color: Colors.grey[600],
                        ),
                      ),
                      // if (certificatesList[i].userId != null)
                      //   Text(
                      //     'User ID: ${certificatesList[i].userId}',
                      //     style: TextStyle(
                      //       fontSize: 12 * fontScale,
                      //       color: Colors.grey[500],
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF005E6A)),
                  onPressed: () => onEdit(certificatesList[i], i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => onDelete(i),
                ),
              ],
            ),
          ),
      ],
    );
  }
}