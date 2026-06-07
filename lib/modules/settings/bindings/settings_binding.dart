import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../controllers/notifications_pref_controller.dart';
import '../controllers/auto_capture_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController());
    Get.lazyPut<NotificationsPrefController>(() => NotificationsPrefController());
    Get.lazyPut<AutoCaptureController>(() => AutoCaptureController());
  }
}
