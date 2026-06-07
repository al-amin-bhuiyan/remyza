import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isNotificationsEnabled = true.obs;
  final isAutoReplyEnabled = true.obs;
  
  // New AI Settings state variables
  final selectedTone = 'Friendly'.obs; // 'Professional', 'Friendly', 'Casual'
  final selectedReplySpeed = 'Within 1 min'.obs; // 'Instant', 'Within 1 min', 'Within 5 min'
  final aiPersonality = 0.5.obs; // Slider value between 0.0 (Formal) and 1.0 (Conversational)
  final isFollowUpAutomationEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  void toggleAutoReply(bool value) {
    isAutoReplyEnabled.value = value;
  }

  void setSelectedTone(String tone) {
    selectedTone.value = tone;
  }

  void setSelectedReplySpeed(String speed) {
    selectedReplySpeed.value = speed;
  }

  void setAiPersonality(double value) {
    aiPersonality.value = value;
  }

  void toggleFollowUpAutomation(bool value) {
    isFollowUpAutomationEnabled.value = value;
  }
}
