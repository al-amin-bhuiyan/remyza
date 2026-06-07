import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../controllers/contacts_list_controller.dart';
import '../../../data/models/contact_model.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/constants/app_routes.dart';

class ContactsListView extends GetView<ContactsListController> {
  const ContactsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Contacts',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 20.sp,
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Upper Actions Row (Add Manually, Upload CSV, Auto-Capture)
            Padding(
              padding: EdgeInsets.fromLTRB(26.w, 16.h, 26.w, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'Add Manually',
                      color: const Color(0xFF2563EB),
                      onTap: () => context.push(AppRoutes.contactForm),
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      icon: Icons.file_upload_outlined,
                      label: 'Upload CSV',
                      color: const Color(0xFF2563EB),
                      onTap: () => context.push(AppRoutes.importContacts),
                    ),
                  ],
                ),
              ),
            ),

            // Search Input Container
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF3F2FF),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFE2E1EF),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: const Color(0xFF949CA9),
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        onChanged: controller.setSearchQuery,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by name or number',
                          hintStyle: TextStyle(
                            color: const Color(0xFF949CA9),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Dynamic Contacts list
            Expanded(
              child: Obx(() {
                final list = controller.filteredContacts;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      'No contacts found',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(26.w, 8.h, 26.w, 120.h),
                  itemCount: list.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final contact = list[index];
                    return _ContactTile(contact: contact);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: color.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 14.r,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.5.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final ContactModel contact;
  const _ContactTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    Color badgeBgColor;
    Color badgeTextColor;

    switch (contact.status.toLowerCase()) {
      case 'active':
        badgeBgColor = const Color(0xFFF0FDF4);
        badgeTextColor = const Color(0xFF22C55E);
        break;
      case 'new':
        badgeBgColor = const Color(0xFFEFF6FF);
        badgeTextColor = const Color(0xFF3B82F6);
        break;
      case 'no reply':
      default:
        badgeBgColor = const Color(0xFFF8F9FC);
        badgeTextColor = const Color(0xFF94A3B8);
        break;
    }

    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.editContact.replaceAll(':id', contact.id));
      },
      onLongPress: () async {
        try {
          final clipboardText = 'Name: ${contact.name}\nPhone: ${contact.phone}\nEmail: ${contact.email}';
          await Clipboard.setData(ClipboardData(text: clipboardText));
          SnackbarHelper.showSuccess('Copied contact details to clipboard!');
        } catch (e) {
          SnackbarHelper.showError('Failed to copy: $e');
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: const Color(0xFFF1F5F9),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status Bullet
            Container(
              width: 8.r,
              height: 8.r,
              decoration: ShapeDecoration(
                color: contact.statusColor,
                shape: const CircleBorder(),
              ),
            ),
            SizedBox(width: 12.w),

            // Initials Avatar
            Container(
              width: 42.r,
              height: 42.r,
              decoration: ShapeDecoration(
                color: contact.avatarColor,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Contact Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    contact.phone,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: ShapeDecoration(
                color: badgeBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: Text(
                contact.status,
                style: TextStyle(
                  color: badgeTextColor,
                  fontSize: 11.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
