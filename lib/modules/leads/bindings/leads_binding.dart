import 'package:get/get.dart';
import '../../../../core/interfaces/i_leads_repository.dart';
import '../../../../data/repositories/leads_repository_impl.dart';
import '../controllers/leads_list_controller.dart';

class LeadsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ILeadsRepository>()) {
      Get.lazyPut<ILeadsRepository>(() => LeadsRepositoryImpl());
    }
    Get.lazyPut<LeadsListController>(
      () => LeadsListController(Get.find<ILeadsRepository>()),
    );
  }
}
