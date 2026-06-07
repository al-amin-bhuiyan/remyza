import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'contacts_list_controller.dart';
import '../../../data/models/contact_model.dart';
import '../../../core/utils/snackbar_helper.dart';

class EditContactController extends GetxController {
  late final String contactId;
  late final ContactModel originalContact;

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();

  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedStatus = 'New'.obs;
  final Rx<Color> selectedAvatarColor = const Color(0xFF3B82F6).obs;
  final RxnString customImagePath = RxnString(); // mock custom uploaded image

  final List<Color> avatarColors = [
    const Color(0xFFEF4444),
    const Color(0xFF7C3AED),
    const Color(0xFF3B82F6),
    const Color(0xFF22C55E),
    const Color(0xFFF59E0B),
    const Color(0xFF2563EB),
    const Color(0xFF0F172A),
    const Color(0xFFEC4899),
  ];

  @override
  void onInit() {
    super.onInit();
    // Get parameter from routing arguments or current parameters
    final params = Get.parameters;
    contactId = params['id'] ?? '';
    
    final listController = Get.find<ContactsListController>();
    final contact = listController.contacts.firstWhere(
      (c) => c.id == contactId,
      orElse: () => const ContactModel(
        id: '',
        name: '',
        initials: '?',
        phone: '',
        email: '',
        status: 'New',
        avatarColor: Color(0xFF3B82F6),
        statusColor: Color(0xFF94A3B8),
      ),
    );

    originalContact = contact;

    // Initialize editing states
    fullNameController.text = contact.name;
    emailController.text = contact.email;
    selectedStatus.value = contact.status;
    selectedAvatarColor.value = contact.avatarColor;
    customImagePath.value = contact.imagePath;

    // Parse phone and country code
    String rawPhone = contact.phone;
    if (rawPhone.startsWith('+')) {
      final spaceIndex = rawPhone.indexOf(' ');
      if (spaceIndex != -1) {
        selectedCountryCode.value = rawPhone.substring(0, spaceIndex);
        phoneController.text = rawPhone.substring(spaceIndex + 1);
      } else {
        // Try guessing standard country codes
        if (rawPhone.startsWith('+1')) {
          selectedCountryCode.value = '+1';
          phoneController.text = rawPhone.substring(2).trim();
        } else {
          phoneController.text = rawPhone;
        }
      }
    } else {
      phoneController.text = rawPhone;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void selectAvatarColor(Color color) {
    selectedAvatarColor.value = color;
  }

  final RxBool isPickingImage = false.obs;
  final _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      isPickingImage.value = true;
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 600,
        maxHeight: 600,
      );
      if (picked != null) {
        customImagePath.value = picked.path;
        SnackbarHelper.showSuccess('Profile photo updated!');
      }
    } catch (e) {
      SnackbarHelper.showError('Could not pick image: $e');
    } finally {
      isPickingImage.value = false;
    }
  }

  void removePhoto() {
    customImagePath.value = null;
    SnackbarHelper.showSuccess('Profile photo removed.');
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

  void saveContact() {
    if (!_validateInput()) return;

    try {
      final name = fullNameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();

      // Format phone
      final formattedPhone = phone.startsWith('+') 
          ? phone 
          : '${selectedCountryCode.value} $phone';

      // Generate initials
      final initials = name
          .split(' ')
          .where((e) => e.isNotEmpty)
          .map((e) => e[0])
          .take(2)
          .join()
          .toUpperCase();

      Color statusColor;
      switch (selectedStatus.value.toLowerCase()) {
        case 'active':
          statusColor = const Color(0xFF22C55E);
          break;
        case 'new':
          statusColor = const Color(0xFF3B82F6);
          break;
        case 'no reply':
        default:
          statusColor = const Color(0xFF94A3B8);
          break;
      }

      final updatedContact = originalContact.copyWith(
        name: name,
        phone: formattedPhone,
        email: email,
        initials: initials.isEmpty ? '?' : initials,
        status: selectedStatus.value,
        avatarColor: selectedAvatarColor.value,
        statusColor: statusColor,
        imagePath: customImagePath.value,
      );

      final listController = Get.find<ContactsListController>();
      listController.updateContact(updatedContact);

      SnackbarHelper.showSuccess('Contact updated successfully!');
      Get.back();
    } catch (e) {
      SnackbarHelper.showError('Failed to save changes: $e');
    }
  }

  void deleteContact() {
    try {
      final listController = Get.find<ContactsListController>();
      listController.deleteContact(contactId);
      SnackbarHelper.showSuccess('Contact deleted successfully.');
      Get.back();
    } catch (e) {
      SnackbarHelper.showError('Failed to delete contact: $e');
    }
  }
}
