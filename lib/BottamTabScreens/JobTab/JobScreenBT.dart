import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/AppBarJobScreen.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/JobdetailPage/JobdetailpageBT.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import '../../Pages/noInternetPage_jobs.dart';
import '../../ProfileLogic/ProfileEvent.dart';
import '../../ProfileLogic/ProfileLogic.dart';
import '../../Utilities/JobList_Api.dart';
import 'JobCardBT.dart';

class Jobscreenbt extends StatefulWidget {
  const Jobscreenbt({super.key});

  @override
  State<Jobscreenbt> createState() => _JobScreenbtState();
}

class _JobScreenbtState extends State<Jobscreenbt> {
  List<Map<String, dynamic>> jobs = [];
  bool isLoading = true;
  String? errorMessage;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final fetchedJobs = await JobApi.fetchJobs();
      setState(() {
        jobs = fetchedJobs.map((job) {
          final location = (job['location'] as String?)?.isNotEmpty ?? false
              ? job['location']
              : (job['job_location_detail'] as List<dynamic>?)?.isNotEmpty ??
                      false
                  ? (job['job_location_detail'] as List<dynamic>)
                      .map((loc) => loc['city_name'] as String? ?? 'Unknown')
                      .join(' • ')
                  : 'N/A';

          return {
            'title': job['title'] ?? 'Untitled',
            'company': job['company'] ?? 'Unknown Company',
            'location': location,
            'salary': job['salary'] ?? 'N/A',
            'postTime': job['postTime'] ?? 'N/A',
            'expiry': job['expiry'] ?? 'N/A',
            'tags': List<String>.from(job['tags'] ?? []),
            'logoUrl': job['logoUrl'],
            'jobToken': job['jobToken'],
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load jobs: $e';
      });
    }
  }

  Future<void> _onRefresh() async {
    context.read<ProfileBloc>().add(_fetchJobs() as ProfileEvent);
    await Future.delayed(const Duration(seconds: 1));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        if (state is NavigateTOJobDetailBT) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JobDetailPage2()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const Appbarjobscreen(),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Expanded(
                    child: isLoading
                        ? ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) =>
                                _buildShimmerCard(),
                          )
                        : errorMessage != null
                            ? NoInternetPage(
                                onRetry: () async {
                                  setState(() => isLoading = true);
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  await _fetchJobs();
                                  setState(() => isLoading = false);
                                },
                              )
                            : jobs.isEmpty
                                ? const Center(child: Text('No jobs found'))
                                : ListView.builder(
                                    itemCount: jobs.length,
                                    itemBuilder: (context, index) {
                                      final job = jobs[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => JobDetailPage2(
                                                  jobToken: job['jobToken']),
                                            ),
                                          );
                                        },
                                        child: JobCardBT(
                                          jobTitle: job['title'],
                                          company: job['company'],
                                          location: job['location'],
                                          salary: job['salary'],
                                          postTime: job['postTime'],
                                          expiry: job['expiry'],
                                          tags: job['tags'],
                                          logoUrl: job['logoUrl'],
                                        ),
                                      );
                                    },
                                  ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

Widget _buildShimmerCard() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
    padding: EdgeInsets.all(6.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.r),
    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16.h,
                            width: 100.w,
                            color: Colors.white,
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 12.h,
                            width: 160.w,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      height: 14.h,
                      width: 44.w,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: List.generate(3, (index) {
                    return Container(
                      height: 18.h,
                      width: 52.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
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
                  width: 54.w,
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
