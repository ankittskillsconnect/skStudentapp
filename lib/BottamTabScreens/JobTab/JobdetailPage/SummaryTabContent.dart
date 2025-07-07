import 'package:flutter/material.dart';

class Summarytabcontent extends StatelessWidget {
  const Summarytabcontent({super.key});

  Widget buildSummaryItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF003840), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Job Summary",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003840),
            ),
          ),
          const SizedBox(height: 16),

          buildSummaryItem(
              Icons.calendar_today,
              "Posted On",
              "01 Mar, 2025",
          ),
          buildSummaryItem(
            Icons.schedule,
            "Application Deadline",
            "15 Jun, 2025",
          ),
          buildSummaryItem(
            Icons.event_available,
            "Expected Joining Date",
            "15 Jun, 2025",
          ),
          buildSummaryItem(
            Icons.work_outline,
            "Job Type",
            "Full Time, In-office",
          ),
          buildSummaryItem(
            Icons.people_alt_outlined,
            "Vacancies",
            "14 Openings",
          ),
        ],
      ),
    );
  }
}
