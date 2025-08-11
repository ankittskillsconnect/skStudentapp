import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Model/Job_Model.dart';
import '../../../Utilities/JobDetail_Api.dart';
import '../../../blocpage/BookmarkBloc/bookmarkEvent.dart';
import '../../../blocpage/BookmarkBloc/bookmarkLogic.dart';
import '../../../blocpage/BookmarkBloc/bookmarkState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobDetailPage2 extends StatefulWidget {
  final String jobToken;

  const JobDetailPage2({super.key, this.jobToken = ''});

  @override
  State<JobDetailPage2> createState() => _JobDetailPage2State();
}

class _JobDetailPage2State extends State<JobDetailPage2> {
  Map<String, dynamic>? jobDetail;
  bool isLoading = true;
  String? error;
  bool isLocationExpanded = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _fetchJobDetail();
  }

  Future<void> _fetchJobDetail() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      if (widget.jobToken.isEmpty) {
        throw Exception('Job token is missing');
      }
      final data = await JobDetailApi.fetchJobDetail(token: widget.jobToken);
      setState(() {
        jobDetail = {
          'title': data['title'] ?? 'Untitled',
          'company': data['company'] ?? 'Unknown Company',
          'location': data['location'] ?? 'N/A',
          'logoUrl': data['logoUrl'],
          'responsibilities':
          (data['responsibilities'] as List<dynamic>?)?.cast<String>() ??
              [],
          'terms': (data['terms'] as List<dynamic>?)?.cast<String>() ?? [],
          'requirements':
          (data['requirements'] as List<dynamic>?)?.cast<String>() ?? [],
          'niceToHave':
          (data['niceToHave'] as List<dynamic>?)?.cast<String>() ?? [],
          'aboutCompany':
          (data['aboutCompany'] as List<dynamic>?)?.cast<String>() ?? [],
          'tags': (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load job details: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.h),
          child: Padding(
            padding: EdgeInsets.all(8.w),
              child: AppBar(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                titleSpacing: 0,
                title: Text(
                  "Job Detail",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xFF003840),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1.w),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18.sp,
                          color: const Color(0xFF003840),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 1.w),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.share,
                            size: 18.sp,
                            color: const Color(0xFF003840),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              )

          ),
        ),
        body: isLoading
            ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: _buildShimmer(),
        )
            : error != null
            ? Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        )
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(jobDetail),
                _sectionTitle('Responsibilities of the Candidate:'),
                _bulletSection(jobDetail?['responsibilities'] ?? []),
                _sectionTitle('Requirements:'),
                _bulletSection(jobDetail?['requirements'] ?? []),
                _sectionTitle('Nice to Have:'),
                _bulletSection(jobDetail?['niceToHave'] ?? []),
                _sectionTitle('About Company'),
                _bulletSection(jobDetail?['aboutCompany'] ?? []),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.only(bottom: 8.h),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            color: const Color(0xFFEFF8F9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200.w,
                  child: ElevatedButton(
                    onPressed: () {
                      print(
                        "Apply button pressed with jobToken: ${widget.jobToken}",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005E6A),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Apply Now",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
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

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100.withOpacity(0.6),
      direction: ShimmerDirection.ltr,
      period: const Duration(seconds: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 10.h,
                      width: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          for (int i = 0; i < 4; i++)
            Container(
              height: 100.h,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic>? job) {
    final location = job?['location'] ?? 'Location';
    final company = job?['company'] ?? 'Company';
    final isLocationLong = location.length > 40 || location.contains('\n');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: const Color(0xFF005E6A)),
                  ),
                  child:
                  job?['logoUrl'] != null &&
                      (job?['logoUrl'] as String).isNotEmpty
                      ? Image.network(
                    job!['logoUrl'] as String,
                    height: 40.h,
                    width: 40.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(
                          'assets/google.png',
                          height: 40.h,
                          width: 40.w,
                        ),
                  )
                      : Image.asset(
                    'assets/google.png',
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              job?['title'] ?? 'Untitled',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF005E6A),
                              ),
                            ),
                          ),
                          BlocBuilder<BookmarkBloc, BookmarkState>(
                            builder: (context, state) {
                              final isBookmarked = state.bookmarkedJobs.any(
                                    (job) => job.jobToken == widget.jobToken,
                              );
                              return GestureDetector(
                                onTap: () {
                                  final job = JobModel(
                                    jobToken: widget.jobToken,
                                    jobTitle: jobDetail?['title'] ?? 'Untitled',
                                    company: jobDetail?['company'] ?? 'Company N/A',
                                    location: jobDetail?['location'] ?? 'Location N/A',
                                    salary: jobDetail?['salary'] ?? 'N/A',
                                    postTime: jobDetail?['postTime'] ?? 'N/A',
                                    expiry: jobDetail?['expiry'] ?? 'N/A',
                                    tags:
                                    (jobDetail?['tags'] as List?)
                                        ?.map((e) => e.toString())
                                        .toList() ??
                                        [],
                                    logoUrl: jobDetail?['logoUrl'],
                                  );

                                  if (isBookmarked) {
                                    context.read<BookmarkBloc>().add(
                                      RemoveBookmarkEvent(widget.jobToken),
                                    );
                                  } else {
                                    context.read<BookmarkBloc>().add(
                                      AddBookmarkEvent(job),
                                    );
                                  }
                                },
                                child: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_add_outlined,
                                  size: 25.w,
                                  color: const Color(0xFF005E6A),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        company,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[800],
                          height: 0.8,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLocationExpanded = !isLocationExpanded;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLocationExpanded
                                  ? location
                                  : _shortenText(location),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (isLocationLong)
                              Text(
                                isLocationExpanded ? 'Show less' : 'Show more ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF005E6A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(left: 0.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8.w,
                runSpacing: 6.h,
                children:
                (job?['tags'] as List<String>?)
                    ?.map((tag) => _Tag(label: tag))
                    .toList() ??
                    [
                      _Tag(label: "Full-time"),
                      _Tag(label: "In-office"),
                      _Tag(label: "14 Openings"),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shortenText(String text, {int maxChars = 40}) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars - 3)}...';
  }

  Widget _sectionTitle(String title) => Padding(
    padding: EdgeInsets.only(top: 12.h, bottom: 6.h),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF003840),
      ),
    ),
  );

  Widget _bulletSection(List<String> items) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFEBF6F7),
      borderRadius: BorderRadius.circular(10.r),
    ),
    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
    margin: EdgeInsets.only(bottom: 6.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\u2022 ",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: Text(e, style: TextStyle(fontSize: 13.sp)),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );

  Widget _Tag({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF005E6A),
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}