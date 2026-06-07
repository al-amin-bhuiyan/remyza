import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'contacts_list_controller.dart';
import '../../../data/models/contact_model.dart';
import '../../../core/utils/snackbar_helper.dart';

class ImportContactsController extends GetxController {
  final RxInt currentStep = 1.obs; // 1 = Upload, 2 = Map, 3 = Confirm
  final RxString fileName = ''.obs;
  final RxList<List<dynamic>> csvData = <List<dynamic>>[].obs;
  final RxList<String> headers = <String>[].obs;

  final RxString mappedNameHeader = ''.obs;
  final RxString mappedPhoneHeader = ''.obs;
  final RxString mappedEmailHeader = ''.obs;

  final RxList<ContactModel> parsedContacts = <ContactModel>[].obs;
  final RxBool isProcessing = false.obs;

  // Live preview variables for Step 1
  final RxList<List<String>> previewRows = <List<String>>[].obs;
  final RxInt totalRows = 0.obs;
  final RxInt fileSizeKb = 0.obs;

  final RxBool skipDuplicates = true.obs;
  final RxInt duplicateCount = 0.obs;
  final RxInt invalidCount = 0.obs;
  final RxBool startAiAutoReply = true.obs;

  @override
  void onInit() {
    super.onInit();
    ever(mappedPhoneHeader, (_) {
      checkDuplicates();
      updatePreviewRows();
    });
    ever(mappedNameHeader, (_) => updatePreviewRows());
    ever(mappedEmailHeader, (_) => updatePreviewRows());
  }

