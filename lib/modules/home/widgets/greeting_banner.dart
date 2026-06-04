import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GreetingBanner extends StatelessWidget {
  final String title;

  const GreetingBanner({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF0462C7),
          fontSize: 20.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          height: 1.50,
        ),
      ),
    );
  }
}

