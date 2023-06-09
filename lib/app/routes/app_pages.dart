import 'package:get/get.dart';

import '../modules/add_split/bindings/add_split_binding.dart';
import '../modules/add_split/views/add_split_view.dart';
import '../modules/add_split_group/bindings/add_split_group_binding.dart';
import '../modules/add_split_group/views/add_split_group_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/sign_in_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chat_group/bindings/chat_group_binding.dart';
import '../modules/chat_group/views/chat_group_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SPLIT,
      page: () => const AddSplitView(),
      binding: AddSplitBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.ADD_SPLIT_GROUP,
      page: () => const AddSplitGroupView(),
      binding: AddSplitGroupBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_GROUP,
      page: () => const ChatGroupView(),
      binding: ChatGroupBinding(),
    ),
  ];
}
