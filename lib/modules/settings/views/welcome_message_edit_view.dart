import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../controllers/auto_capture_controller.dart';

class WelcomeMessageEditView extends StatefulWidget {
  const WelcomeMessageEditView({super.key});

  @override
  State<WelcomeMessageEditView> createState() => _WelcomeMessageEditViewState();
}

class _WelcomeMessageEditViewState extends State<WelcomeMessageEditView> {
  late final AutoCaptureController controller;
  late final TextEditingController textController;
  late final Worker _listener;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AutoCaptureController>();
    controller.initializeWelcomeMessage();
    textController = TextEditingController(text: controller.tempMessageText.value);

    // Sync input text field with AI regeneration or external state changes
    _listener = ever<String>(controller.tempMessageText, (val) {
      if (textController.text != val) {
        textController.text = val;
      }
    });
  }

  @override
  void dispose() {
    _listener.dispose();
    textController.dispose();
    super.dispose();
  }

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
          'Welcome Message',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1: Blue Info Warning Card
                    _buildInfoCard(),
                    SizedBox(height: 16.h),

                    // Section 2: Message Input Field Box
                    _buildMessageInputSection(),
                    SizedBox(height: 16.h),

                    // Section 3: Tone Selector pills
                    _buildToneSelectorSection(),
                    SizedBox(height: 12.h),

                    // Regenerate with AI button
                    _buildRegenerateButton(),
                    SizedBox(height: 16.h),

                    // Section 4: Live SMS Preview Mockup card
                    _buildPreviewSection(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // Bottom Save button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
              child: AppButton(
                text: 'Save Message',
                backgroundColor: AppColors.primary,
                onPressed: () {
                  controller.saveWelcomeMessage();
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: const Color(0xFFEFF6FF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFBFDBFE),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFF1D4ED8),
            size: 18.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'This message is automatically sent when someone texts your Chesera number for the first time. Make it warm and welcoming!',
              style: GoogleFonts.inter(
                color: const Color(0xFF1D4ED8),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message',
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.38,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: 150.h,
          padding: EdgeInsets.all(12.r),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1.5,
                color: Color(0xFF2563EB),
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: controller.updateMessageText,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    final count = controller.characterCount.value;
                    return Text(
                      '$count/160',
                      style: GoogleFonts.inter(
                        color: count > 160 ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToneSelectorSection() {
    final tones = ['Professional', 'Friendly', 'Casual'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tone',
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.38,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: tones.map((tone) {
            return Expanded(
              child: Obx(() {
                final isSelected = controller.currentTone.value == tone;
                final bgColor = isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8F9FC);
                final borderColor = isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0);
                final textColor = isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B);

                return GestureDetector(
                  onTap: () => controller.setTone(tone),
                  child: Container(
                    margin: EdgeInsets.only(right: tone != tones.last ? 8.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    decoration: ShapeDecoration(
                      color: bgColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: borderColor),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                    ),
                    child: Text(
                      tone,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: textColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                  ),
                );
              }),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRegenerateButton() {
    return GestureDetector(
      onTap: controller.regenerateWithAI,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFF2563EB),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              color: const Color(0xFF2563EB),
              size: 20.r,
            ),
            SizedBox(width: 6.w),
            Text(
              ' Regenerate with AI',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF2563EB),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            height: 1.38,
          ),
        ),
        SizedBox(height: 10.h),
        Center(
          child: Container(
            width: 280.w,
            padding: EdgeInsets.all(12.r),
            decoration: ShapeDecoration(
              color: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 32,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.r),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2C2C2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chesera ${controller.cheseraNumber}',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF8E8E93),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Obx(() {
                        final text = controller.tempMessageText.value;
                        final displayText = text.length > 76
                            ? '${text.substring(0, 76)}...'
                            : text;
                        return Text(
                          displayText,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Delivered',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF636366),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
