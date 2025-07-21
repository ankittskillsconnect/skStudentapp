import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import '../../Model/InterviewScreenModel.dart';
import '../../Utilities/InterviewScreenApi.dart';
import 'interviewCard.dart';
import 'package:shimmer/shimmer.dart';


class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  int _selectedIndex = 0;
  late Future<List<InterviewModel>> _interviewFuture;
  bool isLoading = false;

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
      _interviewFuture = InterviewApi.fetchInterviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.tealAccent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        color: const Color(0xFFEBF6F7),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(75),
              child: SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const TextField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search, color: Colors.black),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            _iconCircleButton(Icons.filter_list),
                            _iconCircleButton(Icons.notifications_outlined),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: _refreshInterviewList,
              child: SafeArea(
                child: FutureBuilder<List<InterviewModel>>(
                  future: _interviewFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        itemCount: 5,
                        itemBuilder: (context, index) => _buildShimmerCard(),
                      );
                  } else if (snapshot.hasError) {
                      return const Center(child: Text(" Failed to load interviews"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No interviews Scheduled yet"));
                    }
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Column(
                        children: data.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
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
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),

    );
  }

  Widget _iconCircleButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          color: Colors.transparent,
        ),
        child: Icon(icon, size: 22, color: Colors.black),
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