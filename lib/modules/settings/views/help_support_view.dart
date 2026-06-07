import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';

class HelpSupportView extends StatefulWidget {
  const HelpSupportView({super.key});

  @override
  State<HelpSupportView> createState() => _HelpSupportViewState();
}

class _HelpSupportViewState extends State<HelpSupportView> {
  int? _expandedFaqIndex;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How does AI auto-reply work?',
      'answer': 'Our AI automatically replies to incoming messages based on context, your configured reply speed, and chosen tone to keep leads engaged.',
    },
    {
      'question': 'How do I import contacts from a CSV file?',
      'answer': 'Navigate to the Leads/Contacts tab and click on the "Import" button at the top right, then select your CSV file.',
    },
    {
      'question': 'What is a "Hot Lead" vs "Cold Lead"?',
      'answer': 'A Hot Lead is someone with high interaction score and frequent messages, while a Cold Lead has low interaction score and has not engaged recently.',
    },
    {
      'question': 'Can I change my Chesera SMS number?',
      'answer': 'Yes, you can request a number change under Account settings -> My SMS Number.',
    },
    {
      'question': 'How do I cancel my subscription?',
      'answer': 'You can manage or cancel your subscription by visiting settings -> My Plan -> Manage Subscription.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
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
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular Questions Header
            Text(
              'Popular Questions',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),

            // FAQs List Container
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Column(
                children: List.generate(_faqs.length, (index) {
                  final isExpanded = _expandedFaqIndex == index;
                  return _buildFaqItem(
                    index: index,
                    question: _faqs[index]['question']!,
                    answer: _faqs[index]['answer']!,
                    isExpanded: isExpanded,
                    showDivider: index < _faqs.length - 1,
                  );
                }),
              ),
            ),
            SizedBox(height: 32.h),

            // Still need help Section
            Text(
              'Still need help?',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () => context.push(AppRoutes.sendEmail),
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: ShapeDecoration(
                  color: const Color(0xFF0249AA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Delete Account Card
            GestureDetector(
              onTap: () => _showDeleteAccountDialog(context),
              child: Container(
                width: double.infinity,
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Delete Account',
                      style: TextStyle(
                        color: const Color(0xFFEE6C61),
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.delete_outline_rounded,
                      color: const Color(0xFFEE6C61),
                      size: 24.r,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required int index,
    required String question,
    required String answer,
    required bool isExpanded,
    required bool showDivider,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedFaqIndex = isExpanded ? null : index;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF64748B),
                  size: 20.r,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Text(
              answer,
              style: TextStyle(
                color: const Color(0xFF475569),
                fontSize: 13.sp,
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
          ),
        if (showDivider)
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone and all your lead data will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: const Color(0xFFEF4444),
                          size: 20.r,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Your account delete request has been submitted.',
                          style: TextStyle(
                            color: const Color(0xFFEF4444),
                            fontSize: 13.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: const Color(0xFFFEF2F2),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16.r),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ],
        );
      },
    );
  }
}
