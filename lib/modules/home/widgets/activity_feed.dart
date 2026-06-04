import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remyza/core/constants/custom_assets.dart';
import 'feed_item.dart';

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              color: const Color(0xFF021649),
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              height: 1.56,
            ),
          ),
          SizedBox(height: 12.h),
          Column(
            spacing: 8.h,
            children: const [
              FeedItem(
                imagePath: CustomAssets.recentActivityProfile1,
                name: 'Alex Mercer',
                time: 'Just now',
                message: "I'm interested in learning more about the pricing plans.",
              ),
              FeedItem(
                imagePath: CustomAssets.recentActivityProfile2,
                name: 'Sarah Jenkins',
                time: '12 mins ago',
                message: "Thanks, the AI response was perfectly timed!",
              ),
              FeedItem(
                imagePath: CustomAssets.recentActivitySystemAutoReply,
                name: 'System Auto-Reply',
                time: '1 hr ago',
                message: "Follow-up sequence initiated for 5 cold leads.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
