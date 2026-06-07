import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_tile.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
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
            _buildProfileCard(context),
            SizedBox(height: 24.h),
            // Account Section
            _buildSectionHeader('ACCOUNT'),
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.person_outline,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'Edit Profile',
                onTap: () {
                  context.push(AppRoutes.profile);
                },
              ),
              SettingsTile(
                icon: Icons.credit_card,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'My Plan',
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEFF6FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    'Pro',
                    style: TextStyle(
                      color: const Color(0xFF2563EB),
                      fontSize: 11.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onTap: () {
                  context.push(AppRoutes.myPlan);
                },
              ),
              SettingsTile(
                icon: Icons.chat_bubble_outline,
                iconColor: const Color(0xFF7C3AED),
                iconBgColor: const Color(0xFFF3E8FF),
                title: 'My SMS Number',
                subtitle: '+1 555-014...',
                onTap: () {
                  context.push(AppRoutes.smsNumber);
                },
              ),
              SettingsTile(
                icon: Icons.notifications_none,
                iconColor: const Color(0xFFD97706),
                iconBgColor: const Color(0xFFFFFBEB),
                title: 'Notifications',
                onTap: () {
                  context.push(AppRoutes.notificationPrefs);
                },
              ),
            
            ]),
            SizedBox(height: 24.h),
            // AI Section
            _buildSectionHeader('AI'),
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.auto_awesome,
                iconColor: const Color(0xFF7C3AED),
                iconBgColor: const Color(0xFFF3E8FF),
                title: 'AI Settings',
                onTap: () {
                  context.push(AppRoutes.aiSettings);
                },
              ),
              SettingsTile(
                icon: Icons.chat_outlined,
                iconColor: const Color(0xFF16A34A),
                iconBgColor: const Color(0xFFF0FDF4),
                title: 'Auto-Reply',
                trailing: Obx(() => Switch(
                  value: controller.isAutoReplyEnabled.value,
                  onChanged: controller.toggleAutoReply,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF22C55E),
                )),
                onTap: () {
                  controller.toggleAutoReply(!controller.isAutoReplyEnabled.value);
                },
              ),
              SettingsTile(
                icon: Icons.bolt_outlined,
                iconColor: const Color(0xFF7C3AED),
                iconBgColor: const Color(0xFFF3E8FF),
                title: 'Auto-Capture',
                onTap: () {
                  context.push(AppRoutes.autoCapture);
                },
              ),
            ]),
            SizedBox(height: 24.h),
            // Support Section
            _buildSectionHeader('SUPPORT'),
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.help_outline,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'Help Center',
                onTap: () {
                  context.push(AppRoutes.helpSupport);
                },
              ),
              SettingsTile(
                icon: Icons.phone_outlined,
                iconColor: const Color(0xFF16A34A),
                iconBgColor: const Color(0xFFF0FDF4),
                title: 'Contact Support',
                onTap: () {
                  context.push(AppRoutes.sendEmail);
                },
              ),
            ]),
            SizedBox(height: 24.h),
            // Legal Section
            _buildSectionHeader('LEGAL'),
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'Privacy Policy',
                onTap: () {
                  context.push(AppRoutes.privacyPolicy);
                },
              ),
              SettingsTile(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF8F9FC),
                title: 'Terms of Service',
                onTap: () {
                  context.push(AppRoutes.termsOfService);
                },
              ),
            ]),
            SizedBox(height: 24.h),
            // Log Out Section
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.logout,
                iconColor: const Color(0xFFEF4444),
                iconBgColor: const Color(0xFFFEF2F2),
                title: 'Log Out',
                isDestructive: true,
                onTap: () {},
              ),
            ]),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
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
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          const AppAvatar(
            fullName: 'Alex Johnson',
            radius: 28,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 16.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'alex@example.com',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
          
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20.r, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF021649),
          fontSize: 16.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.80,
        ),
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
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
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
