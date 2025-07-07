import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sk_loginscreen1/BottamTabScreens/JobTab/AppBarJobScreen.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'interviewCard.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> cardData = [
    {
      "title": "Group Discussion | Social Media Discussion",
      "companyName": "Google",
      "status" : "Live",
      "time": "12:00 PM to 01:00 PM",
      "date": "15th March, 2025",
      "hrName" : "Hr. Namita",
      "platform": "online"
      // "invited": 15,
      // "images": [
      //   "assets/profile1.png",
      //   "assets/profile2.png",
      //   "assets/profile3.png",
      // ]
    },
    {
      "title": "Mock Interview | Infosys HR",
      "companyName": "Accenture",
      "status" : "Live",
      "time": "3:00 PM to 4:00 PM",
      "date": "18th March, 2025",
      "hrName" : "Hr. Namita",
      "platform": "online"
      // "invited": 12,
      // "images": [
      //   "assets/profile1.png",
      //   "assets/profile2.png",
      // ]
    },
    {
      "title": "Coding Test | Web Dev Role",
      "companyName": "JP Morgan",
      "status" : "Live",
      "time": "9:00 AM to 10:00 AM",
      "date": "20th March, 2025",
      "hrName" : "Hr. Namita",
      "platform": "online"
      // "invited": 20,
      // "images": [
      //   "assets/profile1.png",
      //   "assets/profile2.png",
      //   "assets/profile1.png",
      // ]
    },
    {
      "title": "Group Discussion | Social Media Di...",
      "companyName": "Amazon",
      "status" : "Live",
      "time": "12:00 PM to 01:00 PM",
      "date": "15th March, 2025",
      "hrName" : "Hr. Namita",
      "platform": "online"
      // "invited": 15,
      // "images": [
      //   "assets/profile1.png",
      //   "assets/profile2.png",
      //   "assets/profile3.png",
      // ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.tealAccent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
        color: const  Color(0xFFEBF6F7),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const Appbarjobscreen(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: cardData.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DiscussionCard(
                      title: item['title'],
                      companyName: item['companyName'],
                      status: item['status'],
                      time: item['time'],
                      date: item['date'],
                      hrName: item["hrName"],
                      platform: item['platform'],
                      // invitedCount: item['invited'],
                      // profileImageUrls: List<String>.from(item['images']),
                      onJoinTap: () {
                        print("Join tapped for: ${item['title']}");// debug
                      },
                    ),
                  );
                }).toList(),
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
  // @override
  // Size get preferredSize => const Size.fromHeight(90); // Controlled height
}
