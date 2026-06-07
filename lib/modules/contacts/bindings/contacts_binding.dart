import 'package:get/get.dart';
import '../controllers/contacts_list_controller.dart';
import '../controllers/contact_form_controller.dart';
import '../controllers/import_contacts_controller.dart';
import '../controllers/edit_contact_controller.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsListController>(() => ContactsListController());
    Get.lazyPut<ContactFormController>(() => ContactFormController());
    Get.lazyPut<ImportContactsController>(() => ImportContactsController());
    Get.lazyPut<EditContactController>(() => EditContactController());
  }
}

