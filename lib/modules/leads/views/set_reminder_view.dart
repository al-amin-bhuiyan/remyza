import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/interfaces/i_leads_repository.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../data/models/lead_model.dart';
import '../../../../data/models/activity_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SetReminderView extends StatefulWidget {
  const SetReminderView({super.key});

  @override
  State<SetReminderView> createState() => _SetReminderViewState();
}

class _SetReminderViewState extends State<SetReminderView> {
  late final ILeadsRepository _leadsRepository;
  List<LeadModel> _leads = [];
  LeadModel? _selectedLead;
  bool _isLoadingLeads = true;

  String _selectedQuick = 'Tomorrow';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime _displayMonth = DateTime.now();
  Duration _selectedTime = const Duration(hours: 9, minutes: 00);
  final _noteController = TextEditingController();
  bool _sendSmsNotification = true;
  bool _sendPushNotification = true;

  final _quickOptions = ['In 1 Hour', 'Tomorrow', 'In 3 Days', 'Next Week'];

  @override
  void initState() {
    super.initState();
    _leadsRepository = Get.find<ILeadsRepository>();
    _loadLeads();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadLeads() async {
    try {
      final leadsList = await _leadsRepository.getLeads();
      setState(() {
        _leads = leadsList;
        if (leadsList.isNotEmpty) {
          _selectedLead = leadsList.first;
        }
        _isLoadingLeads = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLeads = false;
      });
      SnackbarHelper.showError('Failed to load contacts');
    }
  }

  void _selectQuick(String option) {
    setState(() {
      _selectedQuick = option;
      final now = DateTime.now();
      if (option == 'In 1 Hour') {
        _selectedDate = now.add(const Duration(hours: 1));
        _selectedTime = Duration(hours: _selectedDate.hour, minutes: _selectedDate.minute);
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

    // Leading blank spaces for calendar weekday alignment
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int d = 1; d <= lastDay.day; d++) {
      final date = DateTime(_displayMonth.year, _displayMonth.month, d);
      final isSelected = _selectedDate.day == d &&
          _selectedDate.month == _displayMonth.month &&
          _selectedDate.year == _displayMonth.year;
      final isToday = DateTime.now().day == d &&
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
                fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
    return cells;
  }

  Future<void> _saveReminder() async {
    if (_selectedLead == null) {
      SnackbarHelper.showError('Please select a contact');
      return;
    }

    final reminderText = _noteController.text.trim().isNotEmpty
        ? _noteController.text.trim()
        : 'Follow-up with ${_selectedLead!.name}';

    final minutesStr = (_selectedTime.inMinutes % 60).toString().padLeft(2, '0');
    final hoursStr = (_selectedTime.inHours % 24).toString().padLeft(2, '0');
    final formattedTime = '$hoursStr:$minutesStr';

    final formattedDate = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

    final activity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Reminder Set',
      description: 'Scheduled follow-up on $formattedDate at $formattedTime. Note: $reminderText',
      time: 'Just now',
      icon: Icons.notifications_active_rounded,
    );

    try {
      await _leadsRepository.addLeadActivity(_selectedLead!.id, activity);
      SnackbarHelper.showSuccess('Reminder set successfully for ${_selectedLead!.name}!');
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      SnackbarHelper.showError('Failed to save reminder');
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthName = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ][_displayMonth.month - 1];

    final dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          'Set Reminder',
          style: TextStyle(
            color: const Color(0xFF021649),
            fontSize: 18.sp,
            fontFamily: 'Nunito Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoadingLeads
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: const Color(0xFF2563EB),
                size: 40.r,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Contact selector dropdown card
                    Text(
                      'Contact / Lead',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1.5, color: Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<LeadModel>(
                          value: _selectedLead,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF64748B), size: 24.r),
                          items: _leads.map((lead) {
                            return DropdownMenuItem<LeadModel>(
                              value: lead,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12.r,
                                    backgroundColor: lead.avatarColor,
                                    child: Text(
                                      lead.initials,
                                      style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    lead.name,
                                    style: TextStyle(
                                      color: const Color(0xFF0F172A),
                                      fontSize: 14.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: lead.borderColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      lead.status.toUpperCase(),
                                      style: TextStyle(
                                        color: lead.borderColor,
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _selectedLead = val;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Section 2: Date Selector Card
                    Text(
                      'Date & Time',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Quick Date Options
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
                                        color: isSel ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
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
                          SizedBox(height: 16.h),
                          // Month selector header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: _prevMonth,
                                child: Icon(Icons.chevron_left_rounded, color: const Color(0xFF64748B), size: 24.r),
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
                                child: Icon(Icons.chevron_right_rounded, color: const Color(0xFF64748B), size: 24.r),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          // Weekdays header
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
                          // Calendar Grid
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 7,
                            childAspectRatio: 1.2,
                            children: _buildCalendarDays(),
                          ),
                          SizedBox(height: 12.h),
                          const Divider(color: Color(0xFFF1F5F9)),
                          SizedBox(height: 12.h),
                          // Time Picker
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Time',
                                style: TextStyle(
                                  color: const Color(0xFF475569),
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${(_selectedTime.inHours % 24).toString().padLeft(2, '0')}:${(_selectedTime.inMinutes % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: const Color(0xFF2563EB),
                                  fontSize: 15.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Section 3: Note Input Area
                    Text(
                      'Note / Task description',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      ),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Inter',
                          color: const Color(0xFF0F172A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g., Call client back to discuss subscription plans...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF94A3B8),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Section 4: Notification Channels Toggle Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 20.r, color: const Color(0xFF2563EB)),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Send SMS Reminder Alert',
                                    style: TextStyle(color: const Color(0xFF0F172A), fontSize: 13.sp, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _sendSmsNotification,
                                onChanged: (val) {
                                  setState(() => _sendSmsNotification = val);
                                },
                                activeThumbColor: Colors.white,
                                activeTrackColor: const Color(0xFF22C55E),
                              ),
                            ],
                          ),
                          const Divider(color: Color(0xFFF1F5F9)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.notifications_active_outlined, size: 20.r, color: const Color(0xFF7C3AED)),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Push Notification Reminder',
                                    style: TextStyle(color: const Color(0xFF0F172A), fontSize: 13.sp, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _sendPushNotification,
                                onChanged: (val) {
                                  setState(() => _sendPushNotification = val);
                                },
                                activeThumbColor: Colors.white,
                                activeTrackColor: const Color(0xFF22C55E),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Centered save action button
                    GestureDetector(
                      onTap: _saveReminder,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0249AA),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0249AA).withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          'Save Reminder',
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
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
    );
  }
}
