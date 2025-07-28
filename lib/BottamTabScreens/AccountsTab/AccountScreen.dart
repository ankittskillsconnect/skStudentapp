import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/MyJobs/AppliedJobs.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/Myaccount/MyAccount.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/MyInterviewVid/MyInterviewVideos.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/WatchListScreen/WatchList.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import '../../ProfileLogic/ProfileEvent.dart';
import '../../ProfileLogic/ProfileLogic.dart';
import '../../ProfileLogic/ProfileState.dart';
import '../../Utilities/auth/LoginUserApi.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> options = [
    {"icon": Icons.person_outline, "label": "My Account"},
    {"icon": Icons.business_center_outlined, "label": "My Jobs"},
    {"icon": Icons.bookmark_add_outlined, "label": "Watchlist"},
    {"icon": Icons.account_balance_outlined, "label": "Campus Ambassador"},
    {"icon": Icons.ondemand_video_sharp, "label": "My interview videos"},
    {"icon": Icons.settings_outlined, "label": "Account Settings"},
    {"icon": Icons.logout, "label": "Logout"},
  ];

  int selectedOptionIndex = -1;

  Future<void> _logout() async {
    final loginService = loginUser();
    await loginService.clearToken();
    if (context.mounted) {
      context.read<NavigationBloc>().add(GobackToLoginPage());
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileData());
  }

  Future<void> _onRefresh() async {
    context.read<ProfileBloc>().add(LoadProfileData());
    await Future.delayed(const Duration(seconds: 1));
  }

  String _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return 'N/A';
    try {
      final date = DateFormat('dd, MMM yyyy').parse(dob);
      final today = DateTime.now();
      int age = today.year - date.year;
      if (today.month < date.month ||
          (today.month == date.month && today.day < date.day)) {
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
    final media = MediaQuery.of(context).size;
    final double iconSize = media.width * 0.065;
    final double profileSize = media.width * 0.37;
    final double spacing = media.height * 0.015;

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (_, __) {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.06),
            child: Column(
              children: [
                SizedBox(height: spacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: media.width * 0.07,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF003840),
                      ),
                    ),
                    _iconCircle(
                      icon: Icons.notifications_none,
                      iconSize: iconSize,
                    ),
                  ],
                ),
                SizedBox(height: media.height * 0.05),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading)
                      return const CircularProgressIndicator();
                    if (state is ProfileDataLoaded) {
                      return Column(
                        children: [
                          Container(
                            width: profileSize,
                            height: profileSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF005E6A),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: state.profileImage != null
                                  ? Image.file(
                                      state.profileImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Image(
                                      image: AssetImage(
                                        'assets/placeholder.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          SizedBox(height: spacing * 1.7),
                          Text(
                            state.fullname,
                            style: TextStyle(
                              fontSize: media.width * 0.05,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF005E6A),
                            ),
                          ),
                          SizedBox(height: spacing * 0.3),
                          Text(
                            _calculateAge(state.dob),
                            style: TextStyle(
                              fontSize: media.width * 0.04,
                              color: const Color(0xFF6A8E92),
                            ),
                          ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator(color: Colors.teal);
                  },
                ),
                SizedBox(height: spacing * 1.3),
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
                            switch (option['label']) {
                              case 'Logout':
                                _logout();
                                break;
                              case 'My Account':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MyAccount(),
                                  ),
                                ).then((_) {
                                  if (mounted) {
                                    context.read<ProfileBloc>().add(
                                      LoadProfileData(),
                                    );
                                  }
                                });
                                break;
                              case 'My interview videos':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MyInterviewVideos(),
                                  ),
                                );
                                break;
                              case 'Watchlist':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WatchListPage(),
                                  ),
                                );
                                break;
                              case 'My Jobs':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AppliedJobsPage(),
                                  ),
                                );
                                break;
                              default:
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
      width: iconSize * 1.4,
      height: iconSize * 1.4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 1),
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
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Row(
          children: [
            Icon(icon, size: size.width * 0.06),
            SizedBox(width: size.width * 0.04),
            Text(
              label,
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
