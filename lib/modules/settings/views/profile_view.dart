import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/widgets/app_avatar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (context.mounted && Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Get.back();
                }
              },
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
          'Edit Profile',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    if (controller.profileImage.value != null) {
                      return CircleAvatar(
                        radius: 45.r,
                        backgroundImage: FileImage(controller.profileImage.value!),
                      );
                    }
                    return AppAvatar(
                      fullName: controller.fullNameController.text.isNotEmpty ? controller.fullNameController.text : '?',
                      radius: 45.r,
                    );
                  }),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () => _showImagePickerSheet(context, controller),
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.r),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 14.r,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Form Fields
            _buildLabel('Full Name'),
            _buildTextField(
              controller: controller.fullNameController,
              icon: Icons.person_outline,
              hint: 'Full Name',
            ),

            SizedBox(height: 16.h),
            _buildLabel('Email'),
            _buildTextField(
              controller: controller.emailController,
              icon: Icons.email_outlined,
              hint: 'Email',
              enabled: false,
            ),

            SizedBox(height: 16.h),
            _buildLabel('Phone'),
            _buildPhoneField(context, controller),

            SizedBox(height: 16.h),
            _buildLabel('Business Name'),
            _buildTextField(
              controller: controller.businessNameController,
              icon: Icons.domain,
              hint: 'Business Name',
            ),

            SizedBox(height: 16.h),
            _buildLabel('Business Type'),
            _buildTextField(
              controller: controller.businessTypeController,
              icon: Icons.work_outline,
              hint: 'Business Type',
            ),

            SizedBox(height: 16.h),
            _buildLabel('Time Zone'),
            _buildTextField(
              controller: controller.timeZoneController,
              icon: Icons.language,
              hint: 'Time Zone',
            ),

            SizedBox(height: 32.h),
            // Account Created Footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Created',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'May 1, 2026',
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
            // Save Button
            ElevatedButton(
              onPressed: controller.saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0249AA),
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  void _showImagePickerSheet(BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Open Camera'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF64748B),
          fontSize: 14.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool enabled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: TextStyle(
          color: enabled ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          fontSize: 14.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
          prefixIcon: Icon(icon, size: 20.r, color: const Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context, ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Icon(Icons.phone_outlined, size: 20.r, color: const Color(0xFF94A3B8)),
          ),
          GestureDetector(
            onTap: () => controller.pickCountry(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Obx(() => Text(
                '${controller.selectedCountry.value.flagEmoji} +${controller.selectedCountry.value.phoneCode}',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Phone Number',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
