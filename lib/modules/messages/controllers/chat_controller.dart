import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/interfaces/i_messages_repository.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../../data/models/message_model.dart';

class ChatController extends GetxController {
  final IMessagesRepository _repository;
  final String conversationId;

  ChatController(this._repository, this.conversationId);

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final Rxn<ConversationModel> conversation = Rxn<ConversationModel>();
  final RxBool isLoading = false.obs;
  final RxBool isAiAutoReplyEnabled = false.obs;
  final RxDouble score = 0.0.obs;
  final RxnString aiSuggestion = RxnString('Schedule a brief demo call for tomorrow at 2 PM');

  final TextEditingController messageInputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadConversationDetails();
    loadMessages();
  }

  @override
  void onClose() {
    messageInputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadConversationDetails() async {
    try {
      final list = await _repository.getConversations();
      final item = list.firstWhereOrNull((c) => c.id == conversationId);
      if (item != null) {
        conversation.value = item;
        isAiAutoReplyEnabled.value = item.isAiActive;
        score.value = item.score;
      }
    } catch (e) {
      Get.log('Error loading conversation details: $e');
    }
  }

  Future<void> loadMessages() async {
    try {
      isLoading.value = true;
      final list = await _repository.getMessages(conversationId);
      messages.assignAll(list);
      _scrollToBottom();
    } catch (e) {
      Get.log('Error loading messages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;
    messageInputController.clear();

    try {
      // Add message locally & to repo
      await _repository.sendMessage(conversationId, text);
      await loadMessages();

      // Trigger automatic scroll
      _scrollToBottom();

      // Simulated Response Loop
      _simulateResponse(text);
    } catch (e) {
      Get.log('Error sending message: $e');
    }
  }

  Future<void> toggleAiAutoReply(bool enabled) async {
    isAiAutoReplyEnabled.value = enabled;
    try {
      await _repository.toggleAiAutoReply(conversationId, enabled);
    } catch (e) {
      Get.log('Error toggling AI auto-reply: $e');
    }
  }

  void useSuggestion() {
    if (aiSuggestion.value != null) {
      messageInputController.text = aiSuggestion.value!;
      aiSuggestion.value = null; // Clear suggestion once used
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _simulateResponse(String userText) {
    // Wait a brief period and add a response
    Future.delayed(const Duration(milliseconds: 1500), () async {
      final isAiActive = isAiAutoReplyEnabled.value;
      
      if (isAiActive) {
        // AI sends auto reply
        final aiMessage = MessageModel(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
          text: "Hi! This is Remyza AI. I've noted that you asked: \"$userText\". I'm analyzing your request to help you schedule/pricing options.",
          time: _formatCurrentTime(),
          isMe: true,
          isSentByAi: true,
        );
        messages.add(aiMessage);
      } else {
        // Customer responds
        final responseMessage = MessageModel(
          id: 'cust_${DateTime.now().millisecondsSinceEpoch}',
          text: "Thanks! Let me know what you think.",
          time: _formatCurrentTime(),
          isMe: false,
          senderName: conversation.value?.name ?? 'Customer',
        );
        messages.add(responseMessage);
        
        // Generate a new AI suggestion
        aiSuggestion.value = "Schedule a meeting with ${conversation.value?.name ?? 'them'} next Tuesday";
      }
      _scrollToBottom();
    });
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}
