import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remyza/core/constants/custom_assets.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Row(
        spacing: 8.w,
        children: const [
          StatCard(
            iconPath: CustomAssets.totalLeads,
            value: '2,405',
            label: 'Total Leads',
          ),
          StatCard(
            iconPath: CustomAssets.messageSent,
            value: '18.2k',
            label: 'Messages Sent',
          ),
          StatCard(
            iconPath: CustomAssets.replies,
            value: '843',
            label: 'Replies',
          ),
          StatCard(
            iconPath: CustomAssets.activityLeads,
            value: '126',
            label: 'Active Leads',
          ),
        ],
      ),
    );
  }
}