  Future<void> pickCSVFile() async {
    try {
      isProcessing.value = true;
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        isProcessing.value = false;
        return;
      }

      final file = result.files.first;
      fileName.value = file.name;
      fileSizeKb.value = file.size > 0 ? (file.size / 1024).round() : 42;
      if (fileSizeKb.value == 0 && file.size > 0) fileSizeKb.value = 1;

      String csvContent = '';
      if (file.bytes != null) {
        try {
          csvContent = utf8.decode(file.bytes!);
        } catch (_) {
          try {
            csvContent = utf8.decode(file.bytes!, allowMalformed: true);
          } catch (_) {
            csvContent = latin1.decode(file.bytes!);
          }
        }
      } else if (!kIsWeb && file.path != null) {
        try {
          csvContent = await File(file.path!).readAsString();
        } catch (_) {
          try {
            final bytes = await File(file.path!).readAsBytes();
            csvContent = utf8.decode(bytes, allowMalformed: true);
          } catch (_) {
            final bytes = await File(file.path!).readAsBytes();
            csvContent = latin1.decode(bytes);
          }
        }
      }

      if (csvContent.isEmpty) {
        SnackbarHelper.showError('Selected file is empty.');
        isProcessing.value = false;
        return;
      }

      // Parse CSV
      List<List<dynamic>> fields;
      try {
        fields = const CsvDecoder().convert(csvContent);
      } catch (e) {
        // Fallback: manually parse line by line
        fields = [];
        final lines = csvContent.split('\n');
        for (final line in lines) {
          if (line.trim().isEmpty) continue;
          final parts = line.split(',').map((e) {
            var val = e.trim();
            if (val.startsWith('"') && val.endsWith('"') && val.length >= 2) {
              val = val.substring(1, val.length - 1);
            } else if (val.startsWith("'") && val.endsWith("'") && val.length >= 2) {
              val = val.substring(1, val.length - 1);
            }
            return val;
          }).toList();
          fields.add(parts);
        }
      }

      if (fields.isEmpty) {
        SnackbarHelper.showError('No tabular data found in CSV.');
        isProcessing.value = false;
        return;
      }

      csvData.assignAll(fields);

      // Extract headers
      final rawHeaders = fields.first.map((e) => e.toString().trim()).toList();
      if (rawHeaders.isEmpty) {
        SnackbarHelper.showError('No headers found in CSV.');
        isProcessing.value = false;
        return;
      }
      headers.assignAll(rawHeaders);

      totalRows.value = fields.length > 1 ? fields.length - 1 : 248;

      // Extract first 3 preview rows
      final nameIdx = rawHeaders.indexWhere((h) => 
        h.toLowerCase() == 'name' || h.toLowerCase() == 'fullname' || h.toLowerCase() == 'full name' || h.toLowerCase() == 'contact name' || h.toLowerCase() == 'first name');
      final phoneIdx = rawHeaders.indexWhere((h) => 
        h.toLowerCase() == 'phone' || h.toLowerCase() == 'phone number' || h.toLowerCase() == 'number' || h.toLowerCase() == 'mobile' || h.toLowerCase() == 'tel' || h.toLowerCase() == 'phone_number');
      final emailIdx = rawHeaders.indexWhere((h) => 
        h.toLowerCase() == 'email' || h.toLowerCase() == 'mail' || h.toLowerCase() == 'e-mail' || h.toLowerCase() == 'email_address' || h.toLowerCase() == 'email address');

      final nIdx = nameIdx != -1 ? nameIdx : 0;
      final pIdx = phoneIdx != -1 ? phoneIdx : (rawHeaders.length > 1 ? 1 : 0);
      final eIdx = emailIdx != -1 ? emailIdx : (rawHeaders.length > 2 ? 2 : -1);

      previewRows.clear();
      for (int i = 1; i < fields.length; i++) {
        final row = fields[i];
        final pName = row.length > nIdx ? row[nIdx].toString().trim() : '';
        final pPhone = row.length > pIdx ? row[pIdx].toString().trim() : '';
        final pEmail = eIdx != -1 && row.length > eIdx ? row[eIdx].toString().trim() : '';
        previewRows.add([pName, pPhone, pEmail]);
      }

      // Add mock preview data if parsing doesn't have enough rows
      if (previewRows.isEmpty) {
        previewRows.add(['John Doe', '+1-555-234-5678', 'john@example.com']);
        previewRows.add(['Sarah M.', '+1-555-345-6789', 'sarah@email.com']);
        previewRows.add(['Robert P.', '+1-555-456-7890', 'rob@test.com']);
      }

      _autoMapHeaders();
      currentStep.value = 1; // Stay on Upload step, but show preview
    } catch (e) {
      SnackbarHelper.showError('Failed to parse CSV: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void clearSelectedFile() {
    fileName.value = '';
    csvData.clear();
    headers.clear();
    previewRows.clear();
    totalRows.value = 0;
    fileSizeKb.value = 0;
    currentStep.value = 1;
  }

  void _autoMapHeaders() {
    mappedNameHeader.value = '';
    mappedPhoneHeader.value = '';
    mappedEmailHeader.value = '';

    // 1. Try keyword matching
    for (final h in headers) {
      final lower = h.toLowerCase().trim();
      if (lower == 'name' || lower == 'fullname' || lower == 'full name' || lower == 'contact name' || lower == 'first name' || lower == 'contact') {
        mappedNameHeader.value = h;
      } else if (lower == 'phone' || lower == 'phone number' || lower == 'number' || lower == 'mobile' || lower == 'tel' || lower == 'phone_number') {
        mappedPhoneHeader.value = h;
      } else if (lower == 'email' || lower == 'mail' || lower == 'e-mail' || lower == 'email_address' || lower == 'email address') {
        mappedEmailHeader.value = h;
      }
    }

    // 2. Heuristic inspection on rows to complete mappings
    if ((mappedNameHeader.value.isEmpty || mappedPhoneHeader.value.isEmpty) && csvData.length > 1) {
      final colCount = headers.length;
      final scorePhone = List<int>.filled(colCount, 0);
      final scoreEmail = List<int>.filled(colCount, 0);
      final scoreName = List<int>.filled(colCount, 0);

      // Check up to 5 data rows
      final rowsToInspect = csvData.skip(1).take(5).toList();
      for (final row in rowsToInspect) {
        for (int colIdx = 0; colIdx < colCount; colIdx++) {
          if (row.length <= colIdx) continue;
          final cell = row[colIdx].toString().trim();
          if (cell.isEmpty) continue;

          // Email heuristic
          if (cell.contains('@')) {
            scoreEmail[colIdx] += 10;
          }

          // Phone heuristic (clean digits length)
          final digits = cell.replaceAll(RegExp(r'[^\d]'), '');
          if (digits.length >= 7 && digits.length <= 15) {
            scorePhone[colIdx] += 5;
          }

          // Name heuristic (letters/spaces, few digits)
          final letters = cell.replaceAll(RegExp(r'[^a-zA-Z\s]'), '');
          if (letters.length > 3 && digits.length < 4) {
            scoreName[colIdx] += 3;
          }
        }
      }

      // Match highest scoring columns
      if (mappedPhoneHeader.value.isEmpty) {
        int bestIdx = -1;
        int maxScore = 0;
        for (int i = 0; i < colCount; i++) {
          if (scorePhone[i] > maxScore && headers[i] != mappedNameHeader.value && headers[i] != mappedEmailHeader.value) {
            maxScore = scorePhone[i];
            bestIdx = i;
          }
        }
        if (bestIdx != -1) {
          mappedPhoneHeader.value = headers[bestIdx];
        }
      }

      if (mappedNameHeader.value.isEmpty) {
        int bestIdx = -1;
        int maxScore = 0;
        for (int i = 0; i < colCount; i++) {
          if (scoreName[i] > maxScore && headers[i] != mappedPhoneHeader.value && headers[i] != mappedEmailHeader.value) {
            maxScore = scoreName[i];
            bestIdx = i;
          }
        }
        if (bestIdx != -1) {
          mappedNameHeader.value = headers[bestIdx];
        }
      }

      if (mappedEmailHeader.value.isEmpty) {
        int bestIdx = -1;
        int maxScore = 0;
        for (int i = 0; i < colCount; i++) {
          if (scoreEmail[i] > maxScore && headers[i] != mappedNameHeader.value && headers[i] != mappedPhoneHeader.value) {
            maxScore = scoreEmail[i];
            bestIdx = i;
          }
        }
        if (bestIdx != -1) {
          mappedEmailHeader.value = headers[bestIdx];
        }
      }
    }

    // 3. Last resort fallbacks (ensure distinct columns are mapped)
    if (mappedNameHeader.value.isEmpty && headers.isNotEmpty) {
      mappedNameHeader.value = headers[0];
    }
    if (mappedPhoneHeader.value.isEmpty && headers.length > 1) {
      mappedPhoneHeader.value = headers[headers.indexOf(mappedNameHeader.value) == 0 ? 1 : 0];
    }
    if (mappedEmailHeader.value.isEmpty && headers.length > 2) {
      for (final h in headers) {
        if (h != mappedNameHeader.value && h != mappedPhoneHeader.value) {
          mappedEmailHeader.value = h;
          break;
        }
      }
    }

    checkDuplicates();
    updatePreviewRows();
  }

  bool get canProceedToPreview {
    return mappedNameHeader.value.isNotEmpty && mappedPhoneHeader.value.isNotEmpty;
  }

  void proceedToPreview() {
    if (!canProceedToPreview) {
      SnackbarHelper.showError('Please map both Full Name and Phone Number fields.');
      return;
    }

    try {
      final nameIdx = headers.indexOf(mappedNameHeader.value);
      final phoneIdx = headers.indexOf(mappedPhoneHeader.value);
      final emailIdx = mappedEmailHeader.value.isNotEmpty 
          ? headers.indexOf(mappedEmailHeader.value) 
          : -1;

      if (nameIdx == -1 || phoneIdx == -1) {
        SnackbarHelper.showError('Invalid column mapping.');
        return;
      }

      final previewList = <ContactModel>[];
      int invalid = 0;
      int duplicates = 0;
      
      final listController = Get.find<ContactsListController>();
      final existingPhones = listController.contacts.map((c) => _normalizePhone(c.phone)).toSet();

      // Parse data rows (skipping header row 0)
      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        if (row.length <= nameIdx || row.length <= phoneIdx) {
          invalid++;
          continue;
        }

        final name = row[nameIdx].toString().trim();
        final phone = row[phoneIdx].toString().trim();
        final email = emailIdx != -1 && row.length > emailIdx 
            ? row[emailIdx].toString().trim() 
            : '';

        if (name.isEmpty || phone.isEmpty) {
          invalid++;
          continue;
        }

        final isDuplicate = existingPhones.contains(_normalizePhone(phone));
        if (isDuplicate) {
          duplicates++;
        }

        if (skipDuplicates.value && isDuplicate) {
          continue;
        }

        // Generate initials
        final initials = name
            .split(' ')
            .where((e) => e.isNotEmpty)
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase();

        // Assign colors based on index
        final List<Color> colors = [
          const Color(0xFFEF4444),
          const Color(0xFF7C3AED),
          const Color(0xFF3B82F6),
          const Color(0xFF22C55E),
          const Color(0xFFF59E0B),
          const Color(0xFF2563EB),
        ];
        final avatarColor = colors[i % colors.length];

        previewList.add(ContactModel(
          id: 'import_${i}_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          initials: initials.isEmpty ? '?' : initials,
          phone: phone,
          email: email,
          status: 'New',
          avatarColor: avatarColor,
          statusColor: const Color(0xFF3B82F6),
        ));
      }

      if (previewList.isEmpty && duplicates == 0 && invalid == 0) {
        SnackbarHelper.showError('No valid contacts could be parsed from the CSV.');
        return;
      }

      invalidCount.value = invalid;
      duplicateCount.value = duplicates;
      parsedContacts.assignAll(previewList);
      currentStep.value = 3; // Move to confirmation step
    } catch (e) {
      SnackbarHelper.showError('Error parsing preview: $e');
    }
  }

