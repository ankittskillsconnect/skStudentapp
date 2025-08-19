import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Model/Applied_Jobs_Model.dart';
import '../../../Utilities/AppliedJobs_Api.dart';
import '../../JobTab/JobdetailPage/JobdetailpageBT.dart';
import 'AppliedJobCard.dart';

class AppliedJobsPage extends StatefulWidget {
  const AppliedJobsPage({super.key});

  @override
  State<AppliedJobsPage> createState() => _AppliedJobsPageState();
}

class _AppliedJobsPageState extends State<AppliedJobsPage> {
  late Future<List<AppliedJobModel>> _futureJobs;

  @override
  void initState() {
    super.initState();
    _futureJobs = AppliedJobsApi.fetchAppliedJobs();
    print('🔍 [AppliedJobsPage] Initializing with fetchAppliedJobs');
  }

  Future<void> _refreshJobs() async {
    print('🔍 [AppliedJobsPage] Refreshing job list');
    setState(() {
      _futureJobs = AppliedJobsApi.fetchAppliedJobs();
    });
    print('✅ [AppliedJobsPage] Refresh triggered');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Applied Jobs",
          style: TextStyle(
            color: const Color(0xFF003840),
            fontWeight: FontWeight.bold,
            fontSize: 16.7.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color(0xFF003840), size: 18.6.w),
      ),
      body: FutureBuilder<List<AppliedJobModel>>(
        future: _futureJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('🔍 [AppliedJobsPage] Loading jobs, showing shimmer');
            return Center(child: _buildShimmerCard());
          }
          if (snapshot.hasError) {
            print('❌ [AppliedJobsPage] Error fetching jobs: ${snapshot.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error fetching jobs', style: TextStyle(fontSize: 13.sp)),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 13.sp),
              ),
            );
          }
          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            print('⚠️ [AppliedJobsPage] No jobs applied');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No jobs applied yet', style: TextStyle(fontSize: 13.sp)),
                backgroundColor: Colors.grey,
                duration: const Duration(seconds: 3),
              ),
            );
            return Center(
              child: Text(
                "No jobs applied yet",
                style: TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            );
          }
          print('✅ [AppliedJobsPage] Loaded ${jobs.length} jobs');
          return RefreshIndicator(
            onRefresh: _refreshJobs,
            color: const Color(0xFF003840),
            backgroundColor: Colors.white,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: jobs.length,
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.5.h),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return GestureDetector(
                  onTap: () {
                    print('🔍 [AppliedJobsPage] Navigating to JobDetailPage2 for job: ${job.title}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobDetailPage2(jobToken: job.token),
                      ),
                    );
                  },
                  child: AppliedJobCardBT(
                    jobTitle: job.title,
                    company: job.companyName,
                    location: job.location,
                    salary: job.salary,
                    postTime: job.postTime,
                    expiry: job.expiry,
                    tags: job.tags,
                    logoUrl: job.companyLogo,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard() {
    print('🔍 [AppliedJobsPage] Rendering shimmer card');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.7.w, vertical: 7.4.h),
      padding: EdgeInsets.all(6.5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.5.r),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(9.3.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9.3.r),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32.6.w,
                        height: 32.6.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.5.r),
                        ),
                      ),
                      SizedBox(width: 9.3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14.9.h,
                              width: 93.w,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4.7.h),
                            Container(
                              height: 11.2.h,
                              width: 148.8.w,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.5.w),
                      Container(
                        height: 13.h,
                        width: 41.9.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 9.3.h),
                  Wrap(
                    spacing: 6.5.w,
                    runSpacing: 6.5.h,
                    children: List.generate(3, (index) {
                      return Container(
                        height: 16.7.h,
                        width: 51.2.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.7.r),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 7.4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 11.2.h,
                    width: 65.1.w,
                    color: Colors.white,
                  ),
                  Container(
                    height: 11.2.h,
                    width: 51.2.w,
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