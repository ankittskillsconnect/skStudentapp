import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import '../../Model/InterviewScreen_Model.dart';
import '../../Utilities/InterviewScreen_Api.dart';
import 'interviewCard.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  int _selectedIndex = 0;
  late Future<List<InterviewModel>> _interviewFuture;
  DateTime? _startDate;
  DateTime? _endDate;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _interviewFuture = InterviewApi.fetchInterviews();
  }

  Future<void> _refreshInterviewList() async {
    setState(() {
      _startDate = null;
      _endDate = null;
      _interviewFuture = InterviewApi.fetchInterviews();
    });
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 1)),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF005E6A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
              surface: Color(0xFFEBF6F7),
            ),
            dialogBackgroundColor: Color(0xFFEBF6F7),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFEBF6F7),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      print("📅 Selected range: $_startDate - $_endDate");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with design size from main.dart
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.tealAccent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        color: const Color(0xFFEBF6F7),
        child: RefreshIndicator(
          onRefresh: _refreshInterviewList,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(64.h),
              child: SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 0.8.r,
                                  blurRadius: 0.8.r,
                                  offset: const Offset(0, 1.6),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: _pickDateRange,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.black,
                                      size: 18.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Flexible(
                                      child: Text(
                                        _startDate != null && _endDate != null
                                            ? "${_startDate!.toLocal().toString().split(' ')[0]} → ${_endDate!.toLocal().toString().split(' ')[0]}"
                                            : "Select date range",
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                      size: 18.w,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        if (_startDate != null && _endDate != null)
                          _iconCircleButton(
                            Icons.close,
                            onTap: () {
                              setState(() {
                                _startDate = null;
                                _endDate = null;
                                _interviewFuture = InterviewApi.fetchInterviews();
                              });
                            },
                          ),
                        _iconCircleButton(Icons.notifications_outlined),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: FutureBuilder<List<InterviewModel>>(
                future: _interviewFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 14.w,
                      ),
                      itemCount: 5,
                      itemBuilder: (context, index) => _buildShimmerCard(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Failed to load interviews"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No interviews Scheduled yet"),
                    );
                  }
                  final data = snapshot.data!;
                  final filteredData = (_startDate != null && _endDate != null)
                      ? data.where((item) {
                    final interviewDate = DateTime.parse(item.date);
                    return interviewDate.isAfter(
                      _startDate!.subtract(const Duration(days: 1)),
                    ) &&
                        interviewDate.isBefore(
                          _endDate!.add(const Duration(days: 1)),
                        );
                  }).toList()
                      : data;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      children: filteredData.isEmpty
                          ? [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 34.h),
                          child: const Center(
                            child: Text(
                              'No interviews found',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ]
                          : filteredData.map((item) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: InterviewCard(
                            model: item,
                            onJoinTap: () {
                              print("Join tapped for: ${item.jobTitle}");
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconCircleButton(
      IconData icon, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          color: Colors.transparent,
        ),
        child: Icon(icon, size: 18.w, color: Colors.black),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34.w,
                        height: 34.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 15.h,
                              width: 100.w,
                              color: Colors.white,
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              height: 12.h,
                              width: 150.w,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Container(
                        height: 14.h,
                        width: 44.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 7.w,
                    runSpacing: 7.h,
                    children: List.generate(3, (index) {
                      return Container(
                        height: 18.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 12.h,
                    width: 70.w,
                    color: Colors.white,
                  ),
                  Container(
                    height: 12.h,
                    width: 50.w,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}