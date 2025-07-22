import 'package:flutter/material.dart';

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
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       "Know How",
        //       style: TextStyle(
        //         fontWeight: FontWeight.w600,
        //         color: const Color(0xFF003840),
        //         fontSize: 16,
        //       ),
        //     ),
        //     const Icon(
        //       Icons.keyboard_arrow_down,
        //       size: 20,
        //       color: Color(0xFF003840),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 15),
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBDE4E7),
                    borderRadius: BorderRadius.circular(12),
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
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.circle,
                size: 8,
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