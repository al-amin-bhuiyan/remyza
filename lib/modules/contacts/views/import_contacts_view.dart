import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/import_contacts_controller.dart';
import '../../../core/utils/snackbar_helper.dart';

class ImportContactsView extends GetView<ImportContactsController> {
  const ImportContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Center(
            child: GestureDetector(
              onTap: () {
                if (controller.currentStep.value > 1) {
                  controller.currentStep.value--;
                } else {
                  context.pop();
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
          ),
        ),
        title: Text(
          'Import Contacts',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final step = controller.currentStep.value;
          return Column(
            children: [
              // 1. Stepper Progress Header
              _buildProgressStepper(step),
              SizedBox(height: 16.h),

              // 2. Main Step Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 8.h),
                  child: _buildStepContent(context, step),
                ),
              ),

              // 3. Bottom Button
              _buildBottomButton(context, step),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProgressStepper(int currentStep) {
    final hasFile = controller.fileName.value.isNotEmpty;

    final step1Status = (currentStep > 1 || (currentStep == 1 && hasFile)) 
        ? 'completed' 
        : 'active';
    final divider1Active = (currentStep > 1 || (currentStep == 1 && hasFile));

    final step2Status = currentStep > 2 
        ? 'completed' 
        : (currentStep == 2 ? 'active' : 'inactive');
    final divider2Active = currentStep > 2;

    final step3Status = currentStep >= 3 ? 'completed' : 'inactive';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStepIndicator(1, 'Upload', step1Status),
          _buildStepDivider(divider1Active),
          _buildStepIndicator(2, 'Map', step2Status),
          _buildStepDivider(divider2Active),
          _buildStepIndicator(3, 'Confirm', step3Status),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepNum, String label, String status) {
    Color circleColor;
    Color textColor;
    Color labelColor;
    FontWeight labelWeight;

    if (status == 'completed') {
      circleColor = const Color(0xFF22C55E);
      textColor = Colors.white;
      labelColor = const Color(0xFF22C55E);
      labelWeight = FontWeight.w600;
    } else if (status == 'active') {
      circleColor = const Color(0xFF2563EB);
      textColor = Colors.white;
      labelColor = const Color(0xFF2563EB);
      labelWeight = FontWeight.w600;
    } else {
      circleColor = const Color(0xFFE2E8F0);
      textColor = const Color(0xFF94A3B8);
      labelColor = const Color(0xFF94A3B8);
      labelWeight = FontWeight.w400;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28.r,
          height: 28.r,
          decoration: ShapeDecoration(
            color: circleColor,
            shape: const CircleBorder(),
          ),
          child: Center(
            child: Text(
              '$stepNum',
              style: TextStyle(
                color: textColor,
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: labelWeight,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      width: 60.w,
      height: 2.h,
      margin: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 16.h),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, int step) {
    switch (step) {
      case 1:
        return _buildUploadStep(context);
      case 2:
        return _buildMapStep();
      case 3:
        return _buildConfirmStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- STEP 1: UPLOAD ---
  Widget _buildUploadStep(BuildContext context) {
    final hasFile = controller.fileName.value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasFile) ...[
          // Dashed upload container
          GestureDetector(
            onTap: controller.pickCSVFile,
            child: Container(
              width: double.infinity,
              height: 250.h,
              padding: EdgeInsets.all(32.r),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                    color: Color(0xFFC4C5D9),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (controller.isProcessing.value)
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: const Color(0xFF2E5BFF),
                      size: 40.r,
                    )
                  else ...[
                    Container(
                      width: 72.r,
                      height: 72.r,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF2E5BFF),
                        shape: CircleBorder(),
                      ),
                      child: Icon(
                        Icons.file_upload_outlined,
                        color: Colors.white,
                        size: 36.r,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Upload CSV or file',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF191B24),
                        fontSize: 20.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Tap to browse files or drag & drop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF747688),
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _buildProTipCard(),
        ] else ...[
          // File Loaded UI
          _buildSelectedFileCard(),
          SizedBox(height: 24.h),
          _buildFilePreviewTable(),
        ],
      ],
    );
  }

  Widget _buildSelectedFileCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFF1F5F9),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: ShapeDecoration(
              color: const Color(0xFFF0FDF4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.table_chart_outlined,
                color: const Color(0xFF22C55E),
                size: 22.r,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.fileName.value,
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${controller.totalRows.value} rows · ${controller.fileSizeKb.value} KB',
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: const Color(0xFF22C55E),
            size: 20.r,
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: controller.clearSelectedFile,
            child: Icon(
              Icons.close,
              color: const Color(0xFF94A3B8),
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreviewTable() {
    return Container(
      width: double.infinity,
      height: 380.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF8F9FC),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Color(0xFFE2E8F0),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                      child: Text(
                        'FILE PREVIEW',
                        style: TextStyle(
                          color: const Color(0xFF475569),
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110.w,
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120.w,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: controller.previewRows.length,
            itemBuilder: (context, index) {
              final row = controller.previewRows[index];
              final name = row.isNotEmpty ? row[0] : '';
              final phone = row.length > 1 ? row[1] : '';
              final email = row.length > 2 ? row[2] : '';

              return GestureDetector(
                onTap: () async {
                  try {
                    final clipboardText = 'Name: $name\nPhone: $phone\nEmail: $email';
                    await Clipboard.setData(ClipboardData(text: clipboardText));
                    SnackbarHelper.showSuccess('Copied row details to clipboard!');
                  } catch (e) {
                    SnackbarHelper.showError('Failed to copy: $e');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110.w,
                        child: Text(
                          phone,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProTipCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFFBEB),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFFDE68A),
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: const Color(0xFF92400E),
            size: 20.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pro Tip',
                  style: TextStyle(
                    color: const Color(0xFF92400E),
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Make sure your CSV has columns for Name, Phone, and Email. Chesera will auto-map common column names.',
                  style: TextStyle(
                    color: const Color(0xFF92400E),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Map CSV Columns',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "Match your CSV columns to Chesera fields. We've auto-detected some matches for you.",
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 13.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        Obx(() {
          if (controller.mappedNameHeader.value.isEmpty || controller.mappedPhoneHeader.value.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              if (controller.duplicateCount.value > 0) ...[
                _buildDuplicatesWarningCard(controller.duplicateCount.value),
                SizedBox(height: 16.h),
              ],
              _buildSkipDuplicatesToggleCard(),
              SizedBox(height: 24.h),
              _buildMappedPreviewTable(),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildDuplicatesWarningCard(int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFFBEB),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFFDE68A),
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: const Color(0xFFD97706),
            size: 20.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '$count duplicates found — phone numbers already in your contacts list',
              style: TextStyle(
                color: const Color(0xFFB45309),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipDuplicatesToggleCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFF1F5F9),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skip duplicate numbers',
                  style: TextStyle(
                    color: const Color(0xFF0F172A),
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Don't import numbers already in Chesera",
                  style: TextStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
            value: controller.skipDuplicates.value,
            activeThumbColor: const Color(0xFF22C55E),
            activeTrackColor: const Color(0xFFDCFCE7),
            onChanged: (val) {
              controller.skipDuplicates.value = val;
            },
          )),
        ],
      ),
    );
  }

  Widget _buildMappedPreviewTable() {
    return Container(
      width: double.infinity,
      height: 240.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF8F9FC),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Color(0xFFE2E8F0),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                      child: Text(
                        'MAPPED PREVIEW',
                        style: TextStyle(
                          color: const Color(0xFF475569),
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 110.w,
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120.w,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Obx(() => ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: controller.previewRows.length,
            itemBuilder: (context, index) {
              final row = controller.previewRows[index];
              final name = row.isNotEmpty ? row[0] : '';
              final phone = row.length > 1 ? row[1] : '';
              final email = row.length > 2 ? row[2] : '';

              return GestureDetector(
                onTap: () async {
                  try {
                    final clipboardText = 'Name: $name\nPhone: $phone\nEmail: $email';
                    await Clipboard.setData(ClipboardData(text: clipboardText));
                    SnackbarHelper.showSuccess('Copied row details to clipboard!');
                  } catch (e) {
                    SnackbarHelper.showError('Failed to copy: $e');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110.w,
                        child: Text(
                          phone,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0F172A),
                            fontSize: 12.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ),
      ),
    );
  }



  // --- STEP 3: CONFIRM ---
  Widget _buildConfirmStep() {
    final total = controller.parsedContacts.length + controller.duplicateCount.value + controller.invalidCount.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Stats Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFF1F5F9),
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 6,
                offset: Offset(0, 1),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$total contacts found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF2563EB),
                      fontSize: 22.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'from ${controller.fileName.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF64748B),
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Valid Box
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF0FDF4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${controller.parsedContacts.length}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF22C55E),
                              fontSize: 18.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.44,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Valid',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF22C55E),
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Duplicates Box
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFFBEB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${controller.duplicateCount.value}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFF59E0B),
                              fontSize: 18.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.44,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Duplicates',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFF59E0B),
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Invalid Box
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFEF2F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${controller.invalidCount.value}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFEF4444),
                              fontSize: 18.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w800,
                              height: 1.44,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Invalid',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFEF4444),
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // 2. Sample Contacts Table
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFE2E8F0),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: const ShapeDecoration(
                  color: Color(0xFFF8F9FC),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Text(
                  'SAMPLE CONTACTS',
                  style: TextStyle(
                    color: const Color(0xFF475569),
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                  ),
                ),
              ),
              // List first 3 items in parsedContacts
              ...controller.parsedContacts.take(3).map((contact) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 34.r,
                        height: 34.r,
                        decoration: ShapeDecoration(
                          color: contact.avatarColor,
                          shape: const CircleBorder(),
                        ),
                        child: Center(
                          child: Text(
                            contact.initials,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.name,
                              style: TextStyle(
                                color: const Color(0xFF0F172A),
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              contact.phone,
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // 3. AI Switch Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFF1F5F9),
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 6,
                offset: Offset(0, 1),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start AI auto-reply after import',
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Automatically send welcome messages to new contacts',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 12.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => Switch(
                value: controller.startAiAutoReply.value,
                activeThumbColor: const Color(0xFF22C55E),
                activeTrackColor: const Color(0xFFDCFCE7),
                onChanged: (val) {
                  controller.startAiAutoReply.value = val;
                },
              )),
            ],
          ),
        ),
      ],
    );
  }

  // --- BOTTOM BUTTON ---
  Widget _buildBottomButton(BuildContext context, int step) {
    bool isButtonActive = false;
    String buttonText = '';
    VoidCallback? onTap;

    if (step == 1) {
      isButtonActive = controller.fileName.value.isNotEmpty;
      buttonText = 'Next: Map Columns →';
      onTap = () {
        if (isButtonActive) {
          controller.currentStep.value = 2;
        }
      };
    } else if (step == 2) {
      isButtonActive = controller.canProceedToPreview;
      buttonText = 'Next: Confirm Import →';
      onTap = controller.proceedToPreview;
    } else if (step == 3) {
      isButtonActive = controller.parsedContacts.isNotEmpty;
      buttonText = 'Confirm & Import';
      onTap = controller.importContacts;
    }

    final activeColor = const Color(0xFF0249AA);
    final disabledColor = const Color(0xFF949CA9);

    if (step == 3) {
      return Container(
        width: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: isButtonActive ? onTap : null,
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: ShapeDecoration(
                  color: isButtonActive ? activeColor : disabledColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Import ${controller.parsedContacts.length} Contacts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                controller.clearSelectedFile();
                context.pop();
              },
              child: SizedBox(
                width: double.infinity,
                height: 40.h,
                child: Center(
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF949CA9),
                      fontSize: 16.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.38,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
      child: GestureDetector(
        onTap: isButtonActive ? onTap : null,
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: ShapeDecoration(
            color: isButtonActive ? activeColor : disabledColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
