import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remyza/core/constants/custom_assets.dart';
import 'follow_up_item.dart';

class FollowUpSection extends StatelessWidget {
  const FollowUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow-up Due Today',
            style: TextStyle(
              color: const Color(0xFF021649),
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.56,
            ),
          ),
          SizedBox(height: 16.h),
          Column(
            spacing: 12.h,
            children: const [
              FollowUpItem(
                iconPath: CustomAssets.followUpDueToday1,
                title: 'Sarah Jenkins',
                subtitle: 'Call at 2:00 PM',
              ),
              FollowUpItem(
                iconPath: CustomAssets.followUpDueToday1,
                title: 'TechCorp Inc.',
                subtitle: 'Demo Presentation',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
