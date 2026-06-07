import 'package:get/get.dart';
import '../../../../core/interfaces/i_leads_repository.dart';
import '../../../../data/models/lead_model.dart';

class LeadsListController extends GetxController {
  final ILeadsRepository _repository;

  LeadsListController(this._repository);

  final RxList<LeadModel> leads = <LeadModel>[].obs;
  final RxString selectedFilter = 'all'.obs;
  final RxBool isLoading = false.obs;

  int get hotCount =>
      leads.where((l) => l.status.toLowerCase() == 'hot').length;
  int get warmCount =>
      leads.where((l) => l.status.toLowerCase() == 'warm').length;
  int get coldCount =>
      leads.where((l) => l.status.toLowerCase() == 'cold').length;

  List<LeadModel> get filteredLeads {
    final filter = selectedFilter.value.toLowerCase();
    if (filter == 'all') return leads.toList();
    return leads.where((l) => l.status.toLowerCase() == filter).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadLeads();
  }

  Future<void> loadLeads() async {
    try {
      isLoading.value = true;
      final list = await _repository.getLeads();
      leads.assignAll(list);
    } catch (e) {
      Get.log('Error loading leads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }
}
