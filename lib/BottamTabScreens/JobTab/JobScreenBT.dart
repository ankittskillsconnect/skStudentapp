import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/AppBarJobScreen.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/JobdetailPage/JobdetailpageBT.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import '../../Utilities/JobListApi.dart';
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
        jobs = fetchedJobs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load jobs: $e';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load jobs: $e')),
        );
      });
    }
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
            child: Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : errorMessage != null
                      ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
                      : jobs.isEmpty
                      ? const Center(child: Text('No jobs found'))
                      : ListView.builder(
                    shrinkWrap: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const JobDetailPage2(),
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
                          tags: List<String>.from(job['tags']),
                          logoUrl: job['logoUrl'],
                        ),
                      );
                    },
                  ),
                ),
              ],
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