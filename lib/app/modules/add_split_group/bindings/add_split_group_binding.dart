import 'package:get/get.dart';

import 'package:bill_split/app/modules/add_split_group/controllers/split_expense_group_controller.dart';

import '../controllers/add_split_group_controller.dart';

class AddSplitGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplitExpenseGroupController>(
      () => SplitExpenseGroupController(),
    );
    Get.lazyPut<AddSplitGroupController>(
      () => AddSplitGroupController(),
    );
  }
}
