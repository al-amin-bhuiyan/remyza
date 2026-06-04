import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/custom_assets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Prevents elements from moving up when keyboard appears
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visualizing the page with a top image as requested
              Center(
                child: Image.asset(
                  CustomAssets.splashLogo, // Fallback to splash logo to visualize, you can change this
                  height: 100.h,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                'Welcome Back !',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Sign in with your phone number',
                style: TextStyle(
                  color: const Color(0xFF949CA9),
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.29,
                ),
              ),
              SizedBox(height: 32.h),
              const AppTextField(
                labelText: 'Number',
                hintText: '01560*****',
                keyboardType: TextInputType.phone,
              ),
              const Spacer(),
              AppButton(
                text: 'Send Otp',
                onPressed: () {
                  // Navigate to VerificationView, possibly passing phone number
                  // In a real app we would get the number from the text field controller
                  context.push(AppRoutes.verification);
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
