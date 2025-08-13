import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../Model/Resume_fetch_Model.dart';
import '../../../../Pages/Resume_Viewer.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<File?> _pickResumeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
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

        if (jsonData['videoIntro'] != null &&
            jsonData['videoIntro'] is List &&
            (jsonData['videoIntro'] as List).isNotEmpty) {

          final firstEntry = (jsonData['videoIntro'] as List)[0] as Map<String, dynamic>;

          final resumeModel = ResumeModel(
            resume: firstEntry['resume']?.toString() ?? '',
            resumeName: firstEntry['resume_name']?.toString() ?? '',
          );

          final resumeUrl = resumeModel.resume.trim();

          if (resumeUrl.isNotEmpty && resumeUrl.startsWith('http')) {
            final pdfResponse = await http.get(Uri.parse(resumeUrl));

            if (pdfResponse.statusCode == 200) {
              final bytes = pdfResponse.bodyBytes;
              final dir = await getApplicationDocumentsDirectory();

              final safeFileName = 'resume.pdf';

              final file = File('${dir.path}/$safeFileName');
              await file.writeAsBytes(bytes);

              setState(() {
                _pdfFile = file;
                _resumeUrl = resumeUrl;
                _isLoading = false;
                _error = null;
              });
            } else {
              setState(() {
                _isLoading = false;
                _error = 'Failed to download resume: ${pdfResponse.statusCode}';
                _resumeUrl = null;
              });
            }
          } else {
            setState(() {
              _isLoading = false;
              _error = 'Invalid resume URL found';
              _resumeUrl = null;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _error = 'No resume info found in response';
            _resumeUrl = null;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Failed to fetch resume info: ${response.statusCode}';
          _resumeUrl = null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error fetching resume: $e';
        _resumeUrl = null;
      });
    }
  }

  Future<String?> uploadFileAndGetUrl(File file) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final connectSid = prefs.getString('connectSid') ?? '';

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-resume'),
      );

      request.headers.addAll({
        'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
      });

      request.files.add(await http.MultipartFile.fromPath('resume', file.path));

      final response = await request.send();

      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResp = json.decode(respStr);

        final uploadedUrl = jsonResp['resume'] as String?;
        final uploadedName = jsonResp['resume_name'] as String?;

        print('Uploaded URL: $uploadedUrl');
        print('Uploaded Name: $uploadedName');

        return uploadedUrl;
      } else {
        print(
            'Failed to upload file: ${response.statusCode} ${response.reasonPhrase}');
        return null;
      }
    } catch (e, stacktrace) {
      print('Error uploading file: $e');
      print('Stacktrace: $stacktrace');
      return null;
    }
  }

  Future<void> _updateResumeInfo(String resumeUrl, String resumeName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final connectSid = prefs.getString('connectSid') ?? '';

      final body = json.encode({
        'resume': resumeUrl,
        'resume_name': resumeName,
      });

      final url =
          'https://api.skillsconnect.in/dcxqyqzqpdydfk/api/profile/student/update-resume';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resume updated successfully")),
        );
        _fetchAndSaveResumePdf();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to update resume: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating resume: $e")),
      );
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
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                  File? file = await _pickResumeFile();
                  if (file == null) return;
                  if (!file.path.toLowerCase().endsWith('.pdf')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a PDF file")),
                    );
                    return;
                  }
                  setState(() => _isLoading = true);
                  try {
                    print('Uploading file: ${file.path}');
                    final uploadedUrl = await uploadFileAndGetUrl(file);

                    if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
                      final fileName = file.path.split('/').last;
                      print('Uploaded URL: $uploadedUrl');
                      print('File name: $fileName');
                      await _updateResumeInfo(uploadedUrl, fileName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to upload file")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  } finally {
                    setState(() => _isLoading = false);
                  }
                },
                child: Text(
                  _resumeUrl == null ? "Upload" : "Update",
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (_resumeUrl != null)
          GestureDetector(
            onTap: () {
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
                  Icon(Icons.description,
                      size: 35.w, color: const Color(0xFF005E6A)),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Resume Preview",
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
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
          )
        else
          Container(
            width: double.infinity,
            height: 70.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBCD8DB)),
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            child: Text(
              "Please upload a resume",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
