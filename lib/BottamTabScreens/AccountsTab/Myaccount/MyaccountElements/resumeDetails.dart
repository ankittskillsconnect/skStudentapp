import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
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
    final size = MediaQuery.of(context).size;
    final double widthScale = size.width / 360;
    final double fontScale = widthScale.clamp(0.98, 1.02);
    final double sizeScale = widthScale.clamp(0.98, 1.02);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Resume",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005E6A),
                padding: EdgeInsets.symmetric(horizontal: 16 * sizeScale),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30 * sizeScale),
                ),
              ),
              onPressed: () {
                _fetchAndSaveResumePdf();
              },
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white, fontSize: 14 * fontScale),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
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
            height: 80,
            padding: EdgeInsets.symmetric(vertical: 10 * sizeScale, horizontal: 16 * sizeScale),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBCD8DB)),
              borderRadius: BorderRadius.circular(12 * sizeScale),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.description, size: 40, color: Color(0xFF005E6A)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Resume Preview",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Tap to view full resume",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
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