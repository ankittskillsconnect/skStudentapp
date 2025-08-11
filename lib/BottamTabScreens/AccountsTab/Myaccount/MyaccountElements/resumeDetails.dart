import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../Pages/Resume_Viewer.dart';

class ResumeSection extends StatefulWidget {
  const ResumeSection({super.key});

  @override
  State<ResumeSection> createState() => _ResumeSectionState();
}

class _ResumeSectionState extends State<ResumeSection> {
  File? _pdfFile;
  String? _resumeUrl;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAndSaveResumePdf();
  }

  Future<void> _fetchAndSaveResumePdf() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final connectSid = prefs.getString('connectSid') ?? '';

      final url = 'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/resume';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Cookie': 'authToken=$authToken; connect.sid=$connectSid'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final resumeUrl = jsonData['videoIntro']?[0]['resume']?.toString().trim();

        if (resumeUrl != null && resumeUrl.startsWith('https://')) {
          final pdfResponse = await http.get(Uri.parse(resumeUrl));

          if (pdfResponse.statusCode == 200) {
            final bytes = pdfResponse.bodyBytes;
            final dir = await getApplicationDocumentsDirectory();
            final file = File('${dir.path}/resume.pdf');
            await file.writeAsBytes(bytes);

            setState(() {
              _pdfFile = file;
              _resumeUrl = resumeUrl;
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _error = 'Failed to download resume: ${pdfResponse.statusCode}';
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _error = 'Invalid resume URL: $resumeUrl';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to fetch resume: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error fetching resume: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Resume",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 100.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005E6A),
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                onPressed: () {
                  _fetchAndSaveResumePdf();
                },
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () {
            if (_resumeUrl != null) {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResumeViewer(resumeUrl: _resumeUrl!),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigation failed')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resume URL not available')),
              );
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            height: 70.h,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 14.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBCD8DB)),
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description, size: 35.w, color: const Color(0xFF005E6A)),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Resume Preview",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Tap to view full resume",
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}