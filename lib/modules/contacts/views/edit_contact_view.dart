import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../controllers/edit_contact_controller.dart';

class EditContactView extends GetView<EditContactController> {
  const EditContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          'Edit Contact',
          style: GoogleFonts.nunitoSans(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: const Color(0xFFEF4444),
              size: 24.r,
            ),
            onPressed: () => _showDeleteConfirmation(context),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Avatar Edit and Color Selector Card
                  _buildAvatarSection(context),
                  SizedBox(height: 24.h),

                  // Full Name field
                  _buildFieldLabel('Full Name'),
                  SizedBox(height: 8.h),
                  _buildTextField(
                    controller: controller.fullNameController,
                    hintText: 'Enter full name',
                    icon: Icons.person_outline_rounded,
                  ),
                  SizedBox(height: 16.h),

                  // Phone Number field
                  _buildFieldLabel('Phone Number'),
                  SizedBox(height: 8.h),
                  _buildPhoneField(),
                  SizedBox(height: 16.h),

                  // Email field
                  _buildFieldLabel('Email'),
                  SizedBox(height: 8.h),
                  _buildTextField(
                    controller: controller.emailController,
                    hintText: 'email@example.com (optional)',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16.h),

                  // Status field
                  _buildFieldLabel('Status'),
                  SizedBox(height: 8.h),
                  _buildStatusDropdown(),
                  SizedBox(height: 16.h),

                  // Notes field
                  _buildFieldLabel('Notes'),
                  SizedBox(height: 8.h),
                  _buildNotesField(),
                  SizedBox(height: 32.h),

                  // Save Changes button
                  AppButton(
                    text: 'Save Changes',
                    backgroundColor: const Color(0xFF0249AA),
                    onPressed: controller.saveContact,
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    final imagePath = controller.customImagePath.value;
    final hasImage = imagePath != null;
    final isLocalFile = hasImage && !imagePath.startsWith('http');

    ImageProvider? bgImage;
    if (hasImage) {
      bgImage = isLocalFile
          ? FileImage(File(imagePath))
          : NetworkImage(imagePath) as ImageProvider;
    }

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
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => _showImagePickerSheet(context),
                child: CircleAvatar(
                  radius: 46.r,
                  backgroundColor: controller.selectedAvatarColor.value,
                  backgroundImage: bgImage,
                  child: hasImage
                      ? null
                      : Text(
                          controller.fullNameController.text.trim().isEmpty
                              ? '?'
                              : controller.fullNameController.text
                                  .trim()
                                  .split(' ')
                                  .map((e) => e.isNotEmpty ? e[0] : '')
                                  .take(2)
                                  .join()
                                  .toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePickerSheet(context),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: const ShapeDecoration(
                      color: Color(0xFF0249AA),
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 14.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            hasImage ? 'Tap to change or remove photo' : 'Tap to add a profile photo',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!hasImage) ...[
            SizedBox(height: 16.h),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12.h),
            Text(
              'CHOOSE AVATAR COLOR',
              style: GoogleFonts.inter(
                color: const Color(0xFF94A3B8),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(height: 10.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.avatarColors.map((color) {
                  final isSelected = controller.selectedAvatarColor.value == color;
                  return GestureDetector(
                    onTap: () => controller.selectAvatarColor(color),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 28.r,
                      height: 28.r,
                      decoration: ShapeDecoration(
                        color: color,
                        shape: const CircleBorder(),
                        shadows: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14.r,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showImagePickerSheet(BuildContext context) {
    final hasImage = controller.customImagePath.value != null;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Profile Photo',
              style: GoogleFonts.nunitoSans(
                color: const Color(0xFF021649),
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Choose how to set your profile photo',
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 24.h),
            // Camera option
            _buildPickerOption(
              context: ctx,
              icon: Icons.camera_alt_rounded,
              iconColor: const Color(0xFF0249AA),
              iconBg: const Color(0xFFEFF4FF),
              title: 'Take Photo',
              subtitle: 'Open camera to take a new photo',
              onTap: () {
                Navigator.pop(ctx);
                controller.pickImage(ImageSource.camera);
              },
            ),
            SizedBox(height: 12.h),
            // Gallery option
            _buildPickerOption(
              context: ctx,
              icon: Icons.photo_library_rounded,
              iconColor: const Color(0xFF7C3AED),
              iconBg: const Color(0xFFF5F3FF),
              title: 'Choose from Gallery',
              subtitle: 'Pick an existing photo from your device',
              onTap: () {
                Navigator.pop(ctx);
                controller.pickImage(ImageSource.gallery);
              },
            ),
            if (hasImage) ...[
              SizedBox(height: 12.h),
              _buildPickerOption(
                context: ctx,
                icon: Icons.delete_outline_rounded,
                iconColor: const Color(0xFFEF4444),
                iconBg: const Color(0xFFFFF1F1),
                title: 'Remove Photo',
                subtitle: 'Go back to color avatar',
                onTap: () {
                  Navigator.pop(ctx);
                  controller.removePhoto();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.r),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF021649),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF94A3B8),
                size: 20.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: const Color(0xFF021649),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          color: const Color(0xFF021649),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF949CA9),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF64748B),
            size: 16.r,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 12.w),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1,
                  color: Color(0xFFE2E8F0),
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            child: CountryCodePicker(
              onChanged: (code) {
                controller.selectedCountryCode.value = code.dialCode ?? '+1';
              },
              initialSelection: controller.selectedCountryCode.value,
              favorite: const ['+1', 'US'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              padding: EdgeInsets.zero,
              textStyle: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.inter(
                color: const Color(0xFF021649),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF949CA9),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    final statusOptions = ['New', 'Active', 'No Reply'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: controller.selectedStatus.value,
        style: GoogleFonts.inter(
          color: const Color(0xFF021649),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        items: statusOptions.map((status) {
          return DropdownMenuItem<String>(
            value: status,
            child: Text(status),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            controller.selectedStatus.value = val;
          }
        },
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      height: 100.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: TextField(
        controller: controller.notesController,
        maxLines: null,
        style: GoogleFonts.inter(
          color: const Color(0xFF021649),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Add notes about this contact (optional)',
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF949CA9),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.notes_rounded,
            color: const Color(0xFF64748B),
            size: 16.r,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Contact',
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF021649),
          ),
        ),
        content: Text(
          'Are you sure you want to delete this contact? This action cannot be undone.',
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteContact();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
