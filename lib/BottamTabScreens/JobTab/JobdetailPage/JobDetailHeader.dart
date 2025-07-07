import 'package:flutter/material.dart';

class JobHeaderSection extends StatelessWidget {
  const JobHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthScale = size.width / 360;
    final fontScale = (widthScale * 0.9).clamp(0.9, 1.2);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14 * widthScale, vertical: 10 * widthScale),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/google.png', height: 48 * widthScale, width: 48 * widthScale),
              SizedBox(width: 10 * widthScale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Software engineer",
                            style: TextStyle(
                              fontSize: 18 * fontScale,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF005E6A),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.bookmark_add_outlined,
                            size: 26 * widthScale,
                            color: const Color(0xFF005E6A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Google • Surat, India",
                      style: TextStyle(
                        fontSize: 14 * fontScale,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * widthScale),
          Padding(
            padding: EdgeInsets.only(left: 10 * widthScale),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10 * widthScale,
                children: const [
                  _Tag(label: "Full-time"),
                  _Tag(label: "In-office"),
                  _Tag(label: "14 Openings"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthScale = size.width / 360;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * widthScale,
        vertical: 6 * widthScale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F9),
        borderRadius: BorderRadius.circular(20 * widthScale),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF005E6A),
          fontSize: 14 * widthScale,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
