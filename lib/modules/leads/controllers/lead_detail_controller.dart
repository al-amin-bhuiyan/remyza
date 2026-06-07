import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/interfaces/i_leads_repository.dart';
import '../../../../data/models/lead_model.dart';
import '../../../../data/models/activity_model.dart';
import '../../../../data/models/message_model.dart';

class LeadDetailController extends GetxController {
  final ILeadsRepository _repository;
  final String leadId;

  LeadDetailController(this._repository, this.leadId);

  final Rxn<LeadModel> lead = Rxn<LeadModel>();
  final RxInt selectedTab = 0.obs; // 0=Activity, 1=Conversation, 2=Info, 3=AI Suggestions
  final RxBool isLoading = false.obs;
  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxList<ActivityModel> activities = <ActivityModel>[].obs;
  final RxnString aiUsedSuggestion = RxnString();

  final TextEditingController messageInputController = TextEditingController();
  final TextEditingController noteInputController = TextEditingController();
  final ScrollController conversationScrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadLead();
  }

  @override
  void onClose() {
    messageInputController.dispose();
    noteInputController.dispose();
    conversationScrollController.dispose();
    super.onClose();
  }

  Future<void> loadLead() async {
    try {
      isLoading.value = true;
      final fetched = await _repository.getLeadById(leadId);
      if (fetched != null) {
        lead.value = fetched;
        messages.assignAll(fetched.messages);
        activities.assignAll(fetched.activities);
      }
    } catch (e) {
      Get.log('Error loading lead: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
  }

  Future<void> sendMessage() async {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;
    messageInputController.clear();

    final msg = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      time: _formatTime(),
      isMe: true,
      isSentByAi: false,
    );
    messages.add(msg);
    _scrollToBottom();

    try {
      await _repository.sendLeadMessage(leadId, text);
    } catch (e) {
      Get.log('Error sending lead message: $e');
    }

    // Simulate lead reply
    Future.delayed(const Duration(milliseconds: 1400), () {
      final reply = MessageModel(
        id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
        text: "Thanks, I'll get back to you shortly.",
        time: _formatTime(),
        isMe: false,
        senderName: lead.value?.name ?? 'Lead',
      );
      messages.add(reply);
      _scrollToBottom();
    });
  }

  Future<void> addNote() async {
    final text = noteInputController.text.trim();
    if (text.isEmpty) return;
    noteInputController.clear();

    final activity = ActivityModel(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Note Added',
      description: text,
      time: 'Just now',
      icon: Icons.note_alt_outlined,
    );
    activities.insert(0, activity);

    try {
      await _repository.addLeadActivity(leadId, activity);
    } catch (e) {
      Get.log('Error adding activity: $e');
    }
  }

  void useSuggestion(String suggestion) {
    messageInputController.text = suggestion;
    aiUsedSuggestion.value = suggestion;
    selectTab(1); // switch to Conversation tab
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (conversationScrollController.hasClients) {
        conversationScrollController.animateTo(
          conversationScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
