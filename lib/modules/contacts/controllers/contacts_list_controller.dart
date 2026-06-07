import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/contact_model.dart';

class ContactsListController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<ContactModel> contacts = <ContactModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockContacts();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<ContactModel> get filteredContacts {
    if (searchQuery.value.trim().isEmpty) {
      return contacts;
    }
    final query = searchQuery.value.toLowerCase();
    return contacts.where((c) {
      return c.name.toLowerCase().contains(query) ||
          c.phone.replaceAll(RegExp(r'\D'), '').contains(query) ||
          c.phone.contains(query);
    }).toList();
  }

  void _loadMockContacts() {
    contacts.assignAll([
      const ContactModel(
        id: '1',
        name: 'John Doe',
        initials: 'JD',
        phone: '+1 (555) 234-5678',
        email: 'john.doe@example.com',
        status: 'Active',
        avatarColor: Color(0xFFEF4444),
        statusColor: Color(0xFF22C55E),
      ),
      const ContactModel(
        id: '2',
        name: 'Sarah Mitchell',
        initials: 'SM',
        phone: '+1 (555) 345-6789',
        email: 'sarah.m@example.com',
        status: 'Active',
        avatarColor: Color(0xFF7C3AED),
        statusColor: Color(0xFF22C55E),
      ),
      const ContactModel(
        id: '3',
        name: 'Robert Park',
        initials: 'RP',
        phone: '+1 (555) 456-7890',
        email: 'robert.p@example.com',
        status: 'No Reply',
        avatarColor: Color(0xFF3B82F6),
        statusColor: Color(0xFF94A3B8),
      ),
      const ContactModel(
        id: '4',
        name: 'Amy Lin',
        initials: 'AL',
        phone: '+1 (555) 567-8901',
        email: 'amy.lin@example.com',
        status: 'New',
        avatarColor: Color(0xFF22C55E),
        statusColor: Color(0xFF3B82F6),
      ),
      const ContactModel(
        id: '5',
        name: 'Tom Kim',
        initials: 'TK',
        phone: '+1 (555) 678-9012',
        email: 'tom.kim@example.com',
        status: 'Active',
        avatarColor: Color(0xFFF59E0B),
        statusColor: Color(0xFF22C55E),
      ),
      const ContactModel(
        id: '6',
        name: 'Maria Brown',
        initials: 'MB',
        phone: '+1 (555) 789-0123',
        email: 'maria.b@example.com',
        status: 'Active',
        avatarColor: Color(0xFF2563EB),
        statusColor: Color(0xFF22C55E),
      ),
    ]);
  }

  void updateContact(ContactModel updated) {
    final idx = contacts.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      contacts[idx] = updated;
      contacts.refresh();
    }
  }

  void deleteContact(String id) {
    contacts.removeWhere((c) => c.id == id);
  }
}
