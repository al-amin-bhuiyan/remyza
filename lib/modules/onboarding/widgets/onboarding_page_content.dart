import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import 'onboarding_content_model.dart';
class OnboardingPageContent extends StatelessWidget {
  final OnboardingContentModel pageData;
  const OnboardingPageContent({super.key, required this.pageData});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30.h),
        Container(
          width: double.infinity,
          height: 468.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(pageData.imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Column(
            children: [
              Text(
                pageData.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                pageData.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}
