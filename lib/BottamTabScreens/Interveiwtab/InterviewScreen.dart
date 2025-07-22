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
  DateTime? _startDate;
  DateTime? _endDate;

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
      _startDate = null;
      _endDate = null;
      _interviewFuture = InterviewApi.fetchInterviews();
    });
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 1)),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF005E6A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
              surface: Color(0xFFEBF6F7),
            ),
            dialogBackgroundColor: Color(0xFFEBF6F7),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFEBF6F7),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      print("📅 Selected range: $_startDate - $_endDate");
    }
  }


  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).size.width / 375;
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
              preferredSize: Size.fromHeight(75 * scaleFactor),
              child: SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      20 * scaleFactor,
                      20 * scaleFactor,
                      20 * scaleFactor,
                      0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 6 * scaleFactor,
                            ),
                            height: 35 * scaleFactor,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                24 * scaleFactor,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: _pickDateRange,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 11 * scaleFactor,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.black,
                                      size: 20 * scaleFactor,
                                    ),
                                    SizedBox(width: 10 * scaleFactor),
                                    Flexible(
                                      child: Text(
                                        _startDate != null && _endDate != null
                                            ? "${_startDate!.toLocal().toString().split(' ')[0]} → ${_endDate!.toLocal().toString().split(' ')[0]}"
                                            : "Select date range",
                                        style: TextStyle(
                                          fontSize: 10 * scaleFactor,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                      size: 20 * scaleFactor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4 * scaleFactor),
                        if (_startDate != null && _endDate != null)
                          _iconCircleButton(
                            Icons.close,
                            scaleFactor,
                            onTap: () {
                              setState(() {
                                _startDate = null;
                                _endDate = null;
                                _interviewFuture =
                                    InterviewApi.fetchInterviews();
                              });
                            },
                          ),
                        _iconCircleButton(
                          Icons.notifications_outlined,
                          scaleFactor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: FutureBuilder<List<InterviewModel>>(
                future: _interviewFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: 10 * scaleFactor,
                        horizontal: 16 * scaleFactor,
                      ),
                      itemCount: 5,
                      itemBuilder: (context, index) =>
                          _buildShimmerCard(scaleFactor),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Failed to load interviews"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No interviews Scheduled yet"),
                    );
                  }
                  final data = snapshot.data!;
                  final filteredData = (_startDate != null && _endDate != null)
                      ? data.where((item) {
                          final interviewDate = DateTime.parse(item.date);
                          return interviewDate.isAfter(
                                _startDate!.subtract(const Duration(days: 1)),
                              ) &&
                              interviewDate.isBefore(
                                _endDate!.add(const Duration(days: 1)),
                              );
                        }).toList()
                      : data;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * scaleFactor,
                      vertical: 10 * scaleFactor,
                    ),
                    child: Column(
                      children: filteredData.isEmpty
                          ? [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40 * scaleFactor,
                                ),
                                child: const Center(
                                  child: Text(
                                    'No interviews found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          : filteredData.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: 10 * scaleFactor,
                                ),
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

  Widget _iconCircleButton(
    IconData icon,
    double scaleFactor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6 * scaleFactor),
        padding: EdgeInsets.all(10 * scaleFactor),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          color: Colors.transparent,
        ),
        child: Icon(icon, size: 22 * scaleFactor, color: Colors.black),
      ),
    );
  }
}

Widget _buildShimmerCard(double scaleFactor) {
  return Container(
    margin: EdgeInsets.symmetric(
      horizontal: 6 * scaleFactor,
      vertical: 10 * scaleFactor,
    ),
    padding: EdgeInsets.all(8 * scaleFactor),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12 * scaleFactor),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12 * scaleFactor),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40 * scaleFactor,
                      height: 40 * scaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8 * scaleFactor),
                      ),
                    ),
                    SizedBox(width: 12 * scaleFactor),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 18 * scaleFactor,
                            width: 120 * scaleFactor,
                            color: Colors.white,
                          ),
                          SizedBox(height: 6 * scaleFactor),
                          Container(
                            height: 14 * scaleFactor,
                            width: 180 * scaleFactor,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8 * scaleFactor),
                    Container(
                      height: 16 * scaleFactor,
                      width: 50 * scaleFactor,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 12 * scaleFactor),
                Wrap(
                  spacing: 8 * scaleFactor,
                  runSpacing: 8 * scaleFactor,
                  children: List.generate(3, (index) {
                    return Container(
                      height: 20 * scaleFactor,
                      width: 60 * scaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20 * scaleFactor),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(height: 10 * scaleFactor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * scaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 14 * scaleFactor,
                  width: 80 * scaleFactor,
                  color: Colors.white,
                ),
                Container(
                  height: 14 * scaleFactor,
                  width: 60 * scaleFactor,
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
