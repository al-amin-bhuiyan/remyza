import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/custom_assets.dart';
import '../widgets/onboarding_content_model.dart';
class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;
  final List<OnboardingContentModel> pages = [
    OnboardingContentModel(
      title: 'Losing leads every day?',
      description: 'Most agents miss follow-ups and lose\ncustomers forever.',
      imagePath: CustomAssets.onboardingImage1,
      buttonText: 'Next',
    ),
    OnboardingContentModel(
      title: 'AI replies for you, 24/7',
      description: 'Send smart SMS, track replies, and never\nmiss a hot lead.',
      imagePath: CustomAssets.onboardingImage2,
      buttonText: 'Next',
    ),
    OnboardingContentModel(
      title: 'Convert more. Work less.',
      description: 'Your leads are scored automatically.\nFocus only on the hottest ones.',
      imagePath: CustomAssets.onboardingImage3,
      buttonText: 'Continue',
    ),
  ];
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  void onPageChanged(int index) {
    currentIndex.value = index;
  }
  void nextPage(BuildContext context) {
    if (currentIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login
      context.go(AppRoutes.login);
    }
  }
}
