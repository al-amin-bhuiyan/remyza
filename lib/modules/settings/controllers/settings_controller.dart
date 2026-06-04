import 'package:get/get.dart';

class SettingsController extends GetxController {
  final isNotificationsEnabled = true.obs;
  final isAutoReplyEnabled = true.obs;

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  void toggleAutoReply(bool value) {
    isAutoReplyEnabled.value = value;
  }
}

