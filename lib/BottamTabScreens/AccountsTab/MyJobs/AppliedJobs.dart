import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Appliedjobs extends StatelessWidget {
  const Appliedjobs({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(
            color: Color(0xFF003840),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF003840)),
      ),
      body:  Center(
        child: Text(
          "No jobs applied yet",
          style: TextStyle(color: Colors.grey),
        ),
      )
    );
  }
}
