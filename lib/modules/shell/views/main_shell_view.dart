import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_nav_bar.dart';
import '../controllers/shell_controller.dart';
import '../../home/views/home_view.dart';
import '../../settings/views/settings_view.dart';
import '../../messages/views/messages_list_view.dart';
import '../../leads/views/leads_list_view.dart';
import '../../contacts/views/contacts_list_view.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShellController());

    final List<Widget> pages = [
      const HomeView(key: ValueKey('home')),
      const ContactsListView(key: ValueKey('contacts')),
      const LeadsListView(key: ValueKey('leads')),
      const MessagesListView(key: ValueKey('message')),
      const SettingsView(key: ValueKey('settings')),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
