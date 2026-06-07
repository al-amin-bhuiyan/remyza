import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/auto_capture_controller.dart';

class AutoCaptureSimulationView extends GetView<AutoCaptureController> {
  const AutoCaptureSimulationView({super.key});

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
                    // Card 1: Your Chesera Number
                    _buildCheseraNumberCard(),
                    SizedBox(height: 16.h),

                    // Card 2: Simulated Incoming SMS
                    _buildSimulatedSmsCard(),
                    SizedBox(height: 16.h),

                    // Card 3: Auto-Capture Pipeline Timeline
                    _buildPipelineCard(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
              child: Obx(() => AppButton(
                    text: controller.isSimulating.value
                        ? 'Simulating...'
                        : 'Run Simulation  →',
                    backgroundColor: AppColors.primary,
                    isLoading: controller.isSimulating.value,
                    onPressed: () => controller.startSimulation(context),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheseraNumberCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
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
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              height: 1.50,
              letterSpacing: 0.80,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone_rounded,
                    color: const Color(0xFF7C3AED),
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    controller.cheseraNumber,
                    style: GoogleFonts.cousine(
                      color: const Color(0xFF7C3AED),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: controller.copyNumberToClipboard,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF3E8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.content_copy_rounded,
                        color: const Color(0xFF7C3AED),
                        size: 12.r,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Copy',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7C3AED),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedSmsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
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
            'SIMULATED INCOMING SMS',
            style: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              height: 1.50,
              letterSpacing: 0.80,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF3E8FF),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      color: Color(0xFFE9D5FF),
                    ),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: const Color(0xFF7C3AED),
                  size: 16.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '+1 (555) 987-6543',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFF7ED),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                          ),
                          child: Text(
                            'Unknown',
                            style: GoogleFonts.inter(
                              color: const Color(0xFFF59E0B),
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.only(top: 8.h, left: 12.w, right: 12.w, bottom: 8.h),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                      ),
                      child: Text(
                        "Hi! I saw your website and I'm interested in learning more about your services.",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF334155),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Just now · via SMS',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFCBD5E1),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
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
            'Auto-Capture Pipeline',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() {
            final activeStep = controller.simulationStep.value;
            return Column(
              children: [
                _buildTimelineStep(
                  stepNum: 1,
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Message received',
                  description: 'Incoming SMS detected from test number',
                  isActive: activeStep >= 1,
                  isNextActive: activeStep >= 2,
                ),
                _buildTimelineStep(
                  stepNum: 2,
                  icon: Icons.person_outline_rounded,
                  title: 'Contact captured',
                  description: 'New contact added to your list',
                  isActive: activeStep >= 2,
                  isNextActive: activeStep >= 3,
                ),
                _buildTimelineStep(
                  stepNum: 3,
                  icon: Icons.bolt_outlined,
                  title: 'Lead created',
                  description: 'Added to Hot leads pipeline',
                  isActive: activeStep >= 3,
                  isNextActive: activeStep >= 4,
                ),
                _buildTimelineStep(
                  stepNum: 4,
                  icon: Icons.send_outlined,
                  title: 'Welcome message sent',
                  description: 'Auto-reply delivered successfully',
                  isActive: activeStep >= 4,
                  isNextActive: false,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required int stepNum,
    required IconData icon,
    required String title,
    required String description,
    required bool isActive,
    required bool isNextActive,
  }) {
    final circleBgColor = isActive ? const Color(0xFFF3E8FF) : const Color(0xFFF8F9FC);
    final circleBorderColor = isActive ? const Color(0xFFE9D5FF) : const Color(0xFFE2E8F0);
    final iconColor = isActive ? const Color(0xFF7C3AED) : const Color(0xFFCBD5E1);
    final titleColor = isActive ? const Color(0xFF0F172A) : const Color(0xFF94A3B8);
    final descColor = isActive ? const Color(0xFF64748B) : const Color(0xFFCBD5E1);
    final lineColor = isNextActive ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: ShapeDecoration(
                color: circleBgColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: circleBorderColor,
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 18.r,
              ),
            ),
            if (stepNum < 4)
              Container(
                width: 2.w,
                height: 16.h,
                color: lineColor,
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: titleColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.50,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: descColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                if (stepNum < 4) SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
