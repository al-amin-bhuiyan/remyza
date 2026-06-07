import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/app_routes.dart';
import '../controllers/conversation_list_controller.dart';
import '../widgets/conversation_tile.dart';

class MessagesListView extends GetView<ConversationListController> {
  const MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Inbox',
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              color: const Color(0xFF4F46E5), // Indigo
              size: 24.r,
            ),
            onPressed: () => context.push(AppRoutes.newMessage),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search field
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.015),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: controller.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search contacts or messages...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color(0xFF9CA3AF),
                      size: 20.r,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF1F2937),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            // Horizontal list of filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Obx(() => Row(
                children: ['All', 'Hot', 'Unread', 'Archived'].map((tab) {
                  final isSelected = controller.selectedTab.value == tab;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: InkWell(
                      onTap: () => controller.changeTab(tab),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFFE5E7EB),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF4B5563),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13.sp,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
            ),
            // List of conversations
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: const Color(0xFF4F46E5),
                      size: 40.r,
                    ),
                  );
                }

                final items = controller.filteredConversations;
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail_outline_rounded,
                          size: 48.r,
                          color: const Color(0xFFD1D5DB),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No conversations found',
                          style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 90.h),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ConversationTile(conversation: items[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
