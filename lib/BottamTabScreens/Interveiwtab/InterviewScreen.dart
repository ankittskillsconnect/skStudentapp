import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import '../../Model/InterviewScreenModel.dart';
import '../../Utilities/InterviewScreenApi.dart';
import 'interviewCard.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  int _selectedIndex = 0;
  late Future<List<InterviewModel>> _interviewFuture;

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
        child: RefreshIndicator(
          onRefresh: _refreshInterviewList,
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
            body: SafeArea(
              child: FutureBuilder<List<InterviewModel>>(
                future: _interviewFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
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
