import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/interfaces/i_messages_repository.dart';
import '../../../../core/utils/snackbar_helper.dart';

class NewMessageController extends GetxController {
  final IMessagesRepository _repository;

  NewMessageController(this._repository);

  final TextEditingController toController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final RxString toQuery = ''.obs;
  final RxString selectedTone = 'Casual'.obs;
  final RxInt characterCount = 0.obs;
  final RxBool isLoading = false.obs;

  final List<String> tones = ['Professional', 'Friendly', 'Casual'];

  final List<String> mockContacts = [
    'John Doe',
    'Amy Lin',
    'Sarah Mitchell',
    'Tom Kim',
    'Robert Park',
    'Maria Brown',
    'Alex Wong',
    'Jessica Taylor',
  ];

  final RxList<String> filteredContacts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    toController.addListener(_onToChanged);
    messageController.addListener(_onMessageChanged);
  }

  @override
  void onClose() {
    toController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void _onToChanged() {
    final query = toController.text.trim().toLowerCase();
    toQuery.value = query;
    if (query.isEmpty) {
      filteredContacts.clear();
    } else {
      filteredContacts.assignAll(
        mockContacts.where((c) => c.toLowerCase().contains(query)).toList(),
      );
    }
  }

  void _onMessageChanged() {
    characterCount.value = messageController.text.length;
  }

  void selectContact(String name) {
    toController.text = name;
    toQuery.value = name;
    filteredContacts.clear();
  }

  void selectTone(String tone) {
    selectedTone.value = tone;
  }

  void generateAiAssistMessage() {
    final name = toController.text.trim();
    final recipient = name.isNotEmpty ? name : 'there';
    
    String text = '';
    switch (selectedTone.value) {
      case 'Professional':
        text = "Dear $recipient,\n\nI hope this message finds you well. I would like to schedule a brief call next week to discuss our services and see how we can assist you. Let me know what times work best for you.";
        break;
      case 'Friendly':
        text = "Hi $recipient! 😊\n\nHope you're having a great day! I wanted to follow up and see if you had any questions about our pricing packages. Let's chat soon!";
        break;
      case 'Casual':
      default:
        text = "Hey $recipient! Quick question - do you have 10 mins for a quick chat tomorrow? Let me know, thanks!";
        break;
    }
    
    messageController.text = text;
  }

  Future<bool> sendMessage() async {
    final recipient = toController.text.trim();
    final text = messageController.text.trim();

    if (recipient.isEmpty) {
      SnackbarHelper.showError('Please select or enter a recipient.');
      return false;
    }
    if (text.isEmpty) {
      SnackbarHelper.showError('Please enter a message to send.');
      return false;
    }

    try {
      isLoading.value = true;
      // Simulate sending via repository
      await _repository.sendMessage('1', text);
      await Future.delayed(const Duration(milliseconds: 500));
      SnackbarHelper.showSuccess('Message sent successfully to $recipient!');
      return true;
    } catch (e) {
      Get.log('Error sending new message: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
