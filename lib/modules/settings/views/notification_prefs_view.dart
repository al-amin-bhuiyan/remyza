import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/notifications_pref_controller.dart';

class NotificationPrefsView extends GetView<NotificationsPrefController> {
  const NotificationPrefsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if all options are enabled to determine the master switch value
    bool isAllToggled(NotificationsPrefController c) {
      return c.isPushEnabled.value &&
          c.isEmailEnabled.value &&
          c.isSmsEnabled.value &&
          c.isLeadAlertsEnabled.value &&
          c.isWeeklyDigestEnabled.value;
    }

    void toggleAll(NotificationsPrefController c, bool value) {
      c.togglePush(value);
      c.toggleEmail(value);
      c.toggleSms(value);
      c.toggleLeadAlerts(value);
      c.toggleWeeklyDigest(value);
    }

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
          'Notifications',
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
            // All Notifications master card
            Obx(() {
              final masterValue = isAllToggled(controller);
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
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Notifications',
                            style: TextStyle(
                              color: const Color(0xFF0F172A),
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Enable or disable all notifications',
                            style: TextStyle(
                              color: const Color(0xFF64748B),
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: masterValue,
                      onChanged: (value) => toggleAll(controller, value),
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF22C55E),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 24.h),

            // Notification options sublist
            Text(
              'Notification preferences',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),

            Container(
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
                children: [
                  Obx(() => _buildNotificationRow(
                        title: 'Push Notifications',
                        description: 'Receive real-time push updates on your device.',
                        value: controller.isPushEnabled.value,
                        onChanged: controller.togglePush,
                      )),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Obx(() => _buildNotificationRow(
                        title: 'Email Alerts',
                        description: 'Receive digests and status updates.',
                        value: controller.isEmailEnabled.value,
                        onChanged: controller.toggleEmail,
                      )),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Obx(() => _buildNotificationRow(
                        title: 'SMS Text Alerts',
                        description: 'Receive critical updates via SMS.',
                        value: controller.isSmsEnabled.value,
                        onChanged: controller.toggleSms,
                      )),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Obx(() => _buildNotificationRow(
                        title: 'Instant Lead Alerts',
                        description: 'Get notified immediately when a new lead is captured.',
                        value: controller.isLeadAlertsEnabled.value,
                        onChanged: controller.toggleLeadAlerts,
                      )),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  Obx(() => _buildNotificationRow(
                        title: 'Weekly Performance Digest',
                        description: 'Receive weekly summarised performance reports.',
                        value: controller.isWeeklyDigestEnabled.value,
                        onChanged: controller.toggleWeeklyDigest,
                      )),
                ],
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationRow({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
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
}
