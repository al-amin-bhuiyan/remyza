import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/auto_capture_controller.dart';

class AutoCaptureView extends GetView<AutoCaptureController> {
  const AutoCaptureView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
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
          'Auto Capture',
          style: GoogleFonts.nunitoSans(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
                child: Column(
                  children: [
                    // Card 1: Auto-Capture Incoming Leads Graphic & Text
                    _buildMainFeatureCard(),
                    SizedBox(height: 16.h),

                    // Card 2: How it works
                    _buildHowItWorksCard(),
                    SizedBox(height: 16.h),

                    // Card 3: Your Chesera Number
                    _buildCheseraNumberCard(),
                    SizedBox(height: 16.h),

                    // Card 4: Auto-create Lead Switch
                    _buildAutoCreateLeadCard(),
                    SizedBox(height: 16.h),

                    // Card 5: Welcome Message Detail
                    _buildWelcomeMessageCard(context),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
              child: AppButton(
                text: 'Test Auto-Capture',
                backgroundColor: AppColors.primary,
                onPressed: () => context.push(AppRoutes.autoCaptureSimulation),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainFeatureCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Conic Concentric rings + Phone Graphic
          SizedBox(
            width: 110.r,
            height: 110.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Ring 1
                Container(
                  width: 110.r,
                  height: 110.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.05),
                      width: 1.r,
                    ),
                  ),
                ),
                // Ring 2
                Container(
                  width: 92.6.r,
                  height: 92.6.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
                      width: 1.r,
                    ),
                  ),
                ),
                // Ring 3
                Container(
                  width: 75.3.r,
                  height: 75.3.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                      width: 1.r,
                    ),
                  ),
                ),
                // Innermost Circle
                Container(
                  width: 57.9.r,
                  height: 57.9.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0x307C3AED),
                      width: 2.r,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x1F7C3AED),
                        Color(0x107C3AED),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.phone_android_rounded,
                    color: const Color(0xFF7C3AED),
                    size: 24.r,
                  ),
                ),
                // Top Right Badge Icon
                Positioned(
                  right: 22.r,
                  top: 22.r,
                  child: Container(
                    width: 16.r,
                    height: 16.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C3AED),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.bolt,
                      color: Colors.white,
                      size: 11.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Auto-Capture Incoming Leads',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Anyone who texts your Chesera number gets automatically added as a contact and receives your welcome message.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFF1F5F9),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: const BoxDecoration(
              color: Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: const Color(0xFF7C3AED),
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How it works',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Share your Chesera number on your website, social media, or business card. When someone texts it, they're automatically captured as a lead in your dashboard.",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheseraNumberCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFF1F5F9),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR CHESERA NUMBER',
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.80,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.cheseraNumber,
                style: GoogleFonts.cousine(
                  color: const Color(0xFF7C3AED),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.38,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: controller.copyNumberToClipboard,
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.content_copy_rounded,
                        color: const Color(0xFF7C3AED),
                        size: 15.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      'Active',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF22C55E),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAutoCreateLeadCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFF1F5F9),
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Auto-create Lead',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Add contacts to your leads pipeline',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
                value: controller.autoCreateLead.value,
                activeTrackColor: const Color(0xFF22C55E),
                activeThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFE2E8F0),
                inactiveThumbColor: Colors.white,
                onChanged: controller.toggleAutoCreateLead,
              )),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessageCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.welcomeMessageEdit),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFF1F5F9),
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 6,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome Message',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0F172A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.43,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Obx(() => Text(
                        controller.welcomeMessage.value,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF64748B),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      )),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFF64748B),
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }
}
