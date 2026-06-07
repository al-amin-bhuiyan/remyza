import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Privacy Policy',
          style: TextStyle(
            color: const Color(0xFF021649),
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
            _buildPolicySection(
              title: '1. Information We Collect',
              content:
                  'We collect information you provide directly to us, such as when you create an account, add contacts, or communicate through our platform. This includes your name, email address, phone number, and business information. We also collect SMS message data that flows through our platform to facilitate lead management.',
            ),
            SizedBox(height: 24.h),
            _buildPolicySection(
              title: '2. How We Use Information',
              content:
                  'We use the information we collect to operate, maintain, and provide the features and functionality of the Service. This includes analyzing lead conversations to generate AI-powered smart replies and customized follow-up strategies.',
            ),
            SizedBox(height: 24.h),
            _buildPolicySection(
              title: '3. Data Security & Storage',
              content:
                  'We use industry-standard security measures, including encryption and secure servers, to safeguard your database and account credentials. No method of transmission over the Internet is 100% secure, but we take all viable precautions.',
            ),
            SizedBox(height: 24.h),
            _buildPolicySection(
              title: '4. Third-Party Sharing',
              content:
                  'We do not sell or trade your personal or lead data to third parties. We may share information with trusted service providers who assist us in operating our platform, provided they agree to keep this information confidential.',
            ),
            SizedBox(height: 24.h),
            _buildPolicySection(
              title: '5. Your Rights and Choices',
              content:
                  'You have full control over your account details. You can update your profile information, manage communication preferences, or completely delete your account at any time within the Help & Support interface.',
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Left blue vertical accent indicator
            Container(
              width: 3.w,
              height: 20.h,
              decoration: ShapeDecoration(
                color: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: Text(
            content,
            style: TextStyle(
              color: const Color(0xFF4B5563),
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ),
      ],
    );
  }
}
