import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KnowHowBanner extends StatefulWidget {
  final String imageAsset;

  const KnowHowBanner({
    super.key,
    required this.imageAsset,
  });

  @override
  State<KnowHowBanner> createState() => _KnowHowBannerState();
}

class _KnowHowBannerState extends State<KnowHowBanner> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 13.h),
        Container(
          height: 140.h,
          margin: EdgeInsets.symmetric(horizontal: 14.w),
          child: PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(1.7.w),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBDE4E7),
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      image: AssetImage(widget.imageAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 17.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 7.w,
                color: _currentPage == index
                    ? const Color(0xFF003840)
                    : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}