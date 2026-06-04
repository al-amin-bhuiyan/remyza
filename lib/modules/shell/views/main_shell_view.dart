import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_nav_bar.dart';
import '../controllers/shell_controller.dart';
import '../../home/views/home_view.dart';
import '../../settings/views/settings_view.dart';
// Note: Other views (contacts, leads, message, settings) can be added as they are built.

class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShellController());

    final List<Widget> pages = [
      const HomeView(key: ValueKey('home')),
      const Center(key: ValueKey('contacts'), child: Text("Contacts")),
      const Center(key: ValueKey('leads'), child: Text("Leads")),
      const Center(key: ValueKey('message'), child: Text("Message")),
      const SettingsView(key: ValueKey('settings')),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // A common generic background
      body: Stack(
        children: [
          // Main content
          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: pages[controller.selectedIndex.value],
          )),

          // Floating custom NavBar at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 24.h,
            child: Align(
              alignment: Alignment.center,
              child: Obx(() => AppNavBar(
                selectedIndex: controller.selectedIndex.value,
                onItemTapped: controller.changePage,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
