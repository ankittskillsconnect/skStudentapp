import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/AppBarJobScreen.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/JobdetailPage/JobdetailpageBT.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import '../../Pages/noInternetPage_jobs.dart';
// import '../../ProfileLogic/ProfileEvent.dart';
// import '../../ProfileLogic/ProfileLogic.dart';
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
              : (job['job_location_detail'] as List<dynamic>?)?.isNotEmpty ?? false
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
        errorMessage = 'no_internet';
      });
    }
  }

  Future<void> _onRefresh() async {
    await _fetchJobs();
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
        appBar: Appbarjobscreen(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isLoading
                ? ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => _buildShimmerCard(),
            )
                : errorMessage == 'no_internet'
                ? NoInternetPage(
              onRetry: _fetchJobs,
            )
                : jobs.isEmpty
                ? const Center(child: Text('No jobs found'))
                : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index){
                  final job = jobs[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetailPage2(
                              jobToken: job['jobToken']
                          ),
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
