import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../controllers/contact_form_controller.dart';

class ContactFormView extends GetView<ContactFormController> {
  const ContactFormView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Add Contact',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() => SingleChildScrollView(
          key: ValueKey(controller.formResetKey.value),
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Business Name field
              _buildFieldLabel('Business Name'),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: controller.businessNameController,
                hintText: 'Company name (optional)',
                icon: Icons.business_outlined,
              ),
              SizedBox(height: 16.h),

              // Notes field
              _buildFieldLabel('Notes'),
              SizedBox(height: 8.h),
              _buildNotesField(),
              SizedBox(height: 24.h),

              // Add Another Contact link button
              Center(
                child: GestureDetector(
                  onTap: controller.addAnotherContact,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: const Color(0xFF2563EB),
                          size: 18.r,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Add Another Contact',
                          style: TextStyle(
                            color: const Color(0xFF2563EB),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Save Button
              GestureDetector(
                onTap: controller.saveContact,
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0249AA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Save Contacts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: const Color(0xFF021649),
        fontSize: 14.sp,
        fontFamily: 'Inter',
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
        style: TextStyle(
          color: const Color(0xFF021649),
          fontSize: 14.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFF949CA9),
            fontSize: 12.sp,
            fontFamily: 'Inter',
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
          // Country code selector container using country_code_picker
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
              initialSelection: 'US',
              favorite: const ['+1', 'US'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              padding: EdgeInsets.zero,
              textStyle: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: const Color(0xFF021649),
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: '+1 (555) 000-0000',
                hintStyle: TextStyle(
                  color: const Color(0xFF949CA9),
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
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
        style: TextStyle(
          color: const Color(0xFF021649),
          fontSize: 14.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Add notes about this contact (optional)',
          hintStyle: TextStyle(
            color: const Color(0xFF949CA9),
            fontSize: 12.sp,
            fontFamily: 'Inter',
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
}
