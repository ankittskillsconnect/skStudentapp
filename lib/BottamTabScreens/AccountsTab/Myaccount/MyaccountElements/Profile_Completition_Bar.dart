import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../Utilities/MyAccount_Get_Post/Get/AccountProgress_Api.dart';

class ProfileCompletionBar extends StatefulWidget {
  const ProfileCompletionBar({super.key});

  @override
  State<ProfileCompletionBar> createState() => _ProfileCompletionBarState();
}

class _ProfileCompletionBarState extends State<ProfileCompletionBar> {
  String? percentage;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProfileCompletion();
  }

  Future<void> fetchProfileCompletion() async {
    try {
      final result = await ProfileCompletionApi.fetchProfileCompletion();

      if (mounted) {
        setState(() {
          if (result != null) {
            percentage = result.setupPercentage;
            print("📥 Assigned percentage = $percentage");
            errorMessage = null;
          } else {
            errorMessage = 'Failed to load profile completion data.';
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching profile completion: $e';
        });
      }
      print("⚠️ Exception in fetchProfileCompletion: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || percentage == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 16, width: 180, color: Colors.white),
            const SizedBox(height: 8),
            Container(height: 10, width: double.infinity, color: Colors.white),
          ],
        ),
      );
    }

    final parsed = double.tryParse(percentage ?? '') ?? 0.0;
    final clampedPercent = parsed.clamp(0.0, 100.0);
    final isLow = clampedPercent < 30;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Profile Completion Status",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF005E6A),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${clampedPercent.toInt()}%",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isLow ? Colors.red : const Color(0xFF027D92),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          animation: true,
          animationDuration: 500,
          lineHeight: 10.0,
          percent: clampedPercent / 100,
          backgroundColor: Colors.grey.shade300,
          progressColor: isLow ? Colors.red : null,
          linearGradient: isLow
              ? null
              : const LinearGradient(
            colors: [Color(0xFF027D92), Color(0xFF6ED4F9)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barRadius: const Radius.circular(10),
        ),
      ],
    );
  }
}
