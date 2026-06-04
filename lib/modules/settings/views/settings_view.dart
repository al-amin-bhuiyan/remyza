import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_tile.dart';
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Soft background for contrast with white cards
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF021649),
            fontSize: 18,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildProfileCard(context),
            const SizedBox(height: 24),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEFF6FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Pro',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 11,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.chat_bubble_outline,
                iconColor: const Color(0xFF7C3AED),
                iconBgColor: const Color(0xFFF3E8FF),
                title: 'My SMS Number',
                subtitle: '+1 555-014...',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.notifications_none,
                iconColor: const Color(0xFFD97706),
                iconBgColor: const Color(0xFFFFFBEB),
                title: 'Notifications',
                trailing: Obx(() => Switch(
                  value: controller.isNotificationsEnabled.value,
                  onChanged: controller.toggleNotifications,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF22C55E),
                )),
                onTap: () {
                  controller.toggleNotifications(!controller.isNotificationsEnabled.value);
                },
              ),
              SettingsTile(
                icon: Icons.lock_outline,
                iconColor: const Color(0xFF16A34A),
                iconBgColor: const Color(0xFFF0FDF4),
                title: 'Privacy & Security',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            // AI Section
            _buildSectionHeader('AI'),
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.auto_awesome,
                iconColor: const Color(0xFF7C3AED),
                iconBgColor: const Color(0xFFF3E8FF),
                title: 'AI Settings',
                onTap: () {},
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
            ]),
            const SizedBox(height: 24),
            // Support Section
            _buildSectionHeader('SUPPORT'),
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.help_outline,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'Help Center',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.phone_outlined,
                iconColor: const Color(0xFF16A34A),
                iconBgColor: const Color(0xFFF0FDF4),
                title: 'Contact Support',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
            // Legal Section
            _buildSectionHeader('LEGAL'),
            _buildSectionContainer([
              SettingsTile(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'Privacy Policy',
                onTap: () {},
              ),
              SettingsTile(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF475569),
                iconBgColor: const Color(0xFFF8F9FC),
                title: 'Terms of Service',
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),
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
            const SizedBox(height: 80), // To make room for bottom nav if overlapping
          ],
        ),
      ),
    );
  }
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'alex@example.com',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.profile);
                  },
                  child: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
        ],
      ),
    );
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF021649),
          fontSize: 16,
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
          borderRadius: BorderRadius.circular(16),
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
