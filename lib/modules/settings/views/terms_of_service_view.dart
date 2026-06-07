import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

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
          'Terms of Service',
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
            _buildSection(
              title: '1. Acceptance of Terms',
              content:
                  'By accessing or using Chesera, you agree to be bound by these Terms of Service and our Privacy Policy. If you disagree with any part of the terms, you may not access the service. These terms apply to all visitors, users, and others who access or use the service.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: '2. Use of Service',
              content:
                  'You may use Chesera for lawful purposes only. You agree not to use the service in any way that violates applicable laws or regulations, or that could harm or impair the service or interfere with any other party\'s use of the service.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: '3. SMS Messaging Compliance',
              content:
                  'You are solely responsible for ensuring your SMS messaging activities comply with all applicable laws, including the Telephone Consumer Protection Act (TCPA), CAN-SPAM Act, and applicable state laws. You must obtain proper consent before messaging any contacts. Chesera is not liable for your compliance failures.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: '4. Prohibited Uses',
              content:
                  'You may not use Chesera to send spam, unsolicited messages, or illegal content. You may not impersonate any person or entity, or falsely state your affiliation with a person or entity. You may not engage in any conduct that restricts or inhibits anyone\'s use of the service.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: '5. Account Termination',
              content:
                  'We may terminate or suspend your account immediately, without prior notice or liability, for any reason, including breach of these Terms. Upon termination, your right to use the service will cease. All provisions of the Terms shall survive termination.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: '6. Limitation of Liability',
              content:
                  'Chesera shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, or business opportunities. Our total liability shall not exceed the amount paid by you to Chesera in the twelve months preceding the claim.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: '7. Governing Law',
              content:
                  'These Terms shall be governed by the laws of the State of California, without regard to conflict of law provisions. Any disputes arising under these terms shall be subject to the exclusive jurisdiction of the courts located in San Francisco County, California.',
            ),
            SizedBox(height: 24.h),
            _buildSection(
              title: '8. Changes to Terms',
              content:
                  'We reserve the right to modify these terms at any time. We will provide notice of significant changes by updating the \'Last updated\' date and sending an email notification. Your continued use of the service after changes constitutes acceptance of the new terms.',
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
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
