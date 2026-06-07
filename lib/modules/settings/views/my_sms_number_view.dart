import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MySmsNumberView extends StatelessWidget {
  const MySmsNumberView({super.key});

  final String phoneNumber = '+1 (555) 014-7382';

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
          'My SMS Number',
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
            // Dedicated Number Display Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Icon frame on top
                  Container(
                    width: 60.r,
                    height: 60.r,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE8ECFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Icon(
                      Icons.phone_android_rounded,
                      color: const Color(0xFF0249AA),
                      size: 26.r,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Phone Number & Copy row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        phoneNumber,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF0249AA),
                          fontSize: 21.sp,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: phoneNumber));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: const Color(0xFF0249AA),
                                    size: 20.r,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'SMS number copied to clipboard!',
                                    style: TextStyle(
                                      color: const Color(0xFF0249AA),
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color(0xFFEFF6FF),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(16.r),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          width: 34.r,
                          height: 34.r,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE8ECFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Icon(
                            Icons.copy_rounded,
                            color: const Color(0xFF0249AA),
                            size: 16.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Active Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF0FDF4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        color: const Color(0xFF22C55E),
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Detail description
                  Text(
                    'This is your dedicated Chesera SMS number. Share it to automatically capture leads.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // How it Works Section
            Text(
              'How it works',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),

            // Steps
            _buildStepCard(
              stepNumber: '1',
              title: 'Share your number',
              description:
                  'Put your Chesera number on your website, social bio, or business card.',
            ),
            SizedBox(height: 12.h),
            _buildStepCard(
              stepNumber: '2',
              title: 'Contacts text you',
              description:
                  'When someone texts your number, they\'re automatically added to your contact list.',
            ),
            SizedBox(height: 12.h),
            _buildStepCard(
              stepNumber: '3',
              title: 'AI handles the rest',
              description:
                  'Your AI assistant sends the welcome message and creates a lead — all automatically.',
            ),
            SizedBox(height: 24.h),

            // QR Code section card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'QR Code',
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: 140.r,
                    height: 140.r,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF8F9FC),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2.r,
                          color: const Color(0xFFE2E8F0),
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        color: const Color(0xFF0249AA),
                        size: 100.r,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.download_done_rounded,
                                color: const Color(0xFF0249AA),
                                size: 20.r,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'QR Code download started...',
                                style: TextStyle(
                                  color: const Color(0xFF0249AA),
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFFEFF6FF),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16.r),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      'Download QR',
                      style: TextStyle(
                        color: const Color(0xFF0249AA),
                        fontSize: 13.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Change Number Button
            GestureDetector(
              onTap: () => _showChangeNumberDialog(context),
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.r,
                      color: const Color(0xFFEF4444),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Change Number',
                    style: TextStyle(
                      color: const Color(0xFFEF4444),
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
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
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: const ShapeDecoration(
              color: Color(0xFF0249AA),
              shape: CircleBorder(),
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChangeNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Change SMS Number'),
          content: const Text(
            'To change your dedicated SMS number, please contact support or select a different area code. Changing your number might disrupt active lead captures.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF0249AA),
                          size: 20.r,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Your request for number change is sent to our support.',
                          style: TextStyle(
                            color: const Color(0xFF0249AA),
                            fontSize: 13.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFFEFF6FF),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16.r),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Request Change',
                style: TextStyle(color: Color(0xFF0249AA)),
              ),
            ),
          ],
        );
      },
    );
  }
}
