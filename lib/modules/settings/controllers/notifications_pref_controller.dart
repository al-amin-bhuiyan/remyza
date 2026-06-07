import 'package:get/get.dart';

class NotificationsPrefController extends GetxController {
  final isPushEnabled = true.obs;
  final isEmailEnabled = true.obs;
  final isSmsEnabled = false.obs;
  final isLeadAlertsEnabled = true.obs;
  final isWeeklyDigestEnabled = true.obs;

  void togglePush(bool value) {
    isPushEnabled.value = value;
  }

  void toggleEmail(bool value) {
    isEmailEnabled.value = value;
  }

  void toggleSms(bool value) {
    isSmsEnabled.value = value;
  }

  void toggleLeadAlerts(bool value) {
    isLeadAlertsEnabled.value = value;
  }

  void toggleWeeklyDigest(bool value) {
    isWeeklyDigestEnabled.value = value;
  }
}
