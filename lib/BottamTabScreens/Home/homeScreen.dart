import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sk_loginscreen1/BottamTabScreens/Home/CustomAppbarBT.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/JobdetailPage/JobdetailpageBT.dart';
import '../../Pages/bottombar.dart';
import 'KnowHowBanner.dart';
import 'PopularJobCard.dart';
import 'FeaturedJobCard.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    final double appBarHeight = 48.h;
    final double bottomNavBarHeight = 52.h;
    final double sectionHeaderHeight = 40.h;
    final double sizedBoxHeight = 10.h + 10.h + 17.h;
    final double knowHowBannerHeight = 85.h;
    final double paddingHeight = 14.h * 2;
    final double marginHeight = 38.h + 4.h;
    final double totalFixedHeight =
        appBarHeight +
            bottomNavBarHeight +
            (sectionHeaderHeight * 2) +
            sizedBoxHeight +
            knowHowBannerHeight +
            paddingHeight +
            marginHeight;

    final double availableHeight = ScreenUtil().screenHeight - totalFixedHeight;
    final double popularJobListHeight = availableHeight * 0.35;
    final double featuredJobListHeight = availableHeight * 0.65;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeScreenAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader("Popular Jobs", actionText: "See all"),
              SizedBox(
                height: popularJobListHeight.clamp(190.h, 210.h),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JobDetailPage2(jobToken: ''),
                      ),
                    );
                  },
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    children: [
                      PopularJobCard(
                        title: 'Product Manager',
                        subtitile: "Google",
                        description:
                        'Collaborate with cross-functional teams to define projects, requirements, and timelines.',
                        salary: '1.25L/month',
                        time: 'Posted 7 mins ago',
                        immageAsset: 'assets/google.png',
                      ),
                      PopularJobCard(
                        title: 'UI/UX',
                        subtitile: "Zune Studios",
                        description:
                        'Work on UI/UX projects with a focus on user experience and design.',
                        salary: '35K/month',
                        time: 'Posted 7 mins ago',
                        immageAsset: 'assets/UIUXpurple.png',
                      ),
                      PopularJobCard(
                        title: 'UI Designer',
                        subtitile: "Zune Studios",
                        description:
                        'Design intuitive user interfaces for web and mobile applications.',
                        salary: '25K/month',
                        time: 'Posted 10 mins ago',
                        immageAsset: 'assets/UIUXpurple.png',
                      ),
                      PopularJobCard(
                        title: 'Interaction Designer',
                        subtitile: "Zune Studios",
                        description:
                        'Create interactive prototypes and design user flows.',
                        salary: '23K/month',
                        time: 'Posted 20 mins ago',
                        immageAsset: 'assets/UIUXpurple.png',
                      ),
                    ].map((card) {
                      try {
                        return card;
                      } catch (e) {
                        print("Error building PopularJobCard: $e");
                        return const SizedBox.shrink();
                      }
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              const KnowHowBanner(imageAsset: 'assets/KnowHow.png'),
              SizedBox(height: 10.h),
              _sectionHeader("Featured Opportunities"),
              SizedBox(
                height: featuredJobListHeight.clamp(240.h, 270.h),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  children: const [
                    FeaturedJobCard(
                      title: 'Product Manager',
                      location: 'Bangalore, Karnataka, India',
                      salary: '₹12-15 LPA',
                      applications: '87',
                      timeLeft: '9 days left',
                      registered: '13000 Registered',
                      jobType: 'Full time (On-site) Hybrid (3 days WFH)',
                      imageAsset: 'assets/Job_Image_1.png',
                    ),
                    FeaturedJobCard(
                      title: 'Frontend Developer',
                      location: 'Hyderabad, Telangana, India',
                      salary: '₹10-12 LPA',
                      applications: '97',
                      timeLeft: '17 days left',
                      registered: '13000 Registered',
                      jobType: 'Part time (On-site) Hybrid (3 days WFH)',
                      imageAsset: 'assets/Job_Image_2.png',
                    ),
                    FeaturedJobCard(
                      title: 'UI/UX Designer',
                      location: 'Mumbai, Maharashtra, India',
                      salary: '₹11-14 LPA',
                      applications: '65',
                      timeLeft: '12 days left',
                      registered: '12000 Registered',
                      jobType: 'Full time (Hybrid) Hybrid (3 days WFH)',
                      imageAsset: 'assets/Job_Image_1.png',
                    ),
                    FeaturedJobCard(
                      title: 'Backend Developer',
                      location: 'Chennai, Tamil Nadu, India',
                      salary: '₹13-16 LPA',
                      applications: '80',
                      timeLeft: '14 days left',
                      registered: '11000 Registered',
                      jobType: 'Full time (On-site) Hybrid (3 days WFH)',
                      imageAsset: 'assets/Job_Image_1.png',
                    ),
                    FeaturedJobCard(
                      title: 'Data Analyst',
                      location: 'Pune, Maharashtra, India',
                      salary: '₹9-11 LPA',
                      applications: '50',
                      timeLeft: '10 days left',
                      registered: '10000 Registered',
                      jobType: 'Part time (Remote) Hybrid (3 days WFH)',
                      imageAsset: 'assets/Job_Image_1.png',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _sectionHeader(String title, {String? actionText}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF003840),
            ),
          ),
          if (actionText != null)
            Text(
              actionText,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}