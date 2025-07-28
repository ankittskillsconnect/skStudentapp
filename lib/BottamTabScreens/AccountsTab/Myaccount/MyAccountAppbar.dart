import 'package:flutter/material.dart';

class AccountAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _circleIconButton(
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Text(
              "My Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF003840),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _circleIconButton(
                  icon: Icons.notifications_none_outlined,
                  onTap: () {
                  },
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFBCD8DB)),
        ),
        child: Icon(icon, color: const Color(0xFF003840), size: 25),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}