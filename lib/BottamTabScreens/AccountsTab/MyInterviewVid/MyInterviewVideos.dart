import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../Model/My_Interview_Videos_Model.dart';
import '../../../Utilities/MyAccount_Get_Post/My_Interview_Videos_Api.dart';
import 'VideopreviewScreen.dart';

class MyInterviewVideos extends StatefulWidget {
  const MyInterviewVideos({super.key});

  @override
  _MyInterviewVideosState createState() => _MyInterviewVideosState();
}

class _MyInterviewVideosState extends State<MyInterviewVideos> {
  VideoIntroModel? _videoIntroModel;
  final Map<String, String> _questionVideoPaths = {};
  bool _isFullScreen = false;

  final String youtubeUrl = 'https://www.youtube.com/embed/yeTExU0nuho?si=7GeceW6FeSmT5bAi';
  late YoutubePlayerController _controller;
  late String _videoId;

  @override
  void initState() {
    super.initState();
    _videoId = _extractVideoId(youtubeUrl) ?? '';
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
      ),
    );
    _fetchVideoIntro();
  }

  Future<void> _fetchVideoIntro() async {
    final api = VideoIntroApi();
    final data = await api.fetchVideoIntroQuestions();

    if (data != null) {
      setState(() {
        _videoIntroModel = data;
        if (data.aboutYourself.trim().isNotEmpty) {
          _questionVideoPaths["tell me about yourself".toLowerCase()] =
              data.aboutYourself;
        }

        if (data.organizeYourDay.trim().isNotEmpty) {
          _questionVideoPaths["how do you organize your day?".toLowerCase()] =
              data.organizeYourDay;
        }

        if (data.yourStrength.trim().isNotEmpty) {
          _questionVideoPaths["what are your strengths?".toLowerCase()] =
              data.yourStrength;
        }

        if (data.taughtYourselfLately.trim().isNotEmpty) {
          _questionVideoPaths[
          "what is something you have taught yourself lately?"
              .toLowerCase()] = data.taughtYourselfLately;
        }
      });
    }
  }

  String? _extractVideoId(String url) {
    final RegExp regExp = RegExp(r'youtube\.com\/embed\/([a-zA-Z0-9_-]+)');
    final match = regExp.firstMatch(url);
    final videoId = match?.group(1);
    print('🔍 [MyInterviewVideos] Extracted YouTube video ID: $videoId');
    if (videoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid YouTube URL', style: TextStyle(fontSize: 12.sp))),
      );
    }
    return videoId;
  }

  Future<void> _recordVideo(String question) async {
    await [
      Permission.camera,
      Permission.storage,
      Permission.microphone,
    ].request();

    final picker = ImagePicker();
    final XFile? recorded = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 60));

    if (recorded != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final normalized = question.trim().toLowerCase();
      final fileName = "${normalized.replaceAll(" ", "_")}.mp4";
      final newPath = path.join(appDir.path, fileName);
      final File newVideo = await File(recorded.path).copy(newPath);

      setState(() {
        _questionVideoPaths[normalized] = newVideo.path;
      });
      print("🎥 Saved '$question' video to: $newPath");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);

    return OrientationBuilder(
      builder: (context, orientation) {
        _isFullScreen = orientation == Orientation.landscape;
        if (_isFullScreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }

        return WillPopScope(
          onWillPop: () async {
            await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _isFullScreen
                ? null
                : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: iconCircleButton(
                Icons.arrow_back_ios_new,
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              title: Text(
                "My Intro Videos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: const Color(0xFF003840),
                ),
              ),
              actions: [
                iconCircleButton(Icons.notifications_none),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              child: ListView(
                children: [
                  Text(
                    "Record Video Interview about Yourself",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF003840),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  SizedBox(
                    height: _isFullScreen
                        ? MediaQuery.of(context).size.height
                        : 160.h,
                    child: _videoId.isNotEmpty
                        ? YoutubePlayer(controller: _controller)
                        : Center(
                      child: Text(
                        'Invalid YouTube URL',
                        style: TextStyle(color: Colors.red, fontSize: 12.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _buildGuidelinesCard(),
                  SizedBox(height: 18.h),
                  _buildQuestionTile("Tell me about Yourself"),
                  _buildQuestionTile("How do you organize your day?"),
                  _buildQuestionTile("What are your strengths?"),
                  _buildQuestionTile("What is something you have taught yourself lately?"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF2F3),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Introduction",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: const Color(0xFF003840),
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            "• This video will automatically stop playing after 60 seconds.",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
          ),
          Text(
            "• Please ensure that the video and audio quality are of good standard.",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
          ),
          Text(
            "• The Background should have no visible elements and be transparent.",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
          ),
          Text(
            "• You can retake or check the video before uploading.",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
          ),
          Text(
            "• Once you upload the video, it will no longer be available to retake.",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(String question) {
    final normalized = question.trim().toLowerCase();
    final videoPath = _questionVideoPaths[normalized];
    final hasPath = videoPath != null && videoPath.isNotEmpty;
    final isRemote = hasPath && (videoPath!.startsWith('http') || videoPath.startsWith('https'));
    final existsLocally = hasPath && !isRemote ? File(videoPath!).existsSync() : false;
    final canPreview = isRemote || existsLocally;

    return Container(
      key: ValueKey('$normalized-$canPreview'),
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF2F3),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFCED8D9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: const Color(0xFF003840),
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005E6A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            ),
            icon: Icon(
              canPreview ? Icons.play_circle_fill_outlined : Icons.play_arrow,
              size: 18.w,
              color: Colors.white,
            ),
            label: Text(
              canPreview ? "Preview" : "Start",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
            onPressed: () async {
              print('🔍 [MyInterviewVideos] Button pressed for question: $question, canPreview: $canPreview, videoPath: $videoPath');
              if (canPreview) {
                print('🔍 [MyInterviewVideos] Navigating to VideoPreviewScreen for question: $question');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPreviewScreen(
                      videoUrl: videoPath!,
                      question: question,
                    ),
                  ),
                );
              } else {
                print('🔍 [MyInterviewVideos] Showing AlertDialog for question: $question');
                final shouldProceed = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    title: Text(
                      "Important",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    content: Text(
                      "Once you upload the video, it will no longer be available to retake!",
                      style: TextStyle(color: Colors.red, fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          print('🔍 [MyInterviewVideos] AlertDialog: Cancel pressed for question: $question');
                          Navigator.pop(context, false);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black, fontSize: 12.sp),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                        ),
                        onPressed: () {
                          print('🔍 [MyInterviewVideos] AlertDialog: Proceed pressed for question: $question');
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                );
                if (shouldProceed == true) {
                  print('🔍 [MyInterviewVideos] Proceeding with video recording for question: $question');
                  _recordVideo(question);
                } else {
                  print('🔍 [MyInterviewVideos] Recording cancelled for question: $question');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}

Widget iconCircleButton(IconData icon, {VoidCallback? onPressed}) {
  return Material(
    color: Colors.transparent,
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.all(9.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.4)),
          color: Colors.transparent,
        ),
        child: Icon(icon, size: 20.w, color: Colors.black),
      ),
    ),
  );
}