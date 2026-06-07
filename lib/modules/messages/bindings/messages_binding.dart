import 'package:get/get.dart';
import '../../../../core/interfaces/i_messages_repository.dart';
import '../../../../data/repositories/messages_repository_impl.dart';
import '../controllers/conversation_list_controller.dart';
import '../controllers/new_message_controller.dart';

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IMessagesRepository>(() => MessagesRepositoryImpl());
    Get.lazyPut<ConversationListController>(
      () => ConversationListController(Get.find<IMessagesRepository>()),
    );
    Get.lazyPut<NewMessageController>(
      () => NewMessageController(Get.find<IMessagesRepository>()),
    );
  }
}
