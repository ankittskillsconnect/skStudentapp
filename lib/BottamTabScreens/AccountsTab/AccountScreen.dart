import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../ProfileLogic/ProfileEvent.dart';
import '../../ProfileLogic/ProfileLogic.dart';
import '../../ProfileLogic/ProfileState.dart';
import '../../Utilities/auth/LoginUserApi.dart';
import 'MyAccount.dart';
import 'MyInterviewVid/MyInterviewVideos.dart';
import '../../Pages/bottombar.dart';
import '../../blocpage/bloc_event.dart';
import '../../blocpage/bloc_logic.dart';
import '../../blocpage/bloc_state.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 0;
  int selectedOptionIndex = -1;

  final List<Map<String, dynamic>> options = [
    {"icon": Icons.person_outline, "label": "My Account"},
    {"icon": Icons.business_center_outlined, "label": "My Jobs"},
    {"icon": Icons.bookmark_add_outlined, "label": "Watchlist"},
    {"icon": Icons.account_balance_outlined, "label": "Campus Ambassador"},
    {"icon": Icons.ondemand_video_sharp, "label": "My interview videos"},
    {"icon": Icons.settings_outlined, "label": "Account Settings"},
    {"icon": Icons.logout, "label": "Logout"},
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileData());
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _logout() async {
    final loginService = loginUser();
    await loginService.clearToken();
    context.read<NavigationBloc>().add(GobackToLoginPage());
  }

  String _calculateAge(String dob) {
    try {
      final birthDate = DateFormat('dd, MMM yyyy').parse(dob);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return '$age years old';
    } catch (_) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final iconSize = media.width * 0.065;
    final profileSize = media.width * 0.37;
    final spacing = media.height * 0.015;

    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        if (state is NavigateToMyAccount) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MyAccount()),
          );
        }
      },
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
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF003840),
                      ),
                    ),
                    _iconCircle(icon: Icons.notifications_none, iconSize: iconSize),
                  ],
                ),
                SizedBox(height: media.height * 0.05),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is ProfileDataLoaded) {
                      return Column(
                        children: [
                          Container(
                            width: profileSize,
                            height: profileSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF005E6A), width: 1),
                            ),
                            child: ClipOval(
                              child: state.profileImage != null
                                  ? Image.file(state.profileImage!, fit: BoxFit.cover)
                                  : const Image(
                                image: AssetImage('assets/portrait.png'),
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
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                SizedBox(height: spacing * 1.3),
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final label = option["label"];

                      return _AccountOption(
                        icon: option['icon'] as IconData,
                        label: label,
                        isSelected: selectedOptionIndex == index,
                        onTap: () {
                          setState(() => selectedOptionIndex = index);

                          switch (label) {
                            case "Logout":
                              _logout();
                              break;
                            case "My Account":
                              context.read<NavigationBloc>().add(GoToMyAccountScreen());
                              break;
                            case "My interview videos":
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MyInterviewVideos()),
                              );
                              break;
                            default:
                              break;
                          }

                          Future.delayed(const Duration(milliseconds: 50), () {
                            if (mounted) setState(() => selectedOptionIndex = -1);
                          });
                        },
                      );
                    },
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
        border: Border.all(color: Colors.grey),
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
    final color = isSelected ? const Color(0xFF007B84) : const Color(0xFF003840);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Row(
          children: [
            Icon(icon, color: color, size: size.width * 0.06),
            SizedBox(width: size.width * 0.04),
            Text(
              label,
              style: TextStyle(
                fontSize: size.width * 0.045,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
