import 'package:flutter/material.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/AppBarJobScreen.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/JobdetailPage/JobdetailpageBT.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import 'JobCardBT.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Jobscreenbt extends StatefulWidget {
  const Jobscreenbt({super.key});

  @override
  State<Jobscreenbt> createState() => _JobScreenbtState();
}

class _JobScreenbtState extends State<Jobscreenbt> {
  final List<Map<String, dynamic>> jobs = [
    {
      'title': 'UI/UX Designer',
      'company': 'Google',
      'location': 'Bangalore, Karnataka, India',
      'salary': '₹12–15 LPA',
      'postTime': '30 min ago',
      'expiry': '7 days left',
      'tags': ['Hybrid (3 days WFH)', 'Full time (On-site)'],
    },
    {
      'title': 'Artificial Intelligence Engineer',
      'company': 'Google',
      'location': 'Bangalore, Karnataka, India',
      'salary': '₹12–15 LPA',
      'postTime': '30 min ago',
      'expiry': '7 days left',
      'tags': ['Hybrid (3 days WFH)', 'Full time (On-site)'],
    },
    {
      'title': 'Graphic Designer',
      'company': 'Google',
      'location': 'Bangalore, Karnataka, India',
      'salary': '₹12–15 LPA',
      'postTime': '30 min ago',
      'expiry': '7 days left',
      'tags': ['Hybrid (3 days WFH)', 'Full time (On-site)'],
    },
    {
      'title': 'Fashion Designer',
      'company': 'Google',
      'location': 'Bangalore, Karnataka, India',
      'salary': '₹12–15 LPA',
      'postTime': '30 min ago',
      'expiry': '7 days left',
      'tags': ['Hybrid (3 days WFH)', 'Full time (On-site)'],
    },
    {
      'title': 'Fashion Designer',
      'company': 'Google',
      'location': 'Bangalore, Karnataka, India',
      'salary': '₹12–15 LPA',
      'postTime': '30 min ago',
      'expiry': '7 days left',
      'tags': ['Hybrid (3 days WFH)', 'Full time (On-site)'],
    },
    {
      'title': 'Fashion Designer',
      'company': 'Google',
      'location': 'Bangalore, Karnataka, India',
      'salary': '₹12–15 LPA',
      'postTime': '30 min ago',
      'expiry': '7 days left',
      'tags': ['Hybrid (3 days WFH)', 'Full time (On-site)'],
    },
    {
      'title': 'Fashion Designer',
      'company': 'Google',
      'location': 'Bangalore, Karnataka, India',
      'salary': '₹12–15 LPA',
      'postTime': '30 min ago',
      'expiry': '7 days left',
      'tags': ['Hybrid (3 days WFH)', 'Full time (On-site)'],
    },
  ];

  int _selectedIndex = 0;

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
            MaterialPageRoute(builder: (_) => JobDetailPage2()),
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
                  child: ListView.builder(
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
                              builder: (_) => JobDetailPage2(),
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
                        ),
                      );
                    },
                  ),
                ),

                //uncomment for only the top most card to be tappable
                // Expanded(
                //   child: ListView.builder(
                //     shrinkWrap: false,
                //     physics: const AlwaysScrollableScrollPhysics(),
                //     itemCount: jobs.length,
                //     itemBuilder: (context, index){
                //       final job = jobs[index];
                //       final isTappable = job["title"] == 'UI/UX Designer';
                //       final JobCard = JobCardBT(
                //         jobTitle: job['title'],
                //         company: job['company'],
                //         location: job['location'],
                //         salary: job['salary'],
                //         postTime: job['postTime'],
                //         expiry: job['expiry'],
                //         tags: List<String>.from(job['tags']),
                //       );
                //       return isTappable
                //           ? InkWell(onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (_) => JobDetailPage2(),
                //           ),
                //         );
                //       }, child: JobCard
                //       )
                //           : JobCard;
                //     },
                //   ),
                // ),

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
