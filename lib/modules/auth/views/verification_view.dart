import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  final String? phoneNumber;

  const VerificationView({super.key, this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      controller.setPhoneNumber(phoneNumber!);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button Row
              Align(
                alignment: Alignment.centerLeft,
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
              SizedBox(height: 24.h),

              Text(
                'Verify your Phone Number',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.33,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Please enter 6 digit verification code that have been sent to your phone number ${phoneNumber ?? ""}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  color: const Color(0xFF949CA9),
                  height: 1.5,
                ),
              ),

              SizedBox(height: 48.h),

              _OtpFields(controller: controller),
              SizedBox(height: 16.h),

              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => controller.handlePasteFromClipboard(),
                  child: Text(
                    'Paste Code',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              Align(
                alignment: Alignment.center,
                child: Obx(() => Column(
                  children: [
                    Text(
                      "Didn't receive code?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: controller.canResend.value ? () => controller.resendCode() : null,
                      child: Text(
                        controller.canResend.value
                            ? 'Resend code'
                            : 'Resend code (${controller.timerText})',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: controller.canResend.value
                              ? Colors.red // Make "Resend code" red when active
                              : const Color(0xFF949CA9),
                        ),
                      ),
                    ),
                  ],
                )),
              ),

              const Spacer(),

              Obx(() => AppButton(
                text: 'Verify',
                isLoading: controller.isLoading.value,
                onPressed: () => controller.verifyCode(context),
              )),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpFields extends StatelessWidget {
  final VerificationController controller;

  const _OtpFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOtpField(controller.otp1Controller, controller.otp1FocusNode, 1, controller.otp1, controller, context),
        _buildOtpField(controller.otp2Controller, controller.otp2FocusNode, 2, controller.otp2, controller, context),
        _buildOtpField(controller.otp3Controller, controller.otp3FocusNode, 3, controller.otp3, controller, context),
        _buildOtpField(controller.otp4Controller, controller.otp4FocusNode, 4, controller.otp4, controller, context),
        _buildOtpField(controller.otp5Controller, controller.otp5FocusNode, 5, controller.otp5, controller, context),
        _buildOtpField(controller.otp6Controller, controller.otp6FocusNode, 6, controller.otp6, controller, context),
      ],
    );
  }

  Widget _buildOtpField(
    TextEditingController textController,
    FocusNode focusNode,
    int index,
    RxString observableValue,
    VerificationController otpController,
    BuildContext context,
  ) {
    return Obx(() {
      final hasInput = observableValue.value.isNotEmpty;

      return Container(
        width: 48.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: hasInput ? AppColors.primary : const Color(0xFFE5E7EB),
            width: hasInput ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: TextFormField(
            controller: textController,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (value) {
              if (value.length <= 1) {
                otpController.onOtpChanged(value, index, context);
              }
            },
          ),
        ),
      );
    });
  }
}
