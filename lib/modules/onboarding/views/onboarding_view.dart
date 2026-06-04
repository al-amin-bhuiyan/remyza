import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_page_content.dart';
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    width: 60.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: controller.currentIndex.value == index
                          ? AppColors.primary
                          : AppColors.indicatorInactive,
                      borderRadius: _getIndicatorBorderRadius(index, controller.pages.length),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(pageData: controller.pages[index]);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 14.h),
              child: Obx(() {
                return GestureDetector(
                  onTap: () => controller.nextPage(context),
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.pages[controller.currentIndex.value].buttonText,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
  BorderRadius _getIndicatorBorderRadius(int index, int totalPages) {
    if (index == 0) {
      return BorderRadius.only(
        topLeft: Radius.circular(99.r),
        bottomLeft: Radius.circular(99.r),
      );
    } else if (index == totalPages - 1) {
      return BorderRadius.only(
        topRight: Radius.circular(99.r),
        bottomRight: Radius.circular(99.r),
      );
    }
    return BorderRadius.zero;
  }
}
