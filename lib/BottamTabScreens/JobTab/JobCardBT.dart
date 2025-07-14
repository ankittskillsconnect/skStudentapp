import 'package:flutter/material.dart';

class JobCardBT extends StatelessWidget {
  final String jobTitle;
  final String company;
  final String location;
  final String salary;
  final String postTime;
  final String expiry;
  final List<String> tags;
  final String? logoUrl;

  const JobCardBT({
    super.key,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.salary,
    required this.postTime,
    required this.expiry,
    required this.tags,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    // print("Rendering JobCardBT - Title: $jobTitle, Company: $company, Location: $location, Tags: $tags, LogoUrl: $logoUrl"); // Debug log
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF6F7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFBCD8DB), width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF005E6A)),
                      ),
                      child: logoUrl != null && logoUrl!.isNotEmpty
                          ? Image.network(
                              logoUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                print(
                                  "Image load error for $logoUrl: $error",
                                ); // Debug error
                                return Image.asset(
                                  "assets/google.png",
                                  width: 40,
                                  height: 40,
                                );
                              },
                            )
                          : Image.asset(
                              "assets/google.png",
                              width: 40,
                              height: 40,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Color(0xFF003840),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "$company\n${location.isNotEmpty ? location : 'NA'}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF827B7B),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      salary,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF005E6A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF827B7B)),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Color(0xFF003840),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 22,
                      color: Color(0xFF003840),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      postTime,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF003840),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEDDDC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBCD8DB)),
                  ),
                  child: Text(
                    expiry,
                    style: const TextStyle(
                      color: Color(0xFFD03C2D),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
