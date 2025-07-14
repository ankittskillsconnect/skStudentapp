import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sk_loginscreen1/blocpage/bloc_event.dart';
import 'package:sk_loginscreen1/blocpage/bloc_logic.dart';
import 'package:sk_loginscreen1/blocpage/bloc_state.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;
    final iconSize = screenWidth * 0.06;
    final textSize = screenWidth * 0.030;
    final navBarHeight = screenHeight * 0.095;

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is NavigateToJobSecreen2) {
          currentIndex = 1;
        } else if (state is NavigateToInterviewScreen) {
          currentIndex = 2;
        } else if (state is NavigateToContactsScreen) {
          currentIndex = 3;
        } else if (state is NavigateToAccountScreen) {
          currentIndex = 4;
        } else if (state is NavigateToHomeScreen || state is NavigateToHomeScreen2) {
          currentIndex = 0;
        }

        return Container(
          height: navBarHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
            ),
          ),
          child: Row(
            children: [
              _buildNavItem(context, currentIndex, 0, Icons.home_outlined, 'Home', () {
                context.read<NavigationBloc>().add(GotoHomeScreen2());
              }, iconSize, textSize, isFirst: true),
              _buildNavItem(context, currentIndex, 1, Icons.work_outline_rounded, 'Jobs', () {
                context.read<NavigationBloc>().add(GotoJobScreen2());
              }, iconSize, textSize),
              _buildNavItem(context, currentIndex, 2, Icons.airplay_outlined, 'Interview', () {
                context.read<NavigationBloc>().add(GoToInterviewScreen2());
              }, iconSize, textSize),
              _buildNavItem(context, currentIndex, 3, Icons.contacts_outlined, 'Contacts', () {
                context.read<NavigationBloc>().add(GoToContactsScreen2());
              }, iconSize, textSize),
              _buildNavItem(context, currentIndex, 4, Icons.account_circle_outlined, 'Account', () {
                context.read<NavigationBloc>().add(GoToAccountScreen2());
              }, iconSize, textSize, isLast: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      int currentIndex,
      int itemIndex,
      IconData icon,
      String label,
      VoidCallback onTap,
      double iconSize,
      double textSize, {
        bool isFirst = false,
        bool isLast = false,
      }) {
    final isSelected = currentIndex == itemIndex;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: isSelected
              ? EdgeInsets.only(
            left: isFirst ? 8 : 0,
            right: isLast ? 8 : 0,
          )
              : EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: isSelected
              ? BoxDecoration(
            color: const Color(0xFF006D77),
            borderRadius: BorderRadius.circular(16),
          )
              : const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: isSelected ? Colors.white : const Color(0xFF006D77),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF006D77),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
