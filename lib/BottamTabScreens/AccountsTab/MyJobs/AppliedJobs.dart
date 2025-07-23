import 'package:flutter/material.dart';
import '../../../Model/Applied_Jobs_Model.dart';
import '../../../Utilities/AppliedJobs_Api.dart';
import '../../JobTab/JobdetailPage/JobdetailpageBT.dart';
import 'AppliedJobCard.dart';
import 'package:shimmer/shimmer.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Applied Jobs",
          style: TextStyle(
            color: Color(0xFF003840),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF003840)),
      ),
      body: FutureBuilder<List<AppliedJobModel>>(
        future: _futureJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: _buildShimmerCard());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final jobs = snapshot.data ?? [];
          if (jobs.isEmpty) {
            return const Center(
              child: Text(
                "No jobs applied yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshJobs,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: jobs.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return GestureDetector(
                  onTap: (){
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
}

Widget _buildShimmerCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18,
                            width: 120,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 14,
                            width: 180,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 16,
                      width: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(3, (index) {
                    return Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14,
                  width: 80,
                  color: Colors.white,
                ),
                Container(
                  height: 14,
                  width: 60,
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