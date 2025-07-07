import 'package:flutter/material.dart';

class FeaturedJobCard extends StatelessWidget {
  final String title;
  final String location;
  final String salary;
  final String applications;
  final String timeLeft;
  final String registered;
  final String jobType;
  final String imageAsset;
  final VoidCallback? onTap;

  const FeaturedJobCard({
    super.key,
    required this.title,
    required this.location,
    required this.salary,
    required this.applications,
    required this.timeLeft,
    required this.registered,
    required this.jobType,
    required this.imageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardWidth = screenWidth * 0.55;
    final imageHeight = screenHeight * 0.14;
    final iconSize = screenWidth * 0.05;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.36,
        maxHeight: screenHeight * 0.42,
      ),
      child: Card(
        margin: EdgeInsets.only(
          right: screenWidth * 0.035,
          bottom: screenWidth * 0.01,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: Image.asset(
                    imageAsset,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenWidth * 0.025,
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          Text(
                            "$salary • $applications Applications",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF003840),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          Row(
                            children: [
                              Icon(
                                Icons.group,
                                size: iconSize,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Flexible(
                                child: Text(
                                  registered,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: const Color(0xFF003840),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: iconSize,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Flexible(
                                child: Text(
                                  timeLeft,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: const Color(0xFF003840),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Text(
                            jobType,
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
