import 'package:flutter/material.dart';

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Resume",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005E6A),
                padding: EdgeInsets.symmetric(horizontal: 16 * sizeScale),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30 * sizeScale),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14 * fontScale,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20 * sizeScale),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFBCD8DB)),
            borderRadius: BorderRadius.circular(12 * sizeScale),
          ),
          child: Column(
            children: [
              Icon(
                Icons.upload,
                size: 30 * sizeScale,
                color: const Color(0xFF005E6A),
              ),
              const SizedBox(height: 10),
              Text(
                "Upload Resume",
                style: TextStyle(
                  color: const Color(0xFF005E6A),
                  fontSize: 14 * fontScale,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}