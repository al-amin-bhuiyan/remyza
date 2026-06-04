import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentLeadsSection extends StatelessWidget {
  const RecentLeadsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lead Summary',
            style: TextStyle(
              color: const Color(0xFF021649),
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.56,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            spacing: 8.w,
            children: [
              Expanded(
                child: _buildLeadBox(
                  tag: 'HOT',
                  value: '24',
                  tagColor: const Color(0xFF93000A),
                  tagBgColor: const Color(0xFFFFDAD6),
                ),
              ),
              Expanded(
                child: _buildLeadBox(
                  tag: 'WARM',
                  value: '58',
                  tagColor: const Color(0xFF812800),
                  tagBgColor: const Color(0xFFFFDBCF),
                ),
              ),
              Expanded(
                child: _buildLeadBox(
                  tag: 'COLD',
                  value: '44',
                  tagColor: const Color(0xFF0035BE),
                  tagBgColor: const Color(0xFFDDE1FF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeadBox({
    required String tag,
    required String value,
    required Color tagColor,
    required Color tagBgColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFC4C5D9)),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: ShapeDecoration(
              color: tagBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999.r),
              ),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: tagColor,
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
                letterSpacing: 0.30,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF021649),
              fontSize: 24.sp,
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w700,
              height: 1.33,
              letterSpacing: -0.24,
            ),
          ),
        ],
      ),
    );
  }
}

