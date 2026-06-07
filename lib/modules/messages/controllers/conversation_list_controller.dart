import 'package:get/get.dart';
import '../../../../core/interfaces/i_messages_repository.dart';
import '../../../../data/models/conversation_model.dart';

class ConversationListController extends GetxController {
  final IMessagesRepository _repository;

  ConversationListController(this._repository);

  final RxList<ConversationModel> conversations = <ConversationModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedTab = 'All'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      final list = await _repository.getConversations();
      conversations.assignAll(list);
    } catch (e) {
      Get.log('Error loading conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<ConversationModel> get filteredConversations {
    List<ConversationModel> result = conversations;

    // Filter by tab
    final tab = selectedTab.value.toLowerCase();
    if (tab == 'hot') {
      result = result.where((c) => c.leadStatus.toLowerCase() == 'hot').toList();
    } else if (tab == 'unread') {
      result = result.where((c) => c.unreadCount > 0).toList();
    } else if (tab == 'archived') {
      // Mock archived: return empty list for now as repository has no archived items
      result = [];
    }

    // Filter by search query
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((c) {
        final nameMatch = c.name.toLowerCase().contains(query);
        final msgMatch = c.lastMessage.toLowerCase().contains(query);
        return nameMatch || msgMatch;
      }).toList();
    }

    return result;
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  void setSearchQuery(String val) {
    searchQuery.value = val;
  }
}
