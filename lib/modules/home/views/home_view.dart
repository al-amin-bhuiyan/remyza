import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';

import '../widgets/greeting_banner.dart';
import '../widgets/stats_row.dart';
import '../widgets/recent_leads_section.dart';
import '../widgets/activity_feed.dart';
import '../widgets/follow_up_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 48.h, bottom: 120.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingBanner(title: 'Good Evening, Alex'),
              SizedBox(height: 24.h),
              const StatsRow(),
              SizedBox(height: 32.h),
              const RecentLeadsSection(),
              SizedBox(height: 32.h),
              const ActivityFeed(),
              SizedBox(height: 32.h),
              const FollowUpSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80.h), // Above nav bar
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.importContacts),
              icon: Icon(Icons.upload_file, color: Colors.white, size: 16.r),
              label: Text(
                'Upload Contacts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0249AA),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999.r),
                ),
                elevation: 4,
              ),
            ),
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.contactForm),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0249AA),
                shape: const CircleBorder(),
                padding: EdgeInsets.all(16.w),
                elevation: 4,
                minimumSize: Size(52.w, 52.w),
              ),
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
