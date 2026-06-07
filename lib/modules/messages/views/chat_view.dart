import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../shared/widgets/chat_bubble.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  final String conversationId;

  const ChatView({
    super.key,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
        titleSpacing: 0,
        title: Obx(() {
          final conv = controller.conversation.value;
          if (conv == null) {
            return Text(
              'Chat',
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            );
          }
          return Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: conv.avatarColor,
                child: Text(
                  conv.initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      conv.name,
                      style: TextStyle(
                        color: const Color(0xFF1F2937),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                            color: conv.borderColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            conv.leadStatus.toUpperCase(),
                            style: TextStyle(
                              color: conv.borderColor,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF374151)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sub-header: AI Auto-reply toggle switch & Score progress bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFE5E7EB),
                    width: 1.w,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 18.r,
                            color: const Color(0xFF6366F1),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'AI Auto-reply',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      Obx(() => Switch.adaptive(
                        value: controller.isAiAutoReplyEnabled.value,
                        onChanged: controller.toggleAiAutoReply,
                        activeThumbColor: const Color(0xFF4F46E5),
                      )),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text(
                        'Lead Score:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF6B7280),
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: Obx(() => LinearProgressIndicator(
                            value: controller.score.value,
                            backgroundColor: const Color(0xFFE5E7EB),
                            color: controller.conversation.value?.borderColor ?? const Color(0xFF4F46E5),
                            minHeight: 6.h,
                          )),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Obx(() => Text(
                        '${(controller.score.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: controller.conversation.value?.borderColor ?? const Color(0xFF4F46E5),
                          fontFamily: 'Inter',
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),

            // Chat Timeline
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

                final messages = controller.messages;
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF9CA3AF),
                        fontFamily: 'Inter',
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: messages[index]);
                  },
                );
              }),
            ),

            // AI Suggestion Box
            Obx(() {
              final suggestion = controller.aiSuggestion.value;
              if (suggestion == null) return const SizedBox.shrink();
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2F6),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 16.r,
                      color: const Color(0xFF6366F1),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Suggests:',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4F46E5),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            suggestion,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF374151),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: controller.useSuggestion,
                      child: Text(
                        'Use',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4F46E5),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Text input composer bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Spark button (AI Assist)
                  InkWell(
                    onTap: () {
                      controller.aiSuggestion.value = "Let's schedule a call tomorrow at 2:00 PM EST.";
                      SnackbarHelper.showSuccess('AI generated a reply suggestion!');
                    },
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 20.r,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Input field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: TextField(
                        controller: controller.messageInputController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1F2937),
                          fontFamily: 'Inter',
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Send button
                  InkWell(
                    onTap: controller.sendMessage,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 18.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
