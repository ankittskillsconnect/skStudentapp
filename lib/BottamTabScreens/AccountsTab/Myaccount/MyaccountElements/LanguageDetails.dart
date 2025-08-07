import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/Model/Languages_Model.dart';
import 'SectionHeader.dart';

class LanguagesSection extends StatelessWidget {
  final List<LanguagesModel> languageList;
  final bool isLoading;
  final VoidCallback onAdd;
  final Function(int) onDelete;

  const LanguagesSection({
    super.key,
    required this.languageList,
    required this.isLoading,
    required this.onAdd,
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
          title: "Languages",
          showAdd: true,
          onAdd: onAdd,
        ),
        for (var i = 0; i < languageList.length; i++)
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
                /// Top Row: Icon + Language Name + Delete
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6 * sizeScale),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF6F7),
                        borderRadius: BorderRadius.circular(12 * sizeScale),
                      ),
                      child: Icon(
                        Icons.language,
                        size: 20 * sizeScale,
                        color: const Color(0xFF005E6A),
                      ),
                    ),
                    SizedBox(width: 10 * sizeScale),
                    Expanded(
                      child: Text(
                        languageList[i].languageName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14 * fontScale,
                          color: const Color(0xFF005E6A),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      iconSize: 20 * sizeScale,
                      onPressed: () => onDelete(i),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                SizedBox(height: 6 * sizeScale),

                Text(
                  languageList[i].proficiency,
                  style: TextStyle(
                    fontSize: 13 * fontScale,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
