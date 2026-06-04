import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatCard extends StatelessWidget {
  final String iconPath;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.iconPath,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0xFFE7E7F4),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0x4CC4C5D9),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: SvgPicture.asset(
              iconPath,
              width: 24.w,
              height: 24.w,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF021649),
              fontSize: 24.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.33,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF434656),
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }
}

