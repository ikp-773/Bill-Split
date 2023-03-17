import 'package:get/get.dart';

import '../controllers/chat_group_controller.dart';

class ChatGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatGroupController>(
      () => ChatGroupController(),
    );
  }
}
