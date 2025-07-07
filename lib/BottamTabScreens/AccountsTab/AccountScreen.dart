import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/MyAccount.dart';
import 'package:sk_loginscreen1/BottamTabScreens/AccountsTab/MyInterviewVid/MyInterviewVideos.dart';
import 'package:sk_loginscreen1/Pages/bottombar.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';
import '../../Utilities/LoginUserApi.dart';

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
    context.read<NavigationBloc>().add(GobackToLoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final double iconSize = media.width * 0.065;
    final double profileSize = media.width * 0.37;
    final double spacing = media.height * 0.015;
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
                Container(
                  width: profileSize,
                  height: profileSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF005E6A),
                      width: 1,
                    ),
                  ),
                  child: const ClipOval(
                    child: Image(
                      image: AssetImage('assets/portrait.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: spacing * 1.7),
                Text(
                  "Jon",
                  style: TextStyle(
                    fontSize: media.width * 0.05,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF005E6A),
                  ),
                ),
                SizedBox(height: spacing * 0.3),
                Text(
                  "21 years old",
                  style: TextStyle(
                    fontSize: media.width * 0.04,
                    color: const Color(0xFF6A8E92),
                  ),
                ),
                SizedBox(height: spacing * 1.3),
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isMyAccount = option["label"] == 'My Account';
                      final interviewVideos =
                          option["label"] == "My interview videos";
                      return _AccountOption(
                        icon: option['icon'] as IconData,
                        label: option['label'] as String,
                        isSelected: selectedOptionIndex == index,
                        onTap: () {
                          setState(() {
                            selectedOptionIndex = index;
                          });
                          if (index == 6) {
                            _logout();
                          } else if (isMyAccount) {
                            context.read<NavigationBloc>().add(
                              GoToMyAccountScreen(),
                            );
                          } else if (interviewVideos) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MyInterviewVideos(),
                              ),
                            );
                          }
                          Future.delayed(const Duration(milliseconds: 50), () {
                            if (mounted) {
                              setState(() {
                                selectedOptionIndex = -1;
                              });
                            }
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
    final selectedColor = const Color(0xFF007B84);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : const Color(0xFF003840),
              size: size.width * 0.06,
            ),
            SizedBox(width: size.width * 0.04),
            Text(
              label,
              style: TextStyle(
                fontSize: size.width * 0.045,
                color: isSelected ? selectedColor : const Color(0xFF003840),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
