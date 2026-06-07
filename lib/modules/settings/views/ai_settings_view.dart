import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/settings_controller.dart';

class AISettingsView extends GetView<SettingsController> {
  const AISettingsView({super.key});

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
          'AI Settings',
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
            // Reply Tone Section
            Text(
              'Reply Tone',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10.h),
            Obx(() => Row(
              children: [
                Expanded(
                  child: _buildToneCard(
                    toneName: 'Professional',
                    emoji: '👔',
                    description: 'Formal and business-like',
                    isSelected: controller.selectedTone.value == 'Professional',
                    onTap: () => controller.setSelectedTone('Professional'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildToneCard(
                    toneName: 'Friendly',
                    emoji: '👋',
                    description: 'Warm and personable',
                    isSelected: controller.selectedTone.value == 'Friendly',
                    onTap: () => controller.setSelectedTone('Friendly'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildToneCard(
                    toneName: 'Casual',
                    emoji: '⚡',
                    description: 'Relaxed and conversational',
                    isSelected: controller.selectedTone.value == 'Casual',
                    onTap: () => controller.setSelectedTone('Casual'),
                  ),
                ),
              ],
            )),
            SizedBox(height: 24.h),

            // Auto-Reply Toggle Card
            Obx(() => _buildSwitchCard(
              title: 'Auto-Reply',
              description: 'AI replies automatically to all messages',
              value: controller.isAutoReplyEnabled.value,
              icon: Icons.chat_outlined,
              onChanged: controller.toggleAutoReply,
            )),
            SizedBox(height: 24.h),

            // Reply Speed List Card
            Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          size: 20.r,
                          color: const Color(0xFF0F172A),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Reply Speed',
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Obx(() => Column(
                    children: [
                      _buildSpeedOption(
                        speedName: 'Instant',
                        description: 'Reply within seconds',
                        isSelected: controller.selectedReplySpeed.value == 'Instant',
                        onTap: () => controller.setSelectedReplySpeed('Instant'),
                      ),
                      _buildSpeedOption(
                        speedName: 'Within 1 min',
                        description: 'More natural timing',
                        isSelected: controller.selectedReplySpeed.value == 'Within 1 min',
                        onTap: () => controller.setSelectedReplySpeed('Within 1 min'),
                        hasBorder: true,
                      ),
                      _buildSpeedOption(
                        speedName: 'Within 5 min',
                        description: 'Relaxed response time',
                        isSelected: controller.selectedReplySpeed.value == 'Within 5 min',
                        onTap: () => controller.setSelectedReplySpeed('Within 5 min'),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // AI Personality Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
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
                    'AI Personality',
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(() => SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF0249AA),
                      inactiveTrackColor: const Color(0xFFE2E8F0),
                      thumbColor: const Color(0xFF0249AA),
                      overlayColor: const Color(0xFF0249AA).withValues(alpha: 0.12),
                      trackHeight: 4.h,
                    ),
                    child: Slider(
                      value: controller.aiPersonality.value,
                      onChanged: controller.setAiPersonality,
                    ),
                  )),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Formal',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Conversational',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Follow-up Automation Toggle Card
            Obx(() => _buildSwitchCard(
              title: 'Follow-up Automation',
              description: 'Auto-send follow-ups to cold leads',
              value: controller.isFollowUpAutomationEnabled.value,
              icon: Icons.sync_alt_rounded,
              onChanged: controller.toggleFollowUpAutomation,
            )),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildToneCard({
    required String toneName,
    required String emoji,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFE8EFFF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2.r,
              color: isSelected ? const Color(0xFF0249AA) : const Color(0xFFE2E8F0),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 22.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              toneName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? const Color(0xFF0249AA) : const Color(0xFF0F172A),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Expanded(
              child: Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 10.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String description,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE8EFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF0249AA),
                    size: 18.r,
                  ),
                ),
                SizedBox(width: 12.w),
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
                      SizedBox(height: 2.h),
                      Text(
                        description,
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 11.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedOption({
    required String speedName,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
    bool hasBorder = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: hasBorder
            ? const BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    width: 1,
                    color: Color(0xFFF1F5F9),
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: ShapeDecoration(
                color: isSelected ? const Color(0xFF0249AA) : Colors.transparent,
                shape: CircleBorder(
                  side: BorderSide(
                    width: 2.r,
                    color: isSelected ? const Color(0xFF0249AA) : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  speedName,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF0249AA) : const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
