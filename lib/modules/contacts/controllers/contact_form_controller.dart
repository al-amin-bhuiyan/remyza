import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'contacts_list_controller.dart';
import '../../../data/models/contact_model.dart';
import '../../../core/utils/snackbar_helper.dart';

class ContactFormController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final businessNameController = TextEditingController();
  final notesController = TextEditingController();

  final RxString selectedCountryCode = '+1'.obs;
  final RxInt formResetKey = 0.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    businessNameController.dispose();
    notesController.dispose();
    super.onClose();
  }

  bool _validateInput() {
    final name = fullNameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty) {
      SnackbarHelper.showError('Please enter a full name.');
      return false;
    }
    if (phone.isEmpty) {
      SnackbarHelper.showError('Please enter a phone number.');
      return false;
    }
    return true;
  }

  ContactModel _buildContactModel() {
    final name = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    // Format phone with country code
    final formattedPhone = phone.startsWith('+') 
        ? phone 
        : '${selectedCountryCode.value} $phone';

    // Generate initials from name
    final initials = name
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();

    // Colors list for random avatar assignment
    final List<Color> colors = [
      const Color(0xFFEF4444),
      const Color(0xFF7C3AED),
      const Color(0xFF3B82F6),
      const Color(0xFF22C55E),
      const Color(0xFFF59E0B),
      const Color(0xFF2563EB),
    ];
    final avatarColor = colors[name.length % colors.length];

    return ContactModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      initials: initials.isEmpty ? '?' : initials,
      phone: formattedPhone,
      email: email,
      status: 'New',
      avatarColor: avatarColor,
      statusColor: const Color(0xFF3B82F6), // New status color (blue)
    );
  }

  void saveContact() {
    if (!_validateInput()) return;

    try {
      final newContact = _buildContactModel();
      final listController = Get.find<ContactsListController>();
      listController.contacts.insert(0, newContact);

      SnackbarHelper.showSuccess('Contact saved successfully!');
      clearForm();
      Get.back();
    } catch (e) {
      SnackbarHelper.showError('Failed to save contact: $e');
    }
  }

  void addAnotherContact() {
    if (!_validateInput()) return;

    try {
      final newContact = _buildContactModel();
      final listController = Get.find<ContactsListController>();
      listController.contacts.insert(0, newContact);

      SnackbarHelper.showSuccess('Contact added! Ready for next.');
      clearForm();
    } catch (e) {
      SnackbarHelper.showError('Failed to add contact: $e');
    }
  }

  void clearForm() {
    fullNameController.clear();
    phoneController.clear();
    emailController.clear();
    businessNameController.clear();
    notesController.clear();
    selectedCountryCode.value = '+1';
    formResetKey.value++;
  }
}
