import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/MyJobs/AppliedJobs.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/Myaccount/MyAccount.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/MyInterviewVid/MyInterviewVideos.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/WatchListScreen/WatchList.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'package:sk_loginscreen1/Utilities/MyAccount_Get_Post/AccountImageApi.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import '../../Model/AccountScreen_Image_Name_Model.dart';
import '../../ProfileLogic/ProfileEvent.dart';
import '../../ProfileLogic/ProfileLogic.dart';
import '../../Utilities/auth/LoginUserApi.dart';
import 'package:shimmer/shimmer.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AcountScreenImageModel? _profileData;
  int _selectedIndex = 0;
  bool _isLoggingOut = false;
  bool _snackBarShown = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('🔍 [AccountScreen] Bottom nav index changed to: $index');
    });
  }

  final List<Map<String, dynamic>> options = [
    {"icon": Icons.person_outline, "label": "My Account"},
    {"icon": Icons.business_center_outlined, "label": "My Jobs"},
    {"icon": Icons.bookmark_add_outlined, "label": "Watchlist"},
    {"icon": Icons.assessment_outlined, "label": "Assessment"},
    {"icon": Icons.ondemand_video_sharp, "label": "My Intro videos"},
    {"icon": Icons.settings_outlined, "label": "Account Settings"},
    {"icon": Icons.logout, "label": "Logout"},
  ];
  int selectedOptionIndex = -1;

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showSnackBarOnce(BuildContext context, String message, {int cooldownSeconds = 3}) {
    if (_snackBarShown) return;
    _snackBarShown = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 12.4.sp)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: cooldownSeconds),
      ),
    );
    Future.delayed(Duration(seconds: cooldownSeconds), () {
      _snackBarShown = false;
    });
  }

  Future<void> _logout() async {
    print('🔍 [AccountScreen] Initiating logout');
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Confirm Logout', style: TextStyle(fontSize: 18.1.sp)),
        content: Text('Are you sure you want to logout?', style: TextStyle(fontSize: 14.4.sp)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 14.4.sp)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Logout', style: TextStyle(color: Colors.black, fontSize: 14.4.sp)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      if (!await _hasInternetConnection()) {
        print('❌ [AccountScreen] No internet connection');
        _showSnackBarOnce(context, "No internet connection");
        return;
      }
      setState(() => _isLoggingOut = true);
      final loginService = loginUser();
      await loginService.clearToken();
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        print('✅ [AccountScreen] Logout successful, navigating to login page');
        context.read<NavigationBloc>().add(GobackToLoginPage());
      }
      setState(() => _isLoggingOut = false);
    } else {
      print('🔍 [AccountScreen] Logout cancelled');
    }
  }

  @override
  void initState() {
    super.initState();
    print('🔍 [AccountScreen] Initializing');
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    print('🔍 [AccountScreen] Loading profile data');
    final data = await AccountImageApi.fetchAccountScreenData();
    if (mounted) {
      setState(() {
        _profileData = data;
        print('✅ [AccountScreen] Profile data loaded: ${_profileData?.firstName ?? 'N/A'}');
      });
    } else {
      print('⚠️ [AccountScreen] Widget not mounted, skipping profile data update');
    }
  }

  Future<void> _onRefresh() async {
    print('🔍 [AccountScreen] Refreshing profile data');
    context.read<ProfileBloc>().add(LoadProfileData());
    await Future.delayed(const Duration(seconds: 1));
    print('✅ [AccountScreen] Refresh completed');
  }

  String _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return 'N/A';
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dob);
      final today = DateTime.now();
      int age = today.year - date.year;
      if (today.month < date.month || (today.month == date.month && today.day < date.day)) {
        age--;
      }
      if (age < 0 || age > 120) return 'N/A';
      return '$age years old';
    } catch (_) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844), minTextAdapt: true, splitScreenMode: true);

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, __) {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 21.1.w),
            child: Column(
              children: [
                SizedBox(height: 11.4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 24.6.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF003840),
                      ),
                    ),
                    _iconCircle(
                      icon: Icons.notifications_none,
                      iconSize: 22.9.w,
                    ),
                  ],
                ),
                SizedBox(height: 25.3.h),
                _profileData == null
                    ? ProfileHeaderShimmer(profileSize: 130.2.w)
                    : Column(
                  children: [
                    Container(
                      width: 130.2.w,
                      height: 130.2.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF005E6A),
                          width: 1.8.w,
                        ),
                      ),
                      child: ClipOval(
                        child: _profileData!.userImage != null
                            ? Image.network(
                          _profileData!.userImage!,
                          fit: BoxFit.cover,
                        )
                            : const Image(
                          image: AssetImage('assets/placeholder.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 11.4.h),
                    Text(
                      '${_profileData!.firstName ?? ''} ${_profileData!.lastName ?? ''}',
                      style: TextStyle(
                        fontSize: 18.1.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF005E6A),
                      ),
                    ),
                    SizedBox(height: 1.9.h),
                    if (_profileData!.age != null)
                      Text(
                        _calculateAge(_profileData!.age!),
                        style: TextStyle(
                          fontSize: 14.4.sp,
                          color: const Color(0xFF6A8E92),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 11.4.h),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: const Color(0xFF005E6A),
                    backgroundColor: Colors.white,
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        return _AccountOption(
                          icon: option['icon'] as IconData,
                          label: option['label'] as String,
                          isSelected: selectedOptionIndex == index,
                          onTap: () {
                            setState(() => selectedOptionIndex = index);
                            Future.delayed(
                              const Duration(milliseconds: 100),
                                  () {
                                if (!mounted) return;
                                setState(() => selectedOptionIndex = -1);
                              },
                            );
                            print('🔍 [AccountScreen] Tapped option: ${option['label']}');
                            switch (option['label']) {
                              case 'Logout':
                                _logout();
                                break;
                              case 'My Account':
                                print('🔍 [AccountScreen] Navigating to MyAccount');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MyAccount(),
                                  ),
                                ).then((_) {
                                  if (mounted) {
                                    print('🔍 [AccountScreen] Returned from MyAccount, reloading profile');
                                    context.read<ProfileBloc>().add(LoadProfileData());
                                  }
                                });
                                break;
                              case 'My Intro videos':
                                print('🔍 [AccountScreen] Navigating to MyInterviewVideos');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MyInterviewVideos(),
                                  ),
                                );
                                break;
                              case 'Watchlist':
                                print('🔍 [AccountScreen] Navigating to WatchListPage');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WatchListPage(),
                                  ),
                                );
                                break;
                              case 'My Jobs':
                                print('🔍 [AccountScreen] Navigating to AppliedJobsPage');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AppliedJobsPage(),
                                  ),
                                );
                                break;
                              default:
                                print('⚠️ [AccountScreen] Unhandled option: ${option['label']}');
                                break;
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _iconCircle({required IconData icon, required double iconSize}) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 0.9.w),
      ),
      child: Icon(icon, size: iconSize, color: const Color(0xFF003840)),
    );
  }
}

class _AccountOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AccountOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7.2.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.2.h),
        child: Row(
          children: [
            Icon(icon, size: 21.1.w),
            SizedBox(width: 14.1.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeaderShimmer extends StatelessWidget {
  final double profileSize;

  const ProfileHeaderShimmer({super.key, required this.profileSize});

  @override
  Widget build(BuildContext context) {
    print('🔍 [AccountScreen] Rendering ProfileHeaderShimmer');
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            width: profileSize,
            height: profileSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 11.4.h),
          Container(
            width: 144.4.w,
            height: 21.7.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.4.r),
            ),
          ),
          SizedBox(height: 1.9.h),
          Container(
            width: 90.3.w,
            height: 16.2.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.4.r),
            ),
          ),
        ],
      ),
    );
  }
}