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
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _futureJobs = AppliedJobsApi.fetchAppliedJobs();
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Applied Jobs",
          style: TextStyle(
            color: const Color(0xFF003840),
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: const Color(0xFF003840), size: 20.w),
      ),
      body: FutureBuilder<List<AppliedJobModel>>(
        future: _futureJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: _buildShimmerCard());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              ),
            );
          }
          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return Center(
              child: Text(
                "No jobs applied yet",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refreshJobs,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: jobs.length,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return GestureDetector(
                  onTap: () {
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      padding: EdgeInsets.all(7.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
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
                        width: 35.w,
                        height: 35.h,
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
                      SizedBox(width: 7.w),
                      Container(
                        height: 14.h,
                        width: 45.w,
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
                        width: 55.w,
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
                    width: 55.w,
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