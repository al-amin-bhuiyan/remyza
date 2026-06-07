import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/interfaces/i_leads_repository.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../data/models/lead_model.dart';
import '../../../../data/models/activity_model.dart';
import '../../../../data/models/message_model.dart';
import '../controllers/lead_detail_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MAIN VIEW
// ─────────────────────────────────────────────────────────────────────────────
class LeadDetailView extends StatelessWidget {
  final String leadId;
  const LeadDetailView({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      LeadDetailController(Get.find<ILeadsRepository>(), leadId),
      tag: leadId,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: const Color(0xFF2563EB),
              size: 40.r,
            ),
          );
        }
        final lead = controller.lead.value;
        if (lead == null) {
          return const Center(child: Text('Lead not found'));
        }

        return Column(
          children: [
            // Header
            _Header(lead: lead, controller: controller),
            // Scrollable body
            Expanded(
              child: Obx(() {
                final tab = controller.selectedTab.value;
                // AI Suggestions is a special full-view (tab 3)
                if (tab == 3) {
                  return _AISuggestionsFullView(
                    lead: lead,
                    controller: controller,
                  );
                }
                return _MainScrollBody(lead: lead, controller: controller);
              }),
            ),
            // Bottom Action Bar
            _BottomBar(lead: lead, controller: controller),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final LeadModel lead;
  final LeadDetailController controller;
  const _Header({required this.lead, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 8.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (controller.selectedTab.value == 3) {
                    controller.selectTab(0);
                  } else {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.home);
                    }
                  }
                },
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
              Expanded(
                child: Obx(() {
                  final title = controller.selectedTab.value == 3
                      ? 'AI Suggestions'
                      : 'Lead Profile';
                  return Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF021649),
                      fontSize: 18.sp,
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w700,
                      height: 1.11,
                    ),
                  );
                }),
              ),
              SizedBox(width: 32.w),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SCROLL BODY (tabs 0-2)
