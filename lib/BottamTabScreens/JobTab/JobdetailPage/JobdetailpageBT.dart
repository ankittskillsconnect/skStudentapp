import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Model/Job_Model.dart';
import '../../../Utilities/JobDetail_Api.dart';
import '../../../blocpage/BookmarkBloc/bookmarkEvent.dart';
import '../../../blocpage/BookmarkBloc/bookmarkLogic.dart';
import '../../../blocpage/BookmarkBloc/bookmarkState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobDetailPage2 extends StatefulWidget {
  final String jobToken;

  const JobDetailPage2({super.key, this.jobToken = ''});

  @override
  State<JobDetailPage2> createState() => _JobDetailPage2State();
}

class _JobDetailPage2State extends State<JobDetailPage2> {
  Map<String, dynamic>? jobDetail;
  bool isLoading = true;
  String? error;
  bool isLocationExpanded = false;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _fetchJobDetail();
  }

  Future<void> _fetchJobDetail() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      if (widget.jobToken.isEmpty) {
        throw Exception('Job token is missing');
      }
      final data = await JobDetailApi.fetchJobDetail(token: widget.jobToken);
      setState(() {
        jobDetail = {
          'title': data['title'] ?? 'Untitled',
          'company': data['company'] ?? 'Unknown Company',
          'location': data['location'] ?? 'N/A',
          'logoUrl': data['logoUrl'],
          'responsibilities':
              (data['responsibilities'] as List<dynamic>?)?.cast<String>() ??
              [],
          'terms': (data['terms'] as List<dynamic>?)?.cast<String>() ?? [],
          'requirements':
              (data['requirements'] as List<dynamic>?)?.cast<String>() ?? [],
          'niceToHave':
              (data['niceToHave'] as List<dynamic>?)?.cast<String>() ?? [],
          'aboutCompany':
              (data['aboutCompany'] as List<dynamic>?)?.cast<String>() ?? [],
          'tags': (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load job details: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double heightScale = size.height / 640;
    final double fontScale = (widthScale * 0.8).clamp(0.8, 1.2);
    final double sizeScale = (widthScale * 0.9).clamp(0.9, 1.3);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40 * heightScale),
          child: Padding(
            padding: EdgeInsets.all(1 * sizeScale),
            child: AppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              titleSpacing: 0,
              title: Text(
                "Job Detail",
                style: TextStyle(
                  fontSize: 25 * fontScale,
                  color: const Color(0xFF003840),
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Padding(
                padding: EdgeInsets.only(left: 12 * sizeScale),
                child: Center(
                  child: Container(
                    width: 46 * sizeScale,
                    height: 46 * sizeScale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(12),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 22 * sizeScale,
                        color: const Color(0xFF003840),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 12 * sizeScale),
                  child: Center(
                    child: Container(
                      width: 46 * sizeScale,
                      height: 46 * sizeScale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.share,
                          size: 22 * sizeScale,
                          color: const Color(0xFF003840),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16 * sizeScale,
                  vertical: 16 * sizeScale,
                ),
                child: _buildShimmer(sizeScale, widthScale),
              )
            : error != null
            ? Center(
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * sizeScale,
                    vertical: 5 * sizeScale,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(jobDetail, widthScale, fontScale),
                      _sectionTitle('Responsibilities of the Candidate:'),
                      _bulletSection(
                        jobDetail?['responsibilities'] ?? [],
                        sizeScale,
                      ),
                      _sectionTitle('Requirements:'),
                      _bulletSection(
                        jobDetail?['requirements'] ?? [],
                        sizeScale,
                      ),
                      _sectionTitle('Nice to Have:'),
                      _bulletSection(jobDetail?['niceToHave'] ?? [], sizeScale),
                      _sectionTitle('About Company'),
                      _bulletSection(
                        jobDetail?['aboutCompany'] ?? [],
                        sizeScale,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12 * sizeScale,
            horizontal: 140 * sizeScale,
          ),
          color: const Color(0xFFEFF8F9),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    print(
                      "Apply button pressed with jobToken: ${widget.jobToken}",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005E6A),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16 * sizeScale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30 * sizeScale),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Apply Now",
                    style: TextStyle(
                      fontSize: 16 * fontScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(double scale, double widthScale) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100.withOpacity(0.6),
      direction: ShimmerDirection.ltr,
      period: const Duration(seconds: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48 * widthScale,
                height: 48 * widthScale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(width: 10 * widthScale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14 * scale,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(height: 8 * scale),
                    Container(
                      height: 12 * scale,
                      width: 100 * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20 * scale),
          for (int i = 0; i < 4; i++)
            Container(
              height: 130 * scale,
              margin: EdgeInsets.symmetric(vertical: 6 * scale),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    Map<String, dynamic>? job,
    double widthScale,
    double fontScale,
  ) {
    final location = job?['location'] ?? 'Location';
    final company = job?['company'] ?? 'Company';
    final isLocationLong = location.length > 40 || location.contains('\n');
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5 * widthScale,
        vertical: 10 * widthScale,
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF005E6A)),
                  ),
                  child:
                      job?['logoUrl'] != null &&
                          (job?['logoUrl'] as String).isNotEmpty
                      ? Image.network(
                          job!['logoUrl'] as String,
                          height: 44 * widthScale,
                          width: 44 * widthScale,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                'assets/google.png',
                                height: 44 * widthScale,
                                width: 44 * widthScale,
                              ),
                        )
                      : Image.asset(
                          'assets/google.png',
                          height: 44 * widthScale,
                          width: 44 * widthScale,
                        ),
                ),
                SizedBox(width: 12 * widthScale),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              job?['title'] ?? 'Software Engineer',
                              style: TextStyle(
                                fontSize: 21 * fontScale,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF005E6A),
                              ),
                            ),
                          ),
                          BlocBuilder<BookmarkBloc, BookmarkState>(
                            builder: (context, state) {
                              final isBookmarked = state.bookmarkedJobs.any(
                                (job) => job.jobToken == widget.jobToken,
                              );
                              return GestureDetector(
                                onTap: () {
                                  final job = JobModel(
                                    jobToken: widget.jobToken,
                                    jobTitle: jobDetail?['title'] ?? '',
                                    company: jobDetail?['company'] ?? '',
                                    location: jobDetail?['location'] ?? '',
                                    salary: jobDetail?['salary'] ?? '',
                                    postTime: jobDetail?['postTime'] ?? '',
                                    expiry: jobDetail?['expiry'] ?? '',
                                    tags:
                                        (jobDetail?['tags'] as List?)
                                            ?.map((e) => e.toString())
                                            .toList() ??
                                        [],
                                    logoUrl: jobDetail?['logoUrl'],
                                  );

                                  if (isBookmarked) {
                                    context.read<BookmarkBloc>().add(
                                      RemoveBookmarkEvent(widget.jobToken),
                                    );
                                  } else {
                                    context.read<BookmarkBloc>().add(
                                      AddBookmarkEvent(job),
                                    );
                                  }
                                },
                                child: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_add_outlined,
                                  size: 24 * widthScale,
                                  color: const Color(0xFF005E6A),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(
                        company,
                        style: TextStyle(
                          fontSize: 15 * fontScale,
                          color: Colors.grey[800],
                          height: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLocationExpanded = !isLocationExpanded;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLocationExpanded
                                  ? location
                                  : _shortenText(location),
                              style: TextStyle(
                                fontSize: 15 * fontScale,
                                color: Colors.grey[800],
                              ),
                            ),
                            if (isLocationLong)
                              Text(
                                isLocationExpanded ? 'Show less' : 'Show more ',
                                style: TextStyle(
                                  fontSize: 15 * fontScale,
                                  color: const Color(0xFF005E6A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14 * widthScale),
          Padding(
            padding: EdgeInsets.only(left: 0 * widthScale),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 10 * widthScale,
                runSpacing: 8 * widthScale,
                children:
                    (job?['tags'] as List<String>?)
                        ?.map((tag) => _Tag(label: tag))
                        .toList() ??
                    [
                      _Tag(label: "Full-time"),
                      _Tag(label: "In-office"),
                      _Tag(label: "14 Openings"),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shortenText(String text, {int maxChars = 40}) {
    if (text.length <= maxChars) return text;
    return '${text.substring(0, maxChars - 3)}...';
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF003840),
      ),
    ),
  );

  Widget _bulletSection(List<String> items, double scale) => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFEBF6F7),
      borderRadius: BorderRadius.circular(12 * scale),
    ),
    padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 12 * scale),
    margin: EdgeInsets.only(bottom: 8 * scale),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4 * scale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\u2022 ",
                style: TextStyle(
                  fontSize: 15 * scale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: Text(e, style: TextStyle(fontSize: 14 * scale)),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );

  Widget _Tag({required String label}) {
    final size = MediaQuery.of(context).size;
    final widthScale = size.width / 360;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12 * widthScale,
        vertical: 6 * widthScale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8F9),
        borderRadius: BorderRadius.circular(20 * widthScale),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF005E6A),
          fontSize: 14 * widthScale,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
