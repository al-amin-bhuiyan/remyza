import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SendEmailView extends StatefulWidget {
  const SendEmailView({super.key});

  @override
  State<SendEmailView> createState() => _SendEmailViewState();
}

class _SendEmailViewState extends State<SendEmailView> {
  final _subjectController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: const Color(0xFF0249AA),
                size: 20.r,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Thank you! Your support request has been submitted successfully.',
                  style: TextStyle(
                    color: const Color(0xFF0249AA),
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEFF6FF),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.r),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate back
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
          'Send Email',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Input Group
                      _buildInputCard(
                        title: 'Subject',
                        child: TextFormField(
                          controller: _subjectController,
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Please enter a subject'
                              : null,
                          decoration: _buildInputDecoration('Short title of your issue or suggestion'),
                          style: _buildInputTextStyle(),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Email Address Input Group
                      _buildInputCard(
                        title: 'Email Address',
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!GetUtils.isEmail(val.trim())) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          decoration: _buildInputDecoration('Write your email'),
                          style: _buildInputTextStyle(),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Message Input Group
                      _buildInputCard(
                        title: 'Message',
                        child: Container(
                          height: 200.h,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFDBE6F5),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.50,
                                color: const Color(0xFF89A9D4),
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: TextFormField(
                            controller: _messageController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            validator: (val) => val == null || val.trim().isEmpty
                                ? 'Please enter your message'
                                : null,
                            decoration: InputDecoration(
                              hintText: 'Please explain what happened...',
                              hintStyle: TextStyle(
                                color: Colors.black.withValues(alpha: 0.40),
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16.r),
                            ),
                            style: _buildInputTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),

              // Bottom Submit Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
                child: GestureDetector(
                  onTap: _submitForm,
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF0249AA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildInputCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: const Color(0xFFEBF3FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontSize: 16.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.black.withValues(alpha: 0.40),
        fontSize: 14.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: const Color(0xFFDBE6F5),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          width: 0.50,
          color: const Color(0xFF89A9D4),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          width: 0.50,
          color: const Color(0xFF89A9D4),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
          width: 1.0,
          color: const Color(0xFF0249AA),
        ),
      ),
    );
  }

  TextStyle _buildInputTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 14.sp,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
    );
  }
}