// ─────────────────────────────────────────────────────────────────────────────
class _MainScrollBody extends StatelessWidget {
  final LeadModel lead;
  final LeadDetailController controller;
  const _MainScrollBody({required this.lead, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Profile card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: _ProfileCard(lead: lead),
          ),
          SizedBox(height: 16.h),
          // AI Insight card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: _AIInsightCard(lead: lead, controller: controller),
          ),
          SizedBox(height: 16.h),
          // Tab Bar
          _TabBar(controller: controller),
          // Tab content
          Obx(
            () => _buildTabContent(
              controller.selectedTab.value,
              lead,
              controller,
            ),
          ),
          SizedBox(height: 120.h),
        ],
      ),
    );
  }

  Widget _buildTabContent(
    int tab,
    LeadModel lead,
    LeadDetailController controller,
  ) {
    switch (tab) {
      case 0:
        return _ActivityTabContent(lead: lead, controller: controller);
      case 1:
        return _ConversationTabContent(lead: lead, controller: controller);
      case 2:
        return _InfoTabContent(lead: lead);
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PROFILE CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final LeadModel lead;
  const _ProfileCard({required this.lead});

  @override
  Widget build(BuildContext context) {
    final statusEmoji = lead.status == 'hot'
        ? '🔥'
        : lead.status == 'warm'
        ? '☀️'
        : '❄️';
    final statusLabel = lead.status == 'hot'
        ? 'Hot Lead'
        : lead.status == 'warm'
        ? 'Warm Lead'
        : 'Cold Lead';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar + Name + Phone + Status badge
          Column(
            children: [
              // Gradient avatar
              Container(
                width: 72.r,
                height: 72.r,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: lead.avatarGradient,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  lead.initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                lead.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 18.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 1.44,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                lead.phone,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
              SizedBox(height: 8.h),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: ShapeDecoration(
                  color: lead.borderColor.withValues(alpha: 0.07),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: lead.borderColor),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(statusEmoji, style: TextStyle(fontSize: 14.sp)),
                    SizedBox(width: 6.w),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: lead.borderColor,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatCard(
                bg: const Color(0xFFEFF6FF),
                valueColor: const Color(0xFF2563EB),
                value: '${lead.messageCount}',
                label: 'Messages',
                icon: Icons.chat_bubble_outline_rounded,
              ),
              SizedBox(width: 12.w),
              _StatCard(
                bg: const Color(0xFFF0FDF4),
                valueColor: const Color(0xFF22C55E),
                value: '${(lead.responseRate * 100).toInt()}%',
                label: 'Response Rate',
                icon: Icons.trending_up_rounded,
              ),
              SizedBox(width: 12.w),
              _StatCard(
                bg: const Color(0xFFF3E8FF),
                valueColor: const Color(0xFF7C3AED),
                value: '${lead.daysActive}',
                label: 'Days Active',
                icon: Icons.calendar_today_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Color bg;
  final Color valueColor;
  final String value;
  final String label;
  final IconData icon;
  const _StatCard({
    required this.bg,
    required this.valueColor,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20.r, color: valueColor),
          SizedBox(height: 8.h),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: valueColor,
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
              height: 1.38,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: valueColor,
              fontSize: 10.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AI INSIGHT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _AIInsightCard extends StatelessWidget {
  final LeadModel lead;
  final LeadDetailController controller;
  const _AIInsightCard({required this.lead, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1.5, color: Color(0xFF2563EB)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI INSIGHT label
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 16.r,
                color: const Color(0xFF2563EB),
              ),
              SizedBox(width: 8.w),
              Text(
                'AI INSIGHT',
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.43,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            lead.aiInsight.isEmpty
                ? 'AI analysis will appear here as conversation data is collected.'
                : lead.aiInsight,
            style: TextStyle(
              color: const Color(0xFF475569),
              fontSize: 13.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          SizedBox(height: 6.h),
          GestureDetector(
            onTap: () => controller.selectTab(3),
            child: Text(
              'View AI Suggestions →',
              style: TextStyle(
                color: const Color(0xFF2563EB),
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.43,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UNDERLINE TAB BAR
// ─────────────────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final LeadDetailController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Activity', 'Conversation', 'Info'];
    return Container(
      color: Colors.white,
      child: Row(
        children: List.generate(tabs.length, (i) {
          return Obx(() {
            final isSelected = controller.selectedTab.value == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(i),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  child: Text(
                    tabs[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF64748B),
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 0 – ACTIVITY
// ─────────────────────────────────────────────────────────────────────────────
class _ActivityTabContent extends StatelessWidget {
  final LeadModel lead;
  final LeadDetailController controller;
  const _ActivityTabContent({required this.lead, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(26.w, 20.h, 26.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final activities = controller.activities;
            if (activities.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    'No activities yet',
                    style: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: activities
                  .map((a) => _ActivityBulletItem(activity: a))
                  .toList(),
            );
          }),
          SizedBox(height: 20.h),

          // Quick note input
        ],
      ),
    );
  }
}

class _ActivityBulletItem extends StatelessWidget {
  final ActivityModel activity;
  const _ActivityBulletItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.only(bottom: 10.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              activity.title,
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
          ),
          Text(
            activity.time,
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 – CONVERSATION
// ─────────────────────────────────────────────────────────────────────────────
class _ConversationTabContent extends StatelessWidget {
  final LeadModel lead;
  final LeadDetailController controller;
  const _ConversationTabContent({required this.lead, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        // Date separator
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100.w,
                height: 1,
                color: const Color(0xFFE2E8F0),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                width: 100.w,
                height: 1,
                color: const Color(0xFFE2E8F0),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Messages
        Obx(() {
          final msgs = controller.messages;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: msgs
                  .map((m) => _BubbleItem(msg: m, lead: lead))
                  .toList(),
            ),
          );
        }),
        // View Full Conversation link
        Padding(
          padding: EdgeInsets.fromLTRB(26.w, 12.h, 26.w, 0),
          child: GestureDetector(
            onTap: () => context.push('/chat/${lead.id}'),
            child: Text(
              'View Full Conversation →',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: const Color(0xFF2563EB),
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.43,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BubbleItem extends StatelessWidget {
  final MessageModel msg;
  final LeadModel lead;
  const _BubbleItem({required this.msg, required this.lead});

  @override
  Widget build(BuildContext context) {
    final isMe = msg.isMe;
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                lead.name,
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          Container(
            constraints: BoxConstraints(maxWidth: 294.w),
            padding: EdgeInsets.all(12.r),
            decoration: ShapeDecoration(
              color: isMe ? const Color(0xFF2563EB) : Colors.white,
              shape: RoundedRectangleBorder(
                side: isMe
                    ? BorderSide.none
                    : const BorderSide(width: 1, color: Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: isMe
                      ? Radius.circular(18.r)
                      : Radius.circular(4.r),
                  bottomRight: isMe
                      ? Radius.circular(4.r)
                      : Radius.circular(18.r),
                ),
              ),
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF0F172A),
                fontSize: 14.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            msg.isSentByAi ? 'Sent by AI · ${msg.time}' : msg.time,
            style: TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 12.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 – INFO
// ─────────────────────────────────────────────────────────────────────────────
class _InfoTabContent extends StatelessWidget {
  final LeadModel lead;
  const _InfoTabContent({required this.lead});

  @override
  Widget build(BuildContext context) {
    final items = [
      _InfoItem(label: 'LEAD SCORE', value: '${(lead.score * 100).toInt()}%'),
      _InfoItem(label: 'SOURCE', value: lead.source),
      _InfoItem(
        label: 'DAYS IN PIPELINE',
        value: '${lead.daysInPipeline} days',
      ),
      _InfoItem(
        label: 'TOTAL MESSAGES',
        value: '${lead.messageCount} messages',
      ),
      _InfoItem(label: 'EMAIL', value: lead.email),
      _InfoItem(label: 'OWNER', value: lead.owner),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(26.w, 20.h, 26.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.value,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 16.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  height: 1,
                  color: const Color(0xFFF1F5F9),
                  width: double.infinity,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 – AI SUGGESTIONS (Full view, accessed via "View AI Suggestions →")
// ─────────────────────────────────────────────────────────────────────────────
class _AISuggestionsFullView extends StatelessWidget {
  final LeadModel lead;
  final LeadDetailController controller;
  const _AISuggestionsFullView({required this.lead, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(26.w, 24.h, 26.w, 120.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to profile
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: 1.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 28.r,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'AI analyzed this lead',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 18.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Based on ${lead.name.split(' ').first}'s conversation history, response\npatterns, and behavior, here are personalized\nmessage suggestions to maximize engagement.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Suggested Replies',
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          // Suggestion cards
          ...List.generate(lead.aiSuggestions.length, (i) {
            final suggestion = lead.aiSuggestions[i];
            final tag = i < lead.suggestionTags.length
                ? lead.suggestionTags[i]
                : 'Tip';
            return _SuggestionCard(
              suggestion: suggestion,
              tag: tag,
              onUse: () {
                controller.useSuggestion(suggestion);
                SnackbarHelper.showSuccess('Loaded into conversation!');
              },
            );
          }),
          SizedBox(height: 16.h),
          // Best time to follow up
          if (lead.bestFollowUpTime.isNotEmpty)
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFF59E0B), width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 18.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Best time to follow up',
                          style: TextStyle(
                            color: const Color(0xFF92400E),
                            fontSize: 11.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          lead.bestFollowUpTime,
                          style: TextStyle(
                            color: const Color(0xFF92400E),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "${lead.name.split(' ').first}'s response rate is 3× higher during these hours",
                          style: TextStyle(
                            color: const Color(0xFFB45309),
                            fontSize: 11.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20.h),
          // Generate Custom Message button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Generate Custom Message',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 18.r,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String suggestion;
  final String tag;
  final VoidCallback onUse;
  const _SuggestionCard({
    required this.suggestion,
    required this.tag,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion,
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 11.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onUse,
                child: Row(
                  children: [
                    Text(
                      'Use This',
                      style: TextStyle(
                        color: const Color(0xFF2563EB),
                        fontSize: 13.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: const Color(0xFF2563EB),
                      size: 14.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM BAR
// ─────────────────────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final LeadModel lead;
  final LeadDetailController controller;
  const _BottomBar({required this.lead, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFF1F5F9)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(26.w, 12.h, 26.w, 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Set Reminder
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showReminderSheet(context, lead),
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFF59E0B),
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'Set Reminder',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFF59E0B),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.43,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // View Chat
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push('/chat/${lead.id}'),
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: ShapeDecoration(
                          color: const Color(0xFF0249AA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'View Chat',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.43,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  width: 144.w,
                  height: 6.h,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF021649),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReminderSheet(BuildContext context, LeadModel lead) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReminderBottomSheet(lead: lead),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SET REMINDER BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────
class _ReminderBottomSheet extends StatefulWidget {
  final LeadModel lead;
  const _ReminderBottomSheet({required this.lead});

  @override
  State<_ReminderBottomSheet> createState() => _ReminderBottomSheetState();
}

class _ReminderBottomSheetState extends State<_ReminderBottomSheet> {
  String _selectedQuick = 'Tomorrow';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime _displayMonth = DateTime.now();
  Duration _selectedTime = const Duration(hours: 2, minutes: 15);
  final _noteController = TextEditingController();

  final _quickOptions = ['In 1 Hour', 'Tomorrow', 'In 3 Days', 'Next Week'];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _selectQuick(String option) {
    setState(() {
      _selectedQuick = option;
      final now = DateTime.now();
      if (option == 'In 1 Hour') {
        _selectedDate = now.add(const Duration(hours: 1));
      } else if (option == 'Tomorrow') {
        _selectedDate = now.add(const Duration(days: 1));
      } else if (option == 'In 3 Days') {
        _selectedDate = now.add(const Duration(days: 3));
      } else if (option == 'Next Week') {
        _selectedDate = now.add(const Duration(days: 7));
      }
    });
  }

  void _prevMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 1);
    });
  }

  List<Widget> _buildCalendarDays() {
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDay = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7; // 0=Sun
    final cells = <Widget>[];
    // Leading blanks
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int d = 1; d <= lastDay.day; d++) {
      final date = DateTime(_displayMonth.year, _displayMonth.month, d);
      final isSelected =
          _selectedDate.day == d &&
          _selectedDate.month == _displayMonth.month &&
          _selectedDate.year == _displayMonth.year;
      final isToday =
          DateTime.now().day == d &&
          DateTime.now().month == _displayMonth.month &&
          DateTime.now().year == _displayMonth.year;
      cells.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
              _selectedQuick = '';
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$d',
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isToday
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF0F172A),
                fontSize: 13.sp,
                fontFamily: 'Inter',
                fontWeight: isSelected || isToday
                    ? FontWeight.w700
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final monthName = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ][_displayMonth.month - 1];
    final dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(99.r),
            ),
          ),
          // Title
          Text(
            'Set Reminder',
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: 18.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'for ${widget.lead.name}',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20.h),
          // Quick options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _quickOptions.map((opt) {
                final isSel = _selectedQuick == opt;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () => _selectQuick(opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSel
                            ? const Color(0xFF2563EB)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          color: isSel ? Colors.white : const Color(0xFF64748B),
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                          fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),
          // Calendar header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: const Color(0xFF64748B),
                  size: 24.r,
                ),
              ),
              Text(
                '$monthName ${_displayMonth.year}',
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 15.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF64748B),
                  size: 24.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Day labels
          Row(
            children: dayLabels.map((d) {
              return Expanded(
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 11.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 8.h),
          // Calendar grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            childAspectRatio: 1.2,
            children: _buildCalendarDays(),
          ),
          SizedBox(height: 16.h),
          // Time picker
          SizedBox(
            height: 100.h,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              initialTimerDuration: _selectedTime,
              onTimerDurationChanged: (d) {
                setState(() => _selectedTime = d);
              },
            ),
          ),
          SizedBox(height: 16.h),
          // Note input
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: TextField(
              controller: _noteController,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Inter',
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: 'Add a note (optional)',
                hintStyle: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Set Reminder button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              SnackbarHelper.showSuccess('Reminder set successfully!');
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                'Set Reminder',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