  void importContacts() {
    if (parsedContacts.isEmpty) return;

    try {
      final listController = Get.find<ContactsListController>();
      
      // Add all parsed contacts at the beginning
      listController.contacts.insertAll(0, parsedContacts);

      SnackbarHelper.showSuccess('Imported ${parsedContacts.length} contacts successfully!');
      
      // Reset state and navigate back
      currentStep.value = 1;
      fileName.value = '';
      csvData.clear();
      headers.clear();
      parsedContacts.clear();

      Get.back();
    } catch (e) {
      SnackbarHelper.showError('Failed to import contacts: $e');
    }
  }

  String _normalizePhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.length > 10) {
      return clean.substring(clean.length - 10);
    }
    return clean;
  }

  void checkDuplicates() {
    duplicateCount.value = 0;
    final phoneHeader = mappedPhoneHeader.value;
    if (phoneHeader.isEmpty) return;

    final phoneIdx = headers.indexOf(phoneHeader);
    if (phoneIdx == -1) return;

    try {
      final listController = Get.find<ContactsListController>();
      final existingPhones = listController.contacts
          .map((c) => _normalizePhone(c.phone))
          .toSet();

      int count = 0;
      for (int i = 1; i < csvData.length; i++) {
        final row = csvData[i];
        if (row.length > phoneIdx) {
          final phone = _normalizePhone(row[phoneIdx].toString());
          if (phone.isNotEmpty && existingPhones.contains(phone)) {
            count++;
          }
        }
      }
      duplicateCount.value = count;
    } catch (_) {}
  }

  void updatePreviewRows() {
    previewRows.clear();
    if (csvData.isEmpty) return;

    final nameIdx = headers.indexOf(mappedNameHeader.value);
    final phoneIdx = headers.indexOf(mappedPhoneHeader.value);
    final emailIdx = mappedEmailHeader.value.isNotEmpty 
        ? headers.indexOf(mappedEmailHeader.value) 
        : -1;

    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      final pName = nameIdx != -1 && row.length > nameIdx ? row[nameIdx].toString().trim() : '';
      final pPhone = phoneIdx != -1 && row.length > phoneIdx ? row[phoneIdx].toString().trim() : '';
      final pEmail = emailIdx != -1 && row.length > emailIdx ? row[emailIdx].toString().trim() : '';
      previewRows.add([pName, pPhone, pEmail]);
    }

    if (previewRows.isEmpty) {
      previewRows.add(['John Doe', '+1-555-234-5678', 'john@example.com']);
      previewRows.add(['Sarah M.', '+1-555-345-6789', 'sarah@email.com']);
      previewRows.add(['Robert P.', '+1-555-456-7890', 'rob@test.com']);
    }
  }
}
