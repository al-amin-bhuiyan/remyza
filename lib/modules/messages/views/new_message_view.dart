import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controllers/new_message_controller.dart';
import '../../../../shared/widgets/app_button.dart';

class NewMessageView extends GetView<NewMessageController> {
  const NewMessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        centerTitle: true,
        title: Text(
          'New Message',
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // To: Search Contacts
              Text(
                'To:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151),
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: controller.toController,
                  decoration: InputDecoration(
                    hintText: 'Search contacts...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF9CA3AF)),
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
              // Filtered contacts list
              Obx(() {
                final list = controller.filteredContacts;
                if (list.isEmpty) return const SizedBox.shrink();
                return Container(
                  margin: EdgeInsets.only(top: 4.h),
                  constraints: BoxConstraints(maxHeight: 150.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final contact = list[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          contact,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            color: const Color(0xFF374151),
                          ),
                        ),
                        onTap: () => controller.selectContact(contact),
                      );
                    },
                  ),
                );
              }),
              SizedBox(height: 20.h),
              
              // Message Textarea Box
              Text(
                'Message:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151),
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.messageController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.r),
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF1F2937),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Divider(height: 1.h, color: const Color(0xFFE5E7EB)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Character Counter
                          Obx(() => Text(
                            '${controller.characterCount.value}/160',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF9CA3AF),
                              fontFamily: 'Inter',
                            ),
                          )),
                          // AI Assist button
                          InkWell(
                            onTap: controller.generateAiAssistMessage,
                            borderRadius: BorderRadius.circular(4.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 14.r,
                                    color: const Color(0xFF4F46E5),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'AI Assist',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF4F46E5),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Tone Selection Section
              Text(
                'Tone:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151),
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() => Row(
                children: controller.tones.map((tone) {
                  final isSelected = controller.selectedTone.value == tone;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(
                        tone,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF4B5563),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF4F46E5),
                      backgroundColor: const Color(0xFFF3F4F6),
                      onSelected: (selected) {
                        if (selected) controller.selectTone(tone);
                      },
                    ),
                  );
                }).toList(),
              )),
              SizedBox(height: 40.h),

              // Send Message Action Button
              Obx(() => AppButton(
                text: 'Send Message',
                isLoading: controller.isLoading.value,
                onPressed: () async {
                  final success = await controller.sendMessage();
                  if (success && context.mounted) {
                    context.pop();
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
