import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:country_picker/country_picker.dart';

class ProfileController extends GetxController {
  final fullNameController = TextEditingController(text: 'Alex Johnson');
  final emailController = TextEditingController(text: 'alex@example.com');
  final phoneController = TextEditingController(text: '(555) 012-3456');
  final businessNameController = TextEditingController(text: 'Johnson Consulting');
  final businessTypeController = TextEditingController(text: 'Consulting');
  final timeZoneController = TextEditingController(text: 'EST (UTC-5)');

  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<Country> selectedCountry = Country.parse('US').obs;

  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  void pickCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        selectedCountry.value = country;
      },
    );
  }

  void saveProfile() {
    // Implement save logic here
    Get.snackbar('Success', 'Profile updated successfully!', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    businessNameController.dispose();
    businessTypeController.dispose();
    timeZoneController.dispose();
    super.onClose();
  }
}

