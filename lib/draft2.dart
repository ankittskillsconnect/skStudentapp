// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:shimmer/shimmer.dart';
// // import 'package:sk_loginscreen1/BottamTabScreens/JobTab/AppBarJobScreen.dart';
// // import 'package:sk_loginscreen1/BottamTabScreens/JobTab/JobdetailPage/JobdetailpageBT.dart';
// // import 'package:sk_loginscreen1/Pages/bottombar.dart';
// // import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
// // import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
// // import '../../Utilities/JobListApi.dart';
// // import 'JobCardBT.dart';
// //
// // class Jobscreenbt extends StatefulWidget {
// //   const Jobscreenbt({super.key});
// //
// //   @override
// //   State<Jobscreenbt> createState() => _JobScreenbtState();
// // }
// //
// // class _JobScreenbtState extends State<Jobscreenbt> {
// //   List<Map<String, dynamic>> jobs = [];
// //   bool isLoading = true;
// //   String? errorMessage;
// //   int _selectedIndex = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchJobs();
// //   }
// //
// //   Future<void> _fetchJobs() async {
// //     setState(() {
// //       isLoading = true;
// //       errorMessage = null;
// //     });
// //     try {
// //       final fetchedJobs = await JobApi.fetchJobs();
// //       setState(() {
// //         jobs = fetchedJobs;
// //         isLoading = false;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = 'Failed to load jobs: \$e';
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('Failed to load jobs: \$e')),
// //         );
// //       });
// //     }
// //   }
// //
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocListener<NavigationBloc, NavigationState>(
// //       listener: (context, state) {
// //         if (state is NavigateTOJobDetailBT) {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => JobDetailPage2(jobToken: state.jobToken),
// //             ),
// //           );
// //         }
// //       },
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         appBar: Appbarjobscreen(),
// //         body: SafeArea(
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Column(
// //               children: [
// //                 const SizedBox(height: 10),
// //                 Expanded(
// //                   child: isLoading
// //                       ? ListView.builder(
// //                     itemCount: 5,
// //                     itemBuilder: (context, index) => _buildShimmerCard(),
// //                   )
// //                       : errorMessage != null
// //                       ? Center(
// //                     child: Text(
// //                       errorMessage!,
// //                       style: const TextStyle(color: Colors.red),
// //                     ),
// //                   )
// //                       : jobs.isEmpty
// //                       ? const Center(child: Text('No jobs found'))
// //                       : ListView.builder(
// //                     itemCount: jobs.length,
// //                     itemBuilder: (context, index) {
// //                       final job = jobs[index];
// //                       return InkWell(
// //                         onTap: () {
// //                           Navigator.push(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) => JobDetailPage2(
// //                                 jobToken: job['jobToken'],
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                         child: JobCardBT(
// //                           jobTitle: job['title'],
// //                           company: job['company'],
// //                           location: job['location'],
// //                           salary: job['salary'],
// //                           postTime: job['postTime'],
// //                           expiry: job['expiry'],
// //                           tags: List<String>.from(job['tags']),
// //                           logoUrl: job['logoUrl'],
// //                           jobToken: job['jobToken'],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //         bottomNavigationBar: CustomBottomNavBar(
// //           currentIndex: _selectedIndex,
// //           onTap: _onItemTapped,
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // Widget _buildShimmerCard() {
// //   return Container(
// //     margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
// //     padding: const EdgeInsets.all(8),
// //     decoration: BoxDecoration(
// //       borderRadius: BorderRadius.circular(25),
// //     ),
// //     child: Shimmer.fromColors(
// //       baseColor: Colors.grey.shade300,
// //       highlightColor: Colors.grey.shade100,
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(12),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Container(
// //                       width: 40,
// //                       height: 40,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Container(
// //                             height: 18,
// //                             width: 120,
// //                             color: Colors.white,
// //                           ),
// //                           const SizedBox(height: 6),
// //                           Container(
// //                             height: 14,
// //                             width: 180,
// //                             color: Colors.white,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Container(
// //                       height: 16,
// //                       width: 50,
// //                       color: Colors.white,
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),
// //                 Wrap(
// //                   spacing: 8,
// //                   runSpacing: 8,
// //                   children: List.generate(3, (index) {
// //                     return Container(
// //                       height: 20,
// //                       width: 60,
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(20),
// //                       ),
// //                     );
// //                   }),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Container(
// //                   height: 14,
// //                   width: 80,
// //                   color: Colors.white,
// //                 ),
// //                 Container(
// //                   height: 14,
// //                   width: 60,
// //                   color: Colors.white,
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }
// //
// //
// //
// // import 'package:flutter/material.dart';
// //
// // import 'JobdetailPage/JobdetailpageBT.dart';
// //
// // class JobCardBT extends StatelessWidget {
// //   final String jobTitle;
// //   final String company;
// //   final String location;
// //   final String salary;
// //   final String postTime;
// //   final String expiry;
// //   final List<String> tags;
// //   final String? logoUrl;
// //   final String jobToken;
// //
// //   const JobCardBT({
// //     super.key,
// //     required this.jobTitle,
// //     required this.company,
// //     required this.location,
// //     required this.salary,
// //     required this.postTime,
// //     required this.expiry,
// //     required this.tags,
// //     required this.jobToken,
// //     this.logoUrl,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(
// //             builder: (_) => JobDetailPage2(jobToken: jobToken),
// //           ),
// //         );
// //       },
// //       child: Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
// //         padding: const EdgeInsets.all(8),
// //         decoration: BoxDecoration(
// //           color: const Color(0xFFEBF6F7),
// //           borderRadius: BorderRadius.circular(25),
// //           border: Border.all(color: const Color(0xFFBCD8DB), width: 2),
// //         ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         padding: const EdgeInsets.all(3),
// //                         margin: const EdgeInsets.only(bottom: 0),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(8),
// //                           border: Border.all(color: const Color(0xFF005E6A)),
// //                         ),
// //                         child: logoUrl != null && logoUrl!.isNotEmpty
// //                             ? Image.network(
// //                           logoUrl!,
// //                           width: 40,
// //                           height: 40,
// //                           fit: BoxFit.contain,
// //                           errorBuilder: (context, error, stackTrace) {
// //                             print("Image load error: $error");
// //                             return Image.asset("assets/google.png", width: 40, height: 40);
// //                           },
// //                         )
// //                             : Image.asset("assets/google.png", width: 40, height: 40),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               jobTitle,
// //                               style: const TextStyle(
// //                                 fontWeight: FontWeight.bold,
// //                                 fontSize: 19,
// //                                 color: Color(0xFF003840),
// //                               ),
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                             Text(
// //                               "$company\n$location",
// //                               style: const TextStyle(
// //                                 fontSize: 15,
// //                                 color: Color(0xFF827B7B),
// //                               ),
// //                               maxLines: 2,
// //                               overflow: TextOverflow.ellipsis,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Text(
// //                         salary,
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           color: Color(0xFF005E6A),
// //                           fontWeight: FontWeight.w700,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 12),
// //                   Wrap(
// //                     spacing: 8,
// //                     runSpacing: 8,
// //                     children: tags.map((tag) {
// //                       return Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(20),
// //                           border: Border.all(color: const Color(0xFF827B7B)),
// //                         ),
// //                         child: Text(
// //                           tag,
// //                           style: const TextStyle(
// //                             color: Color(0xFF003840),
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 10),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       const Icon(Icons.access_time, size: 22, color: Color(0xFF003840)),
// //                       const SizedBox(width: 4),
// //                       Text(
// //                         postTime,
// //                         style: const TextStyle(
// //                           fontSize: 16,
// //                           color: Color(0xFF003840),
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFFEDDDC),
// //                       borderRadius: BorderRadius.circular(20),
// //                       border: Border.all(color: const Color(0xFFBCD8DB)),
// //                     ),
// //                     child: Text(
// //                       expiry,
// //                       style: const TextStyle(
// //                         color: Color(0xFFD03C2D),
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// //
// // class JobDetailPage2 extends StatefulWidget {
// //   final String jobToken; // 👈 Add this
// //
// //   const JobDetailPage2({super.key, required this.jobToken}); // 👈 Required param
// //
// //   @override
// //   State<JobDetailPage2> createState() => _JobDetailPage2State();
// // }
// //
// // class _JobDetailPage2State extends State<JobDetailPage2> {
// //   final List<String> responsibilities = [
// //     'Initially students will be placed in various departments – Warping, Weaving, TFO, Monofilament, Packing & Dispatch, Stitching, Processing, Non – Woven etc. of our factory, to understand the flow of production process.',
// //     'Post that their area of expertise will be finalised.',
// //   ];
// //
// //   final List<String> termsAndConditions = [
// //     'Students shall be hired as GET (Graduate Engineer Trainee) , for minimum one year.',
// //     'Food to be arranged by students on their own. (Canteen Facility available at factory premises , which will be on actual cost).',
// //     'An Amount of Rs.1500/- per month shall be deducted towards Bachelor Accommodation (only applicable to students who are joining at Wada factory).',
// //     'There will be Retention Bonus for three years of Rs.1500 per month , the aforesaid amount shall be deducted every month and will be reimbursed on completion of three years with us.',
// //     'Non-Disclosure Affidavit cum Declaration will be there at the time of joining.',
// //     'Detail GET joining Letter (Appointment Letter) will be provided at the time of joining.',
// //   ];
// //
// //   final List<String> requirements = [
// //     'Bachelors degree in Textile Engineering or related field',
// //     'Strong understanding of textile manufacturing processes and materials',
// //     'Ability to work well in a team environment',
// //     'Strong communication and organizational skills',
// //     'Willingness to learn and adapt to new technologies and processes',
// //     'Basic computer skills including proficiency in Microsoft Office',
// //   ];
// //
// //   final List<String> niceToHave = [
// //     'Internship or project experience in the textile industry',
// //     'Understanding of sustainable textile production practices',
// //   ];
// //
// //   final List<String> aboutCompany = [
// //     'Alphabet Pvt. Ltd. is a leading manufacturer of technical textiles and industrial filter fabrics, serving industries like pharma, mining, food processing, and wastewater treatment.',
// //     'With over 40 years of experience and state-of-the-art facilities in Maharashtra, Daman, and Surat, they offer fully integrated production—from fiber to finished products.',
// //     'The company exports to 120+ countries and is known for quality, innovation, and sustainability.',
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final double widthScale = size.width / 360;
// //     final double heightScale = size.height / 640;
// //     final double fontScale = (widthScale * 0.8).clamp(0.8, 1.2);
// //     final double sizeScale = (widthScale * 0.9).clamp(0.9, 1.3);
// //
// //     return AnnotatedRegion<SystemUiOverlayStyle>(
// //       value: SystemUiOverlayStyle.dark.copyWith(
// //         statusBarColor: Colors.white,
// //         statusBarIconBrightness: Brightness.dark,
// //       ),
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         appBar: PreferredSize(
// //           preferredSize: Size.fromHeight(50 * heightScale),
// //           child: Padding(
// //             padding: EdgeInsets.all(1 * sizeScale),
// //             child: AppBar(
// //               backgroundColor: Colors.white,
// //               surfaceTintColor: Colors.white,
// //               elevation: 0,
// //               centerTitle: true,
// //               titleSpacing: 0,
// //               title: Text(
// //                 "Job Detail",
// //                 style: TextStyle(
// //                   fontSize: 25 * fontScale,
// //                   color: const Color(0xFF003840),
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               leading: Padding(
// //                 padding: EdgeInsets.only(left: 12 * sizeScale),
// //                 child: Center(
// //                   child: Container(
// //                     width: 46 * sizeScale,
// //                     height: 46 * sizeScale,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       border: Border.all(color: Colors.grey.shade300),
// //                     ),
// //                     child: IconButton(
// //                       padding: EdgeInsets.all(12),
// //                       icon: Icon(
// //                         Icons.arrow_back_ios,
// //                         size: 22 * sizeScale,
// //                         color: const Color(0xFF003840),
// //                       ),
// //                       onPressed: () => Navigator.pop(context),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               actions: [
// //                 Padding(
// //                   padding: EdgeInsets.only(right: 12 * sizeScale),
// //                   child: Center(
// //                     child: Container(
// //                       width: 46 * sizeScale,
// //                       height: 46 * sizeScale,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         border: Border.all(color: Colors.grey.shade300),
// //                       ),
// //                       child: IconButton(
// //                         padding: EdgeInsets.zero,
// //                         icon: Icon(
// //                           Icons.share,
// //                           size: 22 * sizeScale,
// //                           color: const Color(0xFF003840),
// //                         ),
// //                         onPressed: () {},
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         body: SingleChildScrollView(
// //           child: Padding(
// //             padding: EdgeInsets.symmetric(
// //               horizontal: 16 * sizeScale,
// //               vertical: 5 * sizeScale,
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 _jobHeader(size, widthScale, fontScale),
// //                 _sectionTitle('Responsibilities of the Candidate:'),
// //                 _bulletSection(responsibilities, sizeScale),
// //                 _sectionTitle('Terms and Condition :-'),
// //                 _bulletSection(termsAndConditions, sizeScale),
// //                 _sectionTitle('Requirements:'),
// //                 _bulletSection(requirements, sizeScale),
// //                 _sectionTitle('Nice to Have:'),
// //                 _bulletSection(niceToHave, sizeScale),
// //                 _sectionTitle('About Company'),
// //                 _bulletSection(aboutCompany, sizeScale),
// //                 const SizedBox(height: 16),
// //               ],
// //             ),
// //           ),
// //         ),
// //         bottomNavigationBar: Container(
// //           padding: EdgeInsets.symmetric(
// //             vertical: 12 * sizeScale,
// //             horizontal: 140 * sizeScale,
// //           ),
// //           color: const Color(0xFFEFF8F9),
// //           child: Row(
// //             children: [
// //               Expanded(
// //                 child: ElevatedButton(
// //                   onPressed: () {
// //                     // You can use the jobToken here if needed
// //                     print('Apply pressed for jobToken: ${widget.jobToken}');
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF005E6A),
// //                     foregroundColor: Colors.white,
// //                     padding: EdgeInsets.symmetric(vertical: 16 * sizeScale),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(30 * sizeScale),
// //                     ),
// //                     elevation: 0,
// //                   ),
// //                   child: Text(
// //                     "Apply Now",
// //                     style: TextStyle(
// //                       fontSize: 16 * fontScale,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _jobHeader(Size size, double widthScale, double fontScale) {
// //     return Padding(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: 5 * widthScale,
// //         vertical: 10 * widthScale,
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Image.asset(
// //                 'assets/google.png',
// //                 height: 48 * widthScale,
// //                 width: 48 * widthScale,
// //               ),
// //               SizedBox(width: 10 * widthScale),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Row(
// //                       children: [
// //                         Expanded(
// //                           child: Text(
// //                             "Software engineer",
// //                             style: TextStyle(
// //                               fontSize: 18 * fontScale,
// //                               fontWeight: FontWeight.bold,
// //                               color: const Color(0xFF005E6A),
// //                             ),
// //                           ),
// //                         ),
// //                         Align(
// //                           alignment: Alignment.center,
// //                           child: Icon(
// //                             Icons.bookmark_add_outlined,
// //                             size: 26 * widthScale,
// //                             color: const Color(0xFF005E6A),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       "Google • Surat, India",
// //                       style: TextStyle(
// //                         fontSize: 14 * fontScale,
// //                         color: Colors.grey[700],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //           SizedBox(height: 14 * widthScale),
// //           Padding(
// //             padding: EdgeInsets.only(left: 10 * widthScale),
// //             child: Align(
// //               alignment: Alignment.centerLeft,
// //               child: Wrap(
// //                 spacing: 10 * widthScale,
// //                 children: const [
// //                   _Tag(label: "Full-time"),
// //                   _Tag(label: "In-office"),
// //                   _Tag(label: "14 Openings"),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _sectionTitle(String title) => Padding(
// //     padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
// //     child: Text(
// //       title,
// //       style: const TextStyle(
// //         fontSize: 18,
// //         fontWeight: FontWeight.bold,
// //         color: Color(0xFF003840),
// //       ),
// //     ),
// //   );
// //
// //   Widget _bulletSection(List<String> items, double scale) => Container(
// //     decoration: BoxDecoration(
// //       color: const Color(0xFFEBF6F7),
// //       borderRadius: BorderRadius.circular(12 * scale),
// //     ),
// //     padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 12 * scale),
// //     margin: EdgeInsets.only(bottom: 8 * scale),
// //     child: Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: items.map((e) {
// //         return Padding(
// //           padding: EdgeInsets.symmetric(vertical: 4 * scale),
// //           child: Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text("\u2022 ", style: TextStyle(fontSize: 16 * scale)),
// //               Expanded(child: Text(e, style: TextStyle(fontSize: 14 * scale))),
// //             ],
// //           ),
// //         );
// //       }).toList(),
// //     ),
// //   );
// // }
// //
// // class _Tag extends StatelessWidget {
// //   final String label;
// //
// //   const _Tag({required this.label});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final widthScale = size.width / 360;
// //     return Container(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: 12 * widthScale,
// //         vertical: 6 * widthScale,
// //       ),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFEFF8F9),
// //         borderRadius: BorderRadius.circular(20 * widthScale),
// //       ),
// //       child: Text(
// //         label,
// //         style: TextStyle(
// //           color: const Color(0xFF005E6A),
// //           fontSize: 14 * widthScale,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../../Utilities/JobDetailApi.dart';
//
// class JobDetailPage2 extends StatefulWidget {
//   final String jobToken;
//
//   const JobDetailPage2({super.key, required this.jobToken});
//
//   @override
//   State<JobDetailPage2> createState() => _JobDetailPage2State();
// }
//
// class _JobDetailPage2State extends State<JobDetailPage2> {
//   Map<String, dynamic>? jobDetail;
//   bool isLoading = true;
//   String? error;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchJobDetail();
//   }
//
//   Future<void> _fetchJobDetail() async {
//     setState(() {
//       isLoading = true;
//       error = null;
//     });
//     try {
//       // 🔁 Replace this with your actual API call
//       final data = await JobDetailApi.fetchJobDetail( token: widget.jobToken);
//       setState(() {
//         jobDetail = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = 'Failed to load job details: $e';
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final double widthScale = size.width / 360;
//     final double heightScale = size.height / 640;
//     final double fontScale = (widthScale * 0.8).clamp(0.8, 1.2);
//     final double sizeScale = (widthScale * 0.9).clamp(0.9, 1.3);
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark.copyWith(
//         statusBarColor: Colors.white,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: _buildAppBar(fontScale, sizeScale),
//         body: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : error != null
//             ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
//             : _buildBody(widthScale, fontScale, sizeScale),
//         bottomNavigationBar: _buildBottomBar(sizeScale, fontScale),
//       ),
//     );
//   }
//
//   PreferredSize _buildAppBar(double fontScale, double sizeScale) {
//     return PreferredSize(
//       preferredSize: Size.fromHeight(50 * sizeScale),
//       child: Padding(
//         padding: EdgeInsets.all(1 * sizeScale),
//         child: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//           titleSpacing: 0,
//           title: Text(
//             "Job Detail",
//             style: TextStyle(
//               fontSize: 25 * fontScale,
//               color: const Color(0xFF003840),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           leading: Padding(
//             padding: EdgeInsets.only(left: 12 * sizeScale),
//             child: _circleIconButton(
//               icon: Icons.arrow_back_ios,
//               sizeScale: sizeScale,
//               onTap: () => Navigator.pop(context),
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: EdgeInsets.only(right: 12 * sizeScale),
//               child: _circleIconButton(
//                 icon: Icons.share,
//                 sizeScale: sizeScale,
//                 onTap: () {},
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _circleIconButton({required IconData icon, required double sizeScale, required VoidCallback onTap}) {
//     return Center(
//       child: Container(
//         width: 46 * sizeScale,
//         height: 46 * sizeScale,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: IconButton(
//           padding: EdgeInsets.all(12),
//           icon: Icon(icon, size: 22 * sizeScale, color: const Color(0xFF003840)),
//           onPressed: onTap,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody(double widthScale, double fontScale, double sizeScale) {
//     final jd = jobDetail!;
//     final tags = jd['tags'] ?? [];
//     final List<String> responsibilities = List<String>.from(jd['responsibilities'] ?? []);
//     final List<String> terms = List<String>.from(jd['terms'] ?? []);
//     final List<String> requirements = List<String>.from(jd['requirements'] ?? []);
//     final List<String> niceToHave = List<String>.from(jd['niceToHave'] ?? []);
//     final List<String> about = List<String>.from(jd['aboutCompany'] ?? []);
//
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16 * sizeScale, vertical: 5 * sizeScale),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _jobHeader(jd, widthScale, fontScale, tags),
//             _sectionTitle('Responsibilities of the Candidate:'),
//             _bulletSection(responsibilities, sizeScale),
//             _sectionTitle('Terms and Conditions:'),
//             _bulletSection(terms, sizeScale),
//             _sectionTitle('Requirements:'),
//             _bulletSection(requirements, sizeScale),
//             _sectionTitle('Nice to Have:'),
//             _bulletSection(niceToHave, sizeScale),
//             _sectionTitle('About Company:'),
//             _bulletSection(about, sizeScale),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _jobHeader(Map<String, dynamic> jd, double widthScale, double fontScale, List tags) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5 * widthScale, vertical: 10 * widthScale),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 24 * widthScale,
//                 backgroundImage: NetworkImage(jd['logoUrl'] ?? ''),
//                 backgroundColor: Colors.grey[200],
//               ),
//               SizedBox(width: 10 * widthScale),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       jd['title'] ?? '',
//                       style: TextStyle(
//                         fontSize: 18 * fontScale,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF005E6A),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${jd['company']} • ${jd['location']}',
//                       style: TextStyle(fontSize: 14 * fontScale, color: Colors.grey[700]),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(Icons.bookmark_add_outlined, size: 26 * widthScale, color: const Color(0xFF005E6A)),
//             ],
//           ),
//           SizedBox(height: 14 * widthScale),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Wrap(
//               spacing: 10 * widthScale,
//               children: tags.map<Widget>((tag) => _Tag(label: tag)).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String title) => Padding(
//     padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
//     child: Text(
//       title,
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF003840),
//       ),
//     ),
//   );
//
//   Widget _bulletSection(List<String> items, double scale) => Container(
//     decoration: BoxDecoration(
//       color: const Color(0xFFEBF6F7),
//       borderRadius: BorderRadius.circular(12 * scale),
//     ),
//     padding: EdgeInsets.symmetric(vertical: 10 * scale, horizontal: 12 * scale),
//     margin: EdgeInsets.only(bottom: 8 * scale),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: items.map((e) {
//         return Padding(
//           padding: EdgeInsets.symmetric(vertical: 4 * scale),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("• ", style: TextStyle(fontSize: 16 * scale)),
//               Expanded(child: Text(e, style: TextStyle(fontSize: 14 * scale))),
//             ],
//           ),
//         );
//       }).toList(),
//     ),
//   );
//
//   Widget _buildBottomBar(double sizeScale, double fontScale) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 12 * sizeScale, horizontal: 140 * sizeScale),
//       color: const Color(0xFFEFF8F9),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               onPressed: () {
//                 print('Apply for job: ${widget.jobToken}');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF005E6A),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 16 * sizeScale),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30 * sizeScale),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(
//                 "Apply Now",
//                 style: TextStyle(
//                   fontSize: 16 * fontScale,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Tag extends StatelessWidget {
//   final String label;
//
//   const _Tag({required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final widthScale = size.width / 360;
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12 * widthScale, vertical: 6 * widthScale),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEFF8F9),
//         borderRadius: BorderRadius.circular(20 * widthScale),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: const Color(0xFF005E6A),
//           fontSize: 14 * widthScale,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// class JobApi {
//   static Future<List<Map<String, dynamic>>> fetchJobs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final authToken = prefs.getString('authToken') ?? '';
//     final connectSid = prefs.getString('connectSid') ?? '';
//     final bearerToken = 'Bearer eyJhbGciOi...'; // Use dynamic token if required
//
//     final response = await http.post(
//       Uri.parse('https://api.skillsconnect.in/dcxqyqzqpdydfk/api/jobs'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': bearerToken,
//         'Cookie': 'authToken=$authToken; connect.sid=$connectSid',
//       },
//       body: '',
//     ).timeout(const Duration(seconds: 10));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == true && data['jobs'] is List) {
//         return data['jobs'].map<Map<String, dynamic>>((job) {
//           final skills = (job['skills'] as String?)?.split(',') ?? [];
//           final tags = [
//             if (job['job_type'] != null) job['job_type'] as String,
//             ...skills.where((tag) => tag.isNotEmpty)
//           ];
//
//           final createdOn = DateTime.tryParse(job['created_on'] ?? '') ?? DateTime.now();
//           final now = DateTime.now();
//           final hoursAgo = now.difference(createdOn).inHours;
//           final postTime = hoursAgo < 24 ? '$hoursAgo hr ago' : '${hoursAgo ~/ 24} days ago';
//
//           return {
//             'title': job['title'] ?? '',
//             'company': job['company_name'] ?? '',
//             'location': (job['job_location_detail'] is List && job['job_location_detail'].isNotEmpty)
//                 ? job['job_location_detail'][0]['city_name'] ?? ''
//                 : '',
//             'salary': job['cost_to_company'] ?? '',
//             'postTime': postTime,
//             'expiry': job['end_date'] ?? '',
//             'tags': tags,
//             'logoUrl': job['company_logo'] ?? '',
//             'jobToken': job['job_invitation_token'] ?? '',
//           };
//         }).toList();
//       } else {
//         throw Exception('Invalid response format: ${data['msg']}');
//       }
//     } else {
//       throw Exception('Failed to fetch jobs: ${response.statusCode} - ${response.reasonPhrase}');
//     }
//   }
//
// }