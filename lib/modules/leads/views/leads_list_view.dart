import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/leads_list_controller.dart';
import '../../../../data/models/lead_model.dart';

class LeadsListView extends GetView<LeadsListController> {
  const LeadsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: const Color(0xFF26B14E),
                      size: 40.r,
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      _buildSummaryCards(),
                      SizedBox(height: 24.h),
                      _buildFilterChips(),
                      SizedBox(height: 12.h),
                      _buildLeadsList(),
                      SizedBox(height: 120.h),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Leads',
            style: TextStyle(
              color: const Color(0xFF021649),
              fontSize: 20.sp,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Row(
          children: [
            Expanded(
              child: _SummaryCard(
                emoji: '🔥',
                count: controller.hotCount,
                label: 'Hot Leads',
                color: const Color(0xFF26B14E),
                isSelected: controller.selectedFilter.value == 'hot',
                onTap: () => controller.changeFilter(
                  controller.selectedFilter.value == 'hot' ? 'all' : 'hot',
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _SummaryCard(
                emoji: '☀️',
                count: controller.warmCount,
                label: 'Warm Leads',
                color: const Color(0xFF3B82F6),
                isSelected: controller.selectedFilter.value == 'warm',
                onTap: () => controller.changeFilter(
                  controller.selectedFilter.value == 'warm' ? 'all' : 'warm',
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _SummaryCard(
                emoji: '❄️',
                count: controller.coldCount,
                label: 'Cold Leads',
                color: const Color(0xFFEF5744),
                isSelected: controller.selectedFilter.value == 'cold',
                onTap: () => controller.changeFilter(
                  controller.selectedFilter.value == 'cold' ? 'all' : 'cold',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['all', 'hot', 'warm', 'cold'];
    final labels = ['All', 'Hot 🔥', 'Warm ☀️', 'Cold ❄️'];
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Row(
          children: List.generate(filters.length, (i) {
            final isSelected = controller.selectedFilter.value == filters[i];
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => controller.changeFilter(filters[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF021649) : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF021649)
                          : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFF021649,
                              ).withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildLeadsList() {
    return Obx(() {
      final items = controller.filteredLeads;
      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 60.h),
            child: Column(
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 56.r,
                  color: const Color(0xFFD1D5DB),
                ),
                SizedBox(height: 12.h),
                Text(
                  'No leads found',
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 15.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Column(
          children: items
              .map(
                (lead) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _LeadCard(lead: lead),
                ),
              )
              .toList(),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
// Summary Card
// ─────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String emoji;
  final int count;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _SummaryCard({
    required this.emoji,
    required this.count,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.r),
        decoration: ShapeDecoration(
          color: isSelected ? color.withValues(alpha: 0.07) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: color),
            borderRadius: BorderRadius.circular(20.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: TextStyle(fontSize: 22.sp)),
            SizedBox(height: 6.h),
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 22.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Lead Card
// ─────────────────────────────────────────────
class _LeadCard extends StatelessWidget {
  final LeadModel lead;

  const _LeadCard({required this.lead});

  @override
  Widget build(BuildContext context) {
    final scorePercent = (lead.score * 100).toInt();
    final Color scoreColor = lead.score >= 0.7
        ? const Color(0xFF22C55E)
        : lead.score >= 0.45
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);

    return GestureDetector(
      onTap: () => context.push('/lead/${lead.id}'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.5, color: lead.borderColor),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: lead.borderColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                lead.initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lead.name,
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        lead.time,
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  // Last message
                  Text(
                    lead.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 12.sp,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Score bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999.r),
                          child: Stack(
                            children: [
                              // Background track
                              Container(
                                height: 5.h,
                                color: const Color(0xFFE2E8F0),
                              ),
                              // Gradient fill clipped to score
                              FractionallySizedBox(
                                widthFactor: lead.score.clamp(0.0, 1.0),
                                child: Container(
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFEF4444),
                                        Color(0xFFF59E0B),
                                        Color(0xFF22C55E),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(999.r),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$scorePercent%',
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 11.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16.r,
                        color: const Color(0xFFCBD5E1),
                      ),
                    ],
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
