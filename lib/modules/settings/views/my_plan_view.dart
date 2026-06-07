import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class MyPlanView extends StatelessWidget {
  const MyPlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Center(
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: ShapeDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14.r,
                  color: const Color(0xFF021649),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'My Plan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActivePlanCard(),
            SizedBox(height: 16.h),
            _buildUsageCard(),
            SizedBox(height: 16.h),
            _buildFeaturesCard(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2.w, color: const Color(0xFF2563EB)),
          borderRadius: BorderRadius.circular(20.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pro',
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 28.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                '\$79 / month',
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 22.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Renews on June 1, 2026',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: ShapeDecoration(
                color: const Color(0xFFF0FDF4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Active',
                style: TextStyle(
                  color: const Color(0xFF22C55E),
                  fontSize: 11.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This Month's Usage",
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          _buildUsageItem(
            title: 'Messages Sent',
            valueText: '1,240 / 2,000',
            progress: 1240 / 2000,
            color: const Color(0xFF2563EB),
            backgroundColor: const Color(0xFFEFF6FF),
          ),
          SizedBox(height: 16.h),
          _buildUsageItem(
            title: 'Leads Captured',
            valueText: '247 / 500',
            progress: 247 / 500,
            color: const Color(0xFF22C55E),
            backgroundColor: const Color(0xFFF0FDF4),
          ),
          SizedBox(height: 16.h),
          _buildUsageItem(
            title: 'AI Replies',
            valueText: '864 / 1,500',
            progress: 864 / 1500,
            color: const Color(0xFF7C3AED),
            backgroundColor: const Color(0xFFF3E8FF),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem({
    required String title,
    required String valueText,
    required double progress,
    required Color color,
    required Color backgroundColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF475569),
                fontSize: 13.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              valueText,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8.h,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesCard() {
    final features = [
      'Unlimited contacts',
      'AI-powered auto-reply',
      'CSV bulk import',
      'Lead scoring & categorization',
      'Custom welcome messages',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Included Features',
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          ...features.map((feature) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF0FDF4),
                        shape: CircleBorder(),
                      ),
                      child: Icon(
                        Icons.check,
                        color: const Color(0xFF22C55E),
                        size: 12.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          color: const Color(0xFF475569),
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
