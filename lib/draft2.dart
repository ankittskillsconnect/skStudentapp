//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
// import '../../../Model/My_Interview_Videos_Model.dart';
// import '../../../Utilities/MyAccount_Get_Post/My_Interview_Videos_Api.dart';
// import 'VideopreviewScreen.dart';
//
// class MyInterviewVideos extends StatefulWidget {
//   const MyInterviewVideos({super.key});
//
//   @override
//   _MyInterviewVideosState createState() => _MyInterviewVideosState();
// }
//
// class _MyInterviewVideosState extends State<MyInterviewVideos> {
//   VideoIntroModel? _videoIntroModel;
//   final Map<String, String> _questionVideoPaths = {};
//   bool _isFullScreen = false;
//
//   final String youtubeUrl =
//       'https://www.youtube.com/embed/yeTExU0nuho?si=7GeceW6FeSmT5bAi';
//   late YoutubePlayerController _controller;
//   late String _videoId;
//
//   @override
//   void initState() {
//     super.initState();
//     _videoId = _extractVideoId(youtubeUrl) ?? '';
//     _controller = YoutubePlayerController.fromVideoId(
//       videoId: _videoId,
//       autoPlay: false,
//       params: const YoutubePlayerParams(
//         mute: false,
//         showControls: true,
//         showFullscreenButton: true,
//         enableCaption: true,
//       ),
//     );
//     _fetchVideoIntro();
//   }
//
//   VideoIntroAction? _mapQuestionToAction(String question) {
//     final normalized = question.trim().toLowerCase();
//     if (normalized.contains("tell me about yourself")) {
//       return VideoIntroAction.about_yourself;
//     } else if (normalized.contains("how do you organize your day")) {
//       return VideoIntroAction.organize_your_day;
//     } else if (normalized.contains("what are your strengths")) {
//       return VideoIntroAction.your_strength;
//     } else if (normalized.contains("what is something you have taught yourself lately")) {
//       return VideoIntroAction.taught_yourself_tately;
//     }
//     return null;
//   }
//
//   Future<void> _fetchVideoIntro() async {
//     final api = VideoIntroApi();
//     print('🔍 [MyInterviewVideos] Fetching video intro questions...');
//     final data = await api.fetchVideoIntroQuestions();
//     if (data != null) {
//       setState(() {
//         _videoIntroModel = data;
//         if (data.aboutYourself.trim().isNotEmpty) {
//           _questionVideoPaths["tell me about yourself".toLowerCase()] =
//               data.aboutYourself;
//         }
//         if (data.organizeYourDay.trim().isNotEmpty) {
//           _questionVideoPaths["how do you organize your day?".toLowerCase()] =
//               data.organizeYourDay;
//         }
//         if (data.yourStrength.trim().isNotEmpty) {
//           _questionVideoPaths["what are your strengths?".toLowerCase()] =
//               data.yourStrength;
//         }
//         if (data.taughtYourselfLately.trim().isNotEmpty) {
//           _questionVideoPaths[
//               "what is something you have taught yourself lately?"
//                   .toLowerCase()] = data.taughtYourselfLately;
//         }
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('Failed to load videos',
//                 style: TextStyle(fontSize: 12.sp))),
//       );
//     }
//   }
//
//   String? _extractVideoId(String url) {
//     final RegExp regExp = RegExp(r'youtube\.com\/embed\/([a-zA-Z0-9_-]+)');
//     final match = regExp.firstMatch(url);
//     final videoId = match?.group(1);
//     return videoId;
//   }
//
//   Future<void> recordVideo(String question) async {
//     final permissions = await [
//       Permission.camera,
//       Permission.storage,
//       Permission.microphone,
//     ].request();
//
//     if (permissions.values.every((status) => status.isGranted)) {
//       final picker = ImagePicker();
//       final XFile? recorded = await picker.pickVideo(
//         source: ImageSource.camera,
//         maxDuration: const Duration(seconds: 60),
//       );
//
//       if (recorded != null) {
//         final appDir = await getApplicationDocumentsDirectory();
//         final normalized = question.trim().toLowerCase();
//         final fileName = "${normalized.replaceAll(" ", "_")}.mp4";
//         final newPath = path.join(appDir.path, fileName);
//         final File newVideo = await File(recorded.path).copy(newPath);
//
//         setState(() {
//           _questionVideoPaths[normalized] = newVideo.path;
//         });
//       } else {
//         print(
//             '⚠️ [MyInterviewVideos] No video recorded for question: $question');
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('Permissions denied for recording',
//                 style: TextStyle(fontSize: 12.sp))),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context,
//         designSize: const Size(390, 844),
//         minTextAdapt: true,
//         splitScreenMode: true);
//
//     return OrientationBuilder(
//       builder: (context, orientation) {
//         _isFullScreen = orientation == Orientation.landscape;
//         if (_isFullScreen) {
//           SystemChrome.setPreferredOrientations([
//             DeviceOrientation.landscapeLeft,
//             DeviceOrientation.landscapeRight,
//           ]);
//           SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//         } else {
//           SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//           SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//         }
//
//         return WillPopScope(
//           onWillPop: () async {
//             await SystemChrome.setPreferredOrientations(
//                 [DeviceOrientation.portraitUp]);
//             await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//             return true;
//           },
//           child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: _isFullScreen
//                 ? null
//                 : AppBar(
//                     backgroundColor: Colors.white,
//                     elevation: 0,
//                     leading: iconCircleButton(
//                       Icons.arrow_back_ios_new,
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     centerTitle: true,
//                     title: Text(
//                       "My Intro Videos",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.sp,
//                         color: const Color(0xFF003840),
//                       ),
//                     ),
//                     actions: [
//                       iconCircleButton(Icons.notifications_none),
//                     ],
//                   ),
//             body: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
//               child: ListView(
//                 children: [
//                   Text(
//                     "Record Video Interview about Yourself",
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF003840),
//                     ),
//                   ),
//                   SizedBox(height: 14.h),
//                   SizedBox(
//                     height: _isFullScreen
//                         ? MediaQuery.of(context).size.height
//                         : 160.h,
//                     child: _videoId.isNotEmpty
//                         ? YoutubePlayer(controller: _controller)
//                         : Center(
//                             child: Text(
//                               'Invalid YouTube URL',
//                               style:
//                                   TextStyle(color: Colors.red, fontSize: 12.sp),
//                             ),
//                           ),
//                   ),
//                   SizedBox(height: 14.h),
//                   _buildGuidelinesCard(),
//                   SizedBox(height: 18.h),
//                   _buildQuestionTile("Tell me about Yourself"),
//                   _buildQuestionTile("How do you organize your day?"),
//                   _buildQuestionTile("What are your strengths?"),
//                   _buildQuestionTile(
//                       "What is something you have taught yourself lately?"),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildGuidelinesCard() {
//     return Container(
//       padding: EdgeInsets.all(10.w),
//       decoration: BoxDecoration(
//         color: const Color(0xFFDFF2F3),
//         borderRadius: BorderRadius.circular(10.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Introduction",
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14.sp,
//               color: const Color(0xFF003840),
//             ),
//           ),
//           SizedBox(height: 7.h),
//           Text(
//             "• This video will automatically stop playing after 60 seconds.",
//             style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
//           ),
//           Text(
//             "• Please ensure that the video and audio quality are of good standard.",
//             style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
//           ),
//           Text(
//             "• The Background should have no visible elements and be transparent.",
//             style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
//           ),
//           Text(
//             "• Once you upload the video, it will no longer be available to retake.",
//             style: TextStyle(fontSize: 12.sp, color: const Color(0xFF003840)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildQuestionTile(String question) {
//     final normalized = question.trim().toLowerCase();
//     final videoPath = _questionVideoPaths[normalized];
//     final hasPath = videoPath != null && videoPath.isNotEmpty;
//     final isRemote = hasPath &&
//         (videoPath!.startsWith('http') || videoPath.startsWith('https'));
//     final existsLocally =
//         hasPath && !isRemote ? File(videoPath!).existsSync() : false;
//     final canPreview = isRemote || existsLocally;
//
//     return Container(
//       key: ValueKey('$normalized-$canPreview'),
//       margin: EdgeInsets.only(bottom: 12.h),
//       padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFFDFF2F3),
//         borderRadius: BorderRadius.circular(10.r),
//         border: Border.all(color: const Color(0xFFCED8D9)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Text(
//               question,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14.sp,
//                 color: const Color(0xFF003840),
//               ),
//             ),
//           ),
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF005E6A),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25.r),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
//             ),
//             icon: Icon(
//               canPreview ? Icons.play_circle_fill_outlined : Icons.play_arrow,
//               size: 18.w,
//               color: Colors.white,
//             ),
//             label: Text(
//               canPreview ? "Preview" : "Start",
//               style: TextStyle(color: Colors.white, fontSize: 13.sp),
//             ),
//             onPressed: () {
//               if (canPreview) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => VideoPreviewScreen(
//                       videoUrl: videoPath!,
//                       question: question,
//                     ),
//                   ),
//                 );
//               } else {
//                 recordVideo(question);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.close();
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     super.dispose();
//   }
// }
//
// Widget iconCircleButton(IconData icon, {VoidCallback? onPressed}) {
//   return Material(
//     color: Colors.transparent,
//     shape: const CircleBorder(),
//     child: InkWell(
//       onTap: onPressed,
//       customBorder: const CircleBorder(),
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 5.w),
//         padding: EdgeInsets.all(9.w),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.grey.withOpacity(0.4)),
//           color: Colors.transparent,
//         ),
//         child: Icon(icon, size: 20.w, color: Colors.black),
//       ),
//     ),
//   );
// }
