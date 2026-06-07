import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/snackbar_helper.dart';

class AutoCaptureController extends GetxController {
  final String cheseraNumber = '+1 (555) 014-7382';
  final RxBool autoCreateLead = true.obs;
  final RxString welcomeMessage =
      'Hi! 👋 Thanks for reaching out to us. We\'re excited to connect with you! A member of our team will be in touch shortly. In the meantime, feel free to ask any questions!'
          .obs;

  final RxInt simulationStep = 0.obs;
  final RxBool isSimulating = false.obs;

  // Welcome Message Edit States
  final RxString currentTone = 'Professional'.obs;
  final RxString tempMessageText = ''.obs;
  final RxInt characterCount = 0.obs;

  void initializeWelcomeMessage() {
    tempMessageText.value = welcomeMessage.value;
    characterCount.value = welcomeMessage.value.length;
  }

  void updateMessageText(String text) {
    tempMessageText.value = text;
    characterCount.value = text.length;
  }

  void setTone(String tone) {
    currentTone.value = tone;
  }

  void regenerateWithAI() {
    String generatedText = '';
    switch (currentTone.value) {
      case 'Friendly':
        generatedText =
            'Hey there! 😊 Thanks for messaging us. We can\'t wait to chat! We will get back to you super fast. Let us know if you have any questions!';
        break;
      case 'Casual':
        generatedText =
            'Hey! Thanks for dropping a line. We\'ll get back to you soon. What\'s on your mind today?';
        break;
      case 'Professional':
      default:
        generatedText =
            'Hi! 👋 Thanks for reaching out to us. We\'re excited to connect with you! A member of our team will be in touch shortly. In the meantime, feel free to ask any questions!';
        break;
    }
    updateMessageText(generatedText);
    SnackbarHelper.showSuccess('Regenerated message in ${currentTone.value} tone!');
  }

  void saveWelcomeMessage() {
    welcomeMessage.value = tempMessageText.value;
    SnackbarHelper.showSuccess('Welcome message saved successfully!');
  }

  void toggleAutoCreateLead(bool value) {
    autoCreateLead.value = value;
    SnackbarHelper.showSuccess(
      value ? 'Auto-create lead enabled' : 'Auto-create lead disabled',
    );
  }

  Future<void> copyNumberToClipboard() async {
    try {
      await Clipboard.setData(ClipboardData(text: cheseraNumber));
      SnackbarHelper.showSuccess('Chesera number copied to clipboard!');
    } catch (e) {
      SnackbarHelper.showError('Failed to copy number: $e');
    }
  }

  void testAutoCapture() {
    SnackbarHelper.showSuccess('Test Auto-Capture simulated successfully!');
  }

  Future<void> startSimulation(BuildContext context) async {
    if (isSimulating.value) return;
    isSimulating.value = true;
    simulationStep.value = 0;

    for (int i = 1; i <= 4; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      simulationStep.value = i;
    }

    isSimulating.value = false;
    SnackbarHelper.showSuccess('Simulation completed successfully!');
    if (context.mounted) {
      context.push(AppRoutes.welcomeMessageEdit);
    }
  }
}
