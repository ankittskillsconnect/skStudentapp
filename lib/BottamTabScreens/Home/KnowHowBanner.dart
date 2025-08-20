import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Model/Banner_model.dart';

class KnowHowBanner extends StatefulWidget {
  final List<BannerModel> banners;

  const KnowHowBanner({
    super.key,
    required this.banners,
  });

  @override
  State<KnowHowBanner> createState() => _KnowHowBannerState();
}

class _KnowHowBannerState extends State<KnowHowBanner> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    print('🔍 [KnowHowBanner] Disposing page controller');
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildImageWithShimmer(String url) {
    print('🟢 [KnowHowBanner] Loading banner image: $url');
    if (url.isEmpty || !Uri.parse(url).isAbsolute) {
      print('⚠️ [KnowHowBanner] Invalid URL: $url');
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: Icon(Icons.error, color: Colors.red, size: 17.7.w),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(9.5.r),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            print('✅ [KnowHowBanner] Finished loading: $url');
            return child;
          }
          print('⏳ [KnowHowBanner] Still loading: $url - '
              'bytes: ${loadingProgress.cumulativeBytesLoaded} / '
              '${loadingProgress.expectedTotalBytes ?? "unknown"}');
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 126.4.h,
              color: Colors.white,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ [KnowHowBanner] Error loading $url: $error');
          return Container(
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: Icon(Icons.error, color: Colors.red, size: 17.7.w),
          );
        },
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty || !Uri.parse(url).isAbsolute) {
      print('⚠️ [KnowHowBanner] Invalid URL for launching: $url');
      return;
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      print('✅ [KnowHowBanner] Successfully launched: $url');
    } else {
      print('❌ [KnowHowBanner] Could not launch: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔵 [KnowHowBanner] Rendering with ${widget.banners.length} banners');

    return Column(
      children: [
        SizedBox(height: 11.8.h),
        Container(
          height: 145.4.h,
          margin: EdgeInsets.symmetric(horizontal: 12.6.w),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                print('📍 [KnowHowBanner] Page changed to: $index');
              });
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              print('🖼 [KnowHowBanner] Showing banner index: $index with image: ${banner.image}');
              return Padding(
                padding: EdgeInsets.all(1.5.w),
                child: GestureDetector(
                  onTap: () {
                    print('👉 [KnowHowBanner] Tapped banner link: ${banner.link}');
                    _launchUrl(banner.link);
                  },
                  child: _buildImageWithShimmer(banner.image),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 15.4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.9.w),
              child: Icon(
                Icons.circle,
                size: 6.7.w,
                color: _currentPage == index ? const Color(0xFF003840) : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}