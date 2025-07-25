import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PersonalDetailsShimmer extends StatelessWidget {
  final double sizeScale;
  final double fontScale;

  const PersonalDetailsShimmer({
    super.key,
    required this.sizeScale,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16 * sizeScale),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFBCD8DB)),
        borderRadius: BorderRadius.circular(12 * sizeScale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class EducationShimmer extends StatelessWidget {
  final double sizeScale;
  final double fontScale;

  const EducationShimmer({
    super.key,
    required this.sizeScale,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (index) {
        return Container(
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
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 40 * sizeScale,
                  height: 40 * sizeScale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 140,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 6),
                      ),
                      Container(
                        height: 14,
                        width: 200,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 6),
                      ),
                      Container(
                        height: 14,
                        width: 160,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(Icons.edit, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(Icons.delete_outline, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ProjectShimmer extends StatelessWidget {
  final double sizeScale;
  final double fontScale;

  const ProjectShimmer({
    super.key,
    required this.sizeScale,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (index) {
        return Container(
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
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  padding: EdgeInsets.all(6 * sizeScale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 36 * sizeScale,
                  height: 36 * sizeScale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20 * fontScale,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 14 * fontScale,
                        width: 140,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 14 * fontScale,
                        width: 200,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 14 * fontScale,
                        width: 160,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 13 * fontScale,
                        width: 180,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 13 * fontScale,
                        width: 220,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(Icons.edit, color: Colors.grey, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(Icons.delete_outline, color: Colors.grey, size: 24),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SkillsShimmer extends StatelessWidget {
  final double sizeScale;
  final double fontScale;

  const SkillsShimmer({
    super.key,
    required this.sizeScale,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (index) {
        return Container(
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
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  padding: EdgeInsets.all(6 * sizeScale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 36 * sizeScale,
                  height: 36 * sizeScale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20 * fontScale,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 14 * fontScale,
                        width: 140,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 14 * fontScale,
                        width: 200,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 14 * fontScale,
                        width: 160,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 13 * fontScale,
                        width: 180,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      Container(
                        height: 13 * fontScale,
                        width: 220,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(Icons.edit, color: Colors.grey, size: 24),
                  ),
                  const SizedBox(height: 4),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const Icon(Icons.delete_outline, color: Colors.grey, size: 24),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}